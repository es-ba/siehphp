"use strict";

var _ = require('lodash');
var express = require('express');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var Promise = require('promise');
var fsPromise = require('fs-promise');
var PGBlueBird = require('pg-bluebird');
var pgPromise = require('pg-promise');
var pgPure = require('pg');
var jsToHtml = require('js-to-html');
var Tabulator = require('tabulator');
var stripBom = require('strip-bom');

var port=3000;

var app = express();
app.use(cookieParser());
app.use(bodyParser.urlencoded({extended:true}));

function quitarBomSiHay(string){
    var BOM=/\\ufffe/;
    if(string.match(BOM)){
        string=string.replace(BOM,'');
    }
    return string;
}

function readJson(fileName){
    return fsPromise.readFile(fileName,{encoding:'utf8'}).then(function(json){
        return JSON.parse(json);
    });
}

var html=jsToHtml.html;
jsToHtml.Html.prototype.middleware=function(){
    var thisHtml=this;
    return function(req,res){
        res.send(thisHtml.toHtmlText({pretty:true}));
        res.end();
    }
}

var inte={
    sqlNames:function(sql, values){
        return sql.replace(/#(\w+)\b/g,function(match,name){
            var regExpVariable=/^[a-zA-Z]\w*$/;
            if(!(name in values)){
                throw new Error(name+' expected not present');
            }
            if(!regExpVariable.test(values[name])){
                throw new Error(''+name+' is invalid');
            }
            return values[name];
        });
    }
};

(function(){////////////// SERVER BEGIN

var configuracion;
var pg;
var dbClient;

function sendError(res,err,num,req){
    res.write(html.div([
        html.h1({style:"color:red"}, "ERROR ("+num+")"),
        html.code(err.toString()),
        (req.ip=='127.0.0.1'?html.pre(err.stack):"")
    ]).toHtmlText());
};

var codigo_confirmacion;
function refrescar_codigo_confirmacion(){
    codigo_confirmacion=new Date().getTime();
}
refrescar_codigo_confirmacion();

function controlar_el_codigo_de_confirmacion(req,res){
    if(req.query.confirmar!=codigo_confirmacion && !configuracion.server.desarrollo){
        res.send(html.h1("Código de confirmación inválido").toHtmlText());
        res.end();
        throw new Error("proceso interrumpido");
    }
}

function avisar(res,mensaje,opciones){
    res.write(html.pre(opciones||{}, mensaje).toHtmlText());
}

var Prometheus={
    erd:function(object, functionName, parameters){
        return new Promise(function(resolve, reject){
            var parametersWithEndFunction=parameters.concat(function(err,res,end){
                if (err) reject(err);
                else resolve(res);
            });
            object[functionName].apply(object,parametersWithEndFunction);
        })
    }
}

readJson('configuracion-local.json').then(function(config){
    configuracion=config;
    var server = app.listen(configuracion.server.port, function() {
        console.log('Listening on port %d', server.address().port, app.get('env'));
    });
}).then(function(){
    console.log('connecting to db...');
    return Prometheus.erd(pgPure,'connect',[configuracion.db]);
}).then(function(conn){
    dbClient=conn;
    console.log('connected to DB ',configuracion.db.database);
    app.get('/sincronizar',html.div([
        html.h1("CUIDADO - Sincronización ETOI144"),
        html.p([
            html.a({href:'./empezar_sincronizacion?confirmar='+codigo_confirmacion},'arrancar'),
            " la sincronización",
        ])
    ]).middleware());
    app.get('/empezar_sincronizacion',function(req,res){
        controlar_el_codigo_de_confirmacion(req,res);
        avisar(res,"Empezando la sincronización...");
        avisar(res,"Leyendo el archivo...");
        Promise.resolve(true).then(function(){
            return fsPromise.readFile('fun_sincro_etoi144.sql',{encoding:'utf8'});
        }).then(function(sql){
            sql=stripBom(sql);
            if(!sql.match(/--FIN FUN/)){
                throw new Error('ERROR falta --FIN FUN en el .sql');
            }
            dbClient.on('notice', function(msg){
                avisar(res,msg.toString(),{style:"font-size:80%; color:blue"});
            });
            avisar(res,"Por ejecutar la sentencia...");
            var sqlRecortado=sql.replace(/--FIN FUN(.|[\n\r])*$/m,'');
            return Prometheus.erd(dbClient, 'query', [sqlRecortado]);
        }).then(function(){
            avisar(res,"ya fue cargada la función de sincronización");
            return Prometheus.erd(dbClient,'query',["select operaciones.sincro_etoi144($1,$2) as resultado",[configuracion.db.user, configuracion.db.password]]);
        }).then(function(data){
            avisar(res,data.rows[0].resultado);
        }).then(function(){
            avisar(res,"fin del proceso");
            res.end();
        }).catch(function(err){
            console.log('Recibi',err);
            sendError(res,err,1,req);
            res.end();
        })
    });
}).catch(function(err){
    console.log('Error instalando el servidor');
    console.log(err);
    console.log(err.stack);
    // throw err;
    process.exit();
});

/* ////////////////// END SERVER */ })();

var mTimeServerJs;
fsPromise.stat('server.js').then(function(stats){
    mTimeServerJs=stats.mtime;
});

function esperar(tiempo){
    var espearHasta=(new Date()).getTime()+tiempo;
    while((new Date()).getTime()<espearHasta); 
}

app.get('/about',function(req,res){
    var titulo='<h1>Tabulador</h1>';
    res.header("Content-Type", "text/html; charset=utf-8");    
    res.write(titulo);
    fsPromise.stat('server.js').then(function(stats){
        res.write('<table '+(mTimeServerJs.getTime()!=stats.mtime.getTime()?'style="color:red"':'')+'>')
        res.write('<tr><td>At start<td>'+mTimeServerJs);
        res.write('<tr><td>Last mod<td>'+stats.mtime);
        res.write('</table>')
        res.end();
    }).catch(function(err){
        res.write(''+err);
        res.end();
    });
});

app.get('/',function(req,res){
    res.send('¡Anda!');
});