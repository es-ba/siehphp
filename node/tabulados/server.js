"use strict";

var rolAutorizado = {
    procesamiento: true,
    programador: true
}

var _ = require('lodash');
var express = require('express');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var Promises = require('best-promise');
require('fs-extra');
var fs_ = require('fs');
var fs = require('fs-promise');
var pg = require('pg-promise-strict');
var jsToHtml = require('js-to-html');
var Tabulator = require('tabulator');
var numeral = require('numeral');
var PhpSessionMiddleware = require('php-session');

var SqlTools = require('sql-tools');
var MiniTools = require('mini-tools');

var app = express();
app.use(cookieParser());
app.use(bodyParser.urlencoded({extended:true}));

var cadenaLogs=Promises.start();

function sqlLog(message){
    cadenaLogs=cadenaLogs.then(function(){
        return fs.appendFile('sql.log',message+'\n',{encoding: 'utf-8'});
    });
}

function loguear(x){
    console.log('==========');
    console.log(x);
    return x;
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
    sqlNames:function(sql, values, values2, values3 /*,...*/ ){
        var sqlNamesArgs=arguments;
        function validateSqlName(name){
            var regExpVariable=/^[a-zA-Z]\w*$/;
            if(!regExpVariable.test(values[name])){
                throw new Error(''+name+' is invalid');
            }
        }
        return sql.replace(/#(\d*)([a-zA-Z]\w*)\b/g,function(match,number,name){
            values=sqlNamesArgs[number||1];
            if(!(name in values)){
                throw new Error(name+' expected not present');
            }
            validateSqlName(values[name]);
            return values[name];
        }).replace(/#(\d*),campos\b/g,function(match,number){
            values=sqlNamesArgs[number||1];
            values.forEach(function(name){ validateSqlName(name); });
            if(!values.length){
                return 'null';
            }
            return values.join(', ');
        });
    },
    sqlFiltro:function(sql, valorFiltro){
       // var varsPk = ['enc','hog','mie','exm'];
       var varsPk = {enc:true, hog:true, mie:true, exm:true};
       if(valorFiltro){
         var variables = valorFiltro.split(RegExp('<|>|=|<=|>=|\\band\\b|\\bor\\b|\\bis\\b|\\bnot\\b|\\bnull\\b')).
            map(function(elemento){return elemento.trim()}).
            filter(function(nombre){return RegExp(/^[a-zA-Z]\w*$/).test(nombre)});
         variables.forEach(function(elemento){
            // var prefijo = varsPk.some(function(varPk){return varPk==elemento;})?'a1.pla_':'pla_';
            var prefijo = varsPk[elemento]?'a1.pla_':'pla_';
            valorFiltro = valorFiltro.replace(new RegExp("\\b"+elemento+"\\b","i"),prefijo+elemento);
         });
         valorFiltro = "WHERE " + valorFiltro;
         console.log("Valor filtro ", valorFiltro);
       } else {valorFiltro = "";}
       return sql.replace(/#_filtro/,valorFiltro);
    }
};

(function(){////////////// SERVER BEGIN

var configuracion;

// parametros de php que se necesitan con mayor alcance
var ope_actual='falta determinar';
var ope_anio  ='2016';

var matchexpr = /(^[a-z]*)(\d+)/;
var ope_tipo='';
var p_estado=77;
var p_val_modo=ope_actual;
var params={};
// fin seteos

function exportarDatosTxt(destino, filas){
    console.log('por exportar');
    var out;
    function validate(data){
        if(/[\n\r;]/.test(data)){
            throw new Error('invalid chars in data "'+data+'"');
        }
    }
    function exportarLinea(linea){
        return out.write(_.map(linea, function(data){ validate(data); return data; }).join(';')+'\r\n',0,'utf8');
    }
    return Promises.start(function(){
        return fs.createWriteStream(destino);
    }).then(function(opendedFd){
        console.log('abriendo el archivo');
        out=opendedFd;
        return exportarLinea(Object.keys(filas[0]));
    }).then(function(){
        var cadenaPromesas=Promises.start();
        filas.forEach(function(fila){
            console.log(fila);
            cadenaPromesas=cadenaPromesas.then(function(){
                return exportarLinea(fila);
            });
        });
        return cadenaPromesas;
    }).then(function(){
        return out.end();
    });
}

function levantarUnTabuladoYCrearMatrix(client, params){
    var defs_tab_cel_tipo={
        comun      :{incluye_columna_en_select: true, calculo_coefvar:true},
        promedio   :{incluye_valor_numerador:true, con_denominador:true, denominador_sin_over:true },
        tasa       :{numerador_solo_valor_mayor_0: true, incluye_valor_numerador:true, con_denominador:true, denominador_sin_over:true},
        frecuencia :{calculo_coefvar:true, sin_campos_fila_coef:true},
        suma       :{incluye_valor_numerador:true, con_denominador:true, incluye_valor_denominador:true},
        mediana    :{}
    }
    var def_ponderadores= {
        comun         :'fexp',
        individual    :'fexpind',
        'ind. Lu a Vi':'fexpindlv',
        'ind. Sa a Do':'fexpindsd'
    };
    var ponderador=1;
    console.log ('val_modo ', p_val_modo);
    //console.log('ponderador ', ponderador);
    if(params.tra_expandido===true){
        ponderador=(params.tra_findividual!==''?'pla_' + def_ponderadores[params.tra_findividual]:
            (ope_tipo=='eah' && ope_anio>=2015?'eh.pla_fexp':'pla_fexp'));
    };
    var letra_zonal_de=function(campo){
        return(campo =='zona_3'|| campo =='zona_3_1'?'Z': (campo =='comuna'?'C':'T'));
    };
    var campo_zonal_de=function(campo){
            return letra_zonal_de(campo)=='T'?'0':'pla_'.campo;
    };

    var letra_y_campo_zonal=function (tab_fila1, tab_fila2){
        var zonal={};
        //version nueva, falta probar. Conservo orden de la version original
        //var def_letra_zonal={comuna:'C', zona_3:'Z', zona_3_1='Z'};
        //zonal['letra']=def_letra_zonal[tab_fila2]=='Z'||def_letra_zonal[tab_fila2]=='Z'?'Z': 
        //    def_letra_zonal[tab_fila1]=='C'||def_letra_zonal[tab_fila2]=='C'?'C':letra_zonal_de(tab_fila2);
        //zonal['campo']=def_letra_zonal[tab_fila1]?tab_fila1:tab_fila2;
        
        if (tab_fila1 =='comuna' || tab_fila1 =='zona_3'|| tab_fila1 =='zona_3_1' || 
            tab_fila2 =='comuna' || tab_fila2 =='zona_3'|| tab_fila2 =='zona_3_1'){
            if(tab_fila1 =='comuna' || tab_fila2 =='comuna'){
                zonal['letra']='C';
            };
            if(tab_fila1 =='zona_3'|| tab_fila1 =='zona_3_1' ||  tab_fila2 =='zona_3'|| tab_fila2 =='zona_3_1'){
                zonal['letra']='Z';
            };
            if(tab_fila1 =='comuna' || tab_fila1 =='zona_3'|| tab_fila1 =='zona_3_1'){
                zonal['campo']=tab_fila1;
            }else{
                zonal['campo']=tab_fila2;
            }; 
        }else{
            zonal['letra']=letra_zonal_de(tab_fila2); // tab_fila1 y tab_fila2 ninguna es comuna ó zona_3 ó zona_3_1
            zonal['campo']=campo_zonal_de(tab_fila2); 
        };
        console.log( 'LC  zonal:', JSON.stringify(zonal));
        return zonal;
    };
    var tabla_coefvar=function(con_cv,t_tipo, t_columna, t_cel_exp){
        return (con_cv ? (t_tipo=='frecuencia' && t_columna=='hog'?'hogares':t_cel_exp ):'');
    };
      /* v php cv para stotales-if($tra_coefvar_normal_tasa){
                                    return "dbo.coef_var_tab_tasa('".$td->tab_cel_exp. "',".
                                        " '".$expresion_completadora." , sum(x.pla_cantidad),".
                                        " '".$expresion_completadora." , sum(sum(x.pla_cantidad)) over (".
                                            ($campos_groupby?"partition by ".implode(',',$campos_groupby):'').
                                        ")".
                                        ")";
                                }else{
                                    return "dbo.coef_var_tab('".$td->tab_cel_exp. "',".
                                        " '".$expresion_completadora." , sum(x.pla_cantidad))";
                                }
    */
    
    var parte_campos_coefvar=function(estotal,grupo_zona, campo_zona, p_coef_en_numero,p_coefvar_normal_tasa, tabla_tab, campos_fila){
        //deberia sacar parte letra
        var formula;
        var campo_coef;
        var v_zona= grupo_zona=='T'?campo_zona:"pla_"+campo_zona;
        if((estotal ||Array.isArray(campos_fila)) && p_coefvar_normal_tasa){
                formula="dbo.coef_var_tab_tasa('"+tabla_tab+ "', '" +grupo_zona+ "' ,"+v_zona+" , sum(#3fexp)"+
                    ", '" +grupo_zona+ "' ,"+v_zona+" , sum(sum(#3fexp)) over ("+
                        (campos_fila?"partition by "+ campos_fila.join(','):'')+
                    "))";
        }else{
                formula="dbo.coef_var_tab('"+tabla_tab+ "', '" +grupo_zona+ "' ,"+v_zona+" , sum(#3fexp))";
        };
        if(p_coef_en_numero){
            campo_coef=formula;
        }else{
            campo_coef= "case when "+formula+"<10 then ''  when "+formula+" between 10 and 20  then 'a' when "+formula+">20 then 'b' end"; 
        };
        //console.log('campo_coef:', campo_coef, ' formula:', formula); 
        return campo_coef;
    };
    var coefvar_a_letra=function(val_coefvar){
        return (val_coefvar >20?'b':(val_coefvar >=10 && val_coefvar <=20?'a':'')  );
    };
    
    var tabulator=new Tabulator();
    var datum;
    var parametrosSQL=[];
    var tabulado;
    var nombreVarsGroupBy;
    var filtro;
    var valNuloCoalesce=-2;
    p_estado =params.tra_estado;
    //p_coefvar=params.tra_coefvar;
    
    return Promises.start(function(){
        return client.query("SELECT * FROM encu.tabulados WHERE tab_tab = $1",[params.tra_tab]).fetchUniqueRow();
    }).then(function(result){
        if(result.row.tab_cel_tipo=='multiple'){
            return Promises.start(function(){
                return client.query(
                    "SELECT * FROM encu.tabulados WHERE tab_tab like $1 || '%' and tab_cel_tipo <> 'multiple' order by tab_tab",
                    [params.tra_tab]
                ).fetchAll();
            }).then(function(result_tabulados){
                console.log('********************',result_tabulados);
                return Promises.all(
                    result_tabulados.rows.map(function(row_tabulado){
                        return levantarUnTabuladoYCrearMatrix(client, {tra_tab: row_tabulado.tab_tab});
                    })
                );
            }).then(function(matrixList){
                return tabulator.matrixJoin(matrixList);
            });
        }else{
            return Promises.start(function(){
                tabulado=result.row;
                datum={ vars:[] };
                datum.vars.push({name: tabulado.tab_fila1  , place: 'left'});
                if(tabulado.tab_fila2){
                    datum.vars.push({name: tabulado.tab_fila2  , place: 'left'});
                }
                if(tabulado.tab_columna && defs_tab_cel_tipo[tabulado.tab_cel_tipo].incluye_columna_en_select){
                    datum.vars.push({name: tabulado.tab_columna, place: 'top'  });
                }
                return Promises.all(
                    datum.vars.map(function(info){
                        if(!info.name){
                            return Promises.Promise.resolve(null);
                        }
                        return Promises.start(function(){
                            console.log('por buscar',[ope_actual, info.name]);
                            pg.log=sqlLog;
                            return client.query(
                                "SELECT var_texto as nombre FROM encu.variables_todas WHERE var_ope=$1 and var_var=$2",
                                [ope_actual, info.name]
                            ).fetchOneRowIfExists();
                        }).then(function(result){
                            info.label=result.rowCount?result.row.nombre:info.name; 
                            info.values={};
                            return client.query(
                                "SELECT opc_opcion opc_opc, opc_texto FROM encu.opciones_todas WHERE opc_ope=$1 and opc_var=$2",
                                [ope_actual, info.name]
                            ).fetchAll();
                        }).then(function(result){
                            result.rows.forEach(function(row){
                                info.values[row.opc_opc]={ label: row.opc_texto};
                            });
                        }).then(function(){
                            info.values[null]={ label: 'Nulo'};
                            info.name='pla_'+info.name;
                        });
                    })
                ).then(function(){
                    filtro="estado>="+p_estado+ (ope_actual!=='colon2015'? " and rea not in (0,2)":"")+
                        (tabulado.tab_cel_exp!='viviendas'? " and entrea<>4":"")+
                        (tabulado.tab_filtro?" and "+tabulado.tab_filtro:"") ;
                    console.log('filtro:',filtro);    
                    nombreVarsGroupBy=datum.vars.map(function(info){ return info.name;});
                    datum.vars.push({name: 'numerador'   , place: 'data'});
                    datum.vars.push({name: 'denominador' , place: 'data'});
                });
            }).then(function(result){
                if(defs_tab_cel_tipo[tabulado.tab_cel_tipo]===undefined){
                    console.log('UUUUUUUUUUUUUUUUndefined',tabulado.tab_cel_tipo, params.tra_tab, tabulado.tab_tab);
                }
                //                      "     sum(sum(#3fexp)) over (partition by #2,campos) as denominador "+ 
                var lc_zonal=letra_y_campo_zonal(tabulado.tab_fila1, tabulado.tab_fila2);
                var campos_fila=[];
                datum.vars.forEach(function(e){if(e.place=='left'){ campos_fila.push(e.name)}});
                var conCoefVar= params.tra_coefvar && defs_tab_cel_tipo[tabulado.tab_cel_tipo].calculo_coefvar;
                console.log('lc_zonal: ', JSON.stringify(lc_zonal) );
                console.log('campos_fila: ', JSON.stringify(campos_fila) );
                var nombreVarsGroupBySlice_1 = nombreVarsGroupBy.slice(0,-1);
                var sqlInterno = function(nombreVarsGroupBy,conNumerador){
                    return inte.sqlFiltro(inte.sqlNames(
                        "  SELECT #,campos "+
                        (conNumerador?
                            (defs_tab_cel_tipo[tabulado.tab_cel_tipo].numerador_solo_valor_mayor_0?
                                ", sum(case when 1 #3expresion_del_valor_para_numerador>0 then #3fexp else 0 end)":
                                ", sum(#3fexp #3expresion_del_valor_para_numerador)"
                            )+" as numerador" + (defs_tab_cel_tipo[tabulado.tab_cel_tipo].con_denominador?
                                ",sum(#3fexp #3expresion_del_valor_para_denominador) as denominador":"") :""
                        )+(conNumerador && conCoefVar? 
                            ','+parte_campos_coefvar(false,lc_zonal.letra, lc_zonal.campo, params.tra_en_numero,params.tra_coefvar_normal_tasa, tabla_coefvar(conCoefVar,tabulado.tab_tipo,tabulado.tab_columna, tabulado.tab_cel_exp),
                            defs_tab_cel_tipo[tabulado.tab_cel_tipo].sin_campos_fila_coef?false:campos_fila
                            ) + ' coefvar' :"")
                        + "\n FROM "+(tabulado.tab_cel_exp=='personas'?
                            "encu.plana_s1_p sp INNER JOIN encu.plana_i1_ i ON sp.pla_enc=i.pla_enc and sp.pla_hog=i.pla_hog and sp.pla_mie=i.pla_mie "+
                            "\n INNER JOIN encu.plana_s1_ s1 ON i.pla_enc=s1.pla_enc and i.pla_hog=s1.pla_hog":
                            "encu.plana_s1_ s1 "
                        )+(ope_tipo=='etoi' || ope_tipo=='eah'?
                            "\n INNER JOIN encu.plana_a1_ a1 ON s1.pla_enc=a1.pla_enc and s1.pla_hog=a1.pla_hog":"")+
                        "\n INNER JOIN encu.plana_tem_ t ON s1.pla_enc=t.pla_enc"+
                        (ope_tipo=='etoi' || ope_tipo=='eah'?"\n INNER JOIN encu.valcan vc on vc.pla_ope='#4p_ope_actual'":"")+
                        (ope_tipo=='eah' && ope_anio>=2015? "\n INNER JOIN encu.pla_ext_hog eh on s1.pla_enc=eh.pla_enc and s1.pla_hog=eh.pla_hog and pla_modo= '#4p_val_modo'":"" )+
                        "\n #_filtro"+
                        "\n GROUP BY #,campos "
                        ,
                        nombreVarsGroupBy,
                        nombreVarsGroupBySlice_1,
                        {   
                            fexp: ponderador, //"pla_fexp",
                            expresion_del_valor_para_numerador: defs_tab_cel_tipo[tabulado.tab_cel_tipo].incluye_valor_numerador ? "* pla_"+tabulado.tab_columna : "",
                            expresion_del_valor_para_denominador: defs_tab_cel_tipo[tabulado.tab_cel_tipo].incluye_valor_denominador ? "* pla_"+tabulado.tab_columna : ""
                        },
                        {
                            p_ope_actual:ope_actual,
                            p_val_modo:p_val_modo
                        }
                    ), filtro);
                }
                
                var sqlParaCodigosVar=nombreVarsGroupBy.map(function(columna){
                    return "("+sqlInterno([columna],false)+") "+columna;
                });
                console.log('sqlParaCodigosVar:', sqlParaCodigosVar);
                var sqlDatosSinNumerador0=sqlInterno(nombreVarsGroupBy,true);
                console.log('sqlDatosSinNumerador0:', sqlDatosSinNumerador0);
                var sql="SELECT "+nombreVarsGroupBy.map(function(columna){ return "filas_columnas."+columna; }).join(',')+
                    ", coalesce(numerador,0) as numerador"+ (defs_tab_cel_tipo[tabulado.tab_cel_tipo].denominador_sin_over?
                    ", coalesce(denominador,0)":
                    ", sum(coalesce(numerador,0)) over (partition by "+
                    (nombreVarsGroupBySlice_1.length==0?
                        'null':
                        nombreVarsGroupBySlice_1.map(function(columna){ return "filas_columnas."+columna; }).join(',')
                    )+
                    //'filas_columnas.'+ pla_comuna
                    " )" )+" as denominador"+
                    (params.tra_coefvar && conCoefVar?', coefvar ' :'')+
                    "\n FROM (SELECT * FROM "+
                    sqlParaCodigosVar.join(',')+") filas_columnas "+
                    "\n LEFT JOIN ("+sqlDatosSinNumerador0+") datos ON "+nombreVarsGroupBy.map(function(columna){
                        return "coalesce(filas_columnas."+columna+","+valNuloCoalesce+") = coalesce(datos."+columna+ ","+ valNuloCoalesce +")";
                    }).join(' AND ');
                console.log('sql:', sql);  
                if(conCoefVar){
                    //pensando para normales
                    var func=parte_campos_coefvar(true,'T', 0, params.tra_en_numero,
                        params.tra_coefvar_normal_tasa, 
                        tabla_coefvar(conCoefVar,tabulado.tab_tipo,tabulado.tab_columna, tabulado.tab_cel_exp), false);
                        func=func.replace(/#3fexp/gi, 'numerador');
                    console.log('xxx', func);
                    datum.vars.push({name: 'coefvar', place: 'data', aggExp: func});
                };                
                SqlTools.defaults.aggLabel='Total';
                SqlTools.defaults.aggPositionFirst=true;
                SqlTools.defaults.orderFunction='comun.para_ordenar_numeros';
                datum.vars.forEach(function(info){
                    if((campos_fila.length==2) && conCoefVar){
                        // para usar como ejemplo var attr=changing({"my-colname":fieldDef.name},specificAttributes);???
                        var cc;
                        if (info.name==campos_fila[0]){ 
                            cc=campos_fila[1];
                        }else if(info.name==campos_fila[1]){
                            cc=campos_fila[0];
                        };
                        vars=vars.map(function(info2){
                            if(info2.name=='coefvar'){
                                var func=parte_campos_coefvar(true,letra_zonal_de(cc), campo_zonal_de(cc), params.tra_en_numero,
                                        params.tra_coefvar_normal_tasa, 
                                        tabla_coefvar(conCoefVar,tabulado.tab_tipo,tabulado.tab_columna, tabulado.tab_cel_exp), [cc]);
                                        func=func.replace(/#3fexp/gi, 'numerador');
                                info2.aggExp=func; 
                            };
                            return info2;        
                        });
                    };    
                    if(info.place!=='data'){
                        var vars=datum.vars.slice(0);
                        if(info.place=='top' || tabulado.tab_cel_tipo=='frecuencia'||tabulado.tab_cel_tipo=='suma'){
                            vars=vars.map(function(info2){
                                if(info2.name==='denominador'){
                                    return _.merge(info2,{aggExp:'sum(numerador)'});
                                };
                                return info2;
                            });
                        };
                        
                        sql=SqlTools.olap.cube(sql, info.name, vars);
                    };
                });
                console.log('query_cube',JSON.stringify(datum.vars));
                sql=SqlTools.olap.orderBy(sql, datum.vars);
                fs.writeFile('local-sql-principal.sql',sql,{encoding: 'utf-8'});
                return client.query(sql,parametrosSQL);
            }).then(function(query){
                return query.fetchAll();
            }).then(function(result){
                datum.list=result.rows;
                //console.log(datum.list);
                return datum;
            }).then(function(datum){
                return {matrix:tabulator.toMatrix(datum),tabulado:tabulado};
            });
        }
    });
}
        

fs.readJson('configuracion-local.json').then(function(config){
    configuracion=config;
    console.log('xxxxxxxxxxxx config',configuracion.php.path)
    app.use(new PhpSessionMiddleware({
        handler: 'file',
        sessionName: '$SESSION',
        opts: {
            path: configuracion.php.path
        }
    }));
    var server = app.listen(configuracion.server.port, function() {
        console.log('Listening on port %d', server.address().port, app.get('env'));
    });
}).then(function(){
    console.log('connecting to db...');
    //obtener la base del operativo
    return pg.connect(configuracion.db);
}).then(function(obtainedClient){
    var client=obtainedClient;
    console.log('connected to DB ',configuracion.db.database);
    app.get('/ejemplo',html.p([
        "ejemplo de uso: ",
        html.a({href:'./tabulado?tabulado='+configuracion.tabulado},'aquí'),
        " o solamente ",
        html.a({href:'./tabulado?tabulado='+configuracion.tabulado+'&dump=1'},'los datos')
    ]).middleware());
    app.get('/tabulado',function(req,res){
        console.log('xxxxxxxxxxxxxxx q',req.query);
        console.log('xxxxxxxxxxxxxxx c',req.cookies);
        console.log('xxxxxxxxxxxxxxx s',req.$SESSION);
        //console.log('xxxxxxxxxxxxx req', req);
        //----------------
        //validacion de parametros!!!!   FALTA
        params=JSON.parse(req.query.tabulado);
        ope_actual=params.tra_ope;
        ope_anio  =params.tra_anio_ope;
        ope_tipo=(ope_actual.match(matchexpr)||[])[1];
        console.log('anio ', ope_anio, ' ope_tipo:',ope_tipo, ' modo_encuesta:', params.tra_modo_encuesta);
        p_val_modo= (ope_tipo=='eah' && ope_anio>=2015? (params.tra_modo_encuesta==='Completo'?ope_actual:'ETOI'):'');//REVISAR EN EAH
        
        var prefijo$session = ope_actual + '/' + configuracion.db.host + '_' + configuracion.db.database + '_';
        var user = req.$SESSION[prefijo$session + 'usu_usu'];
        var rol  = req.$SESSION[prefijo$session + 'usu_rol'];
        console.log('xxxxxxxxxxxxx u',prefijo$session,user,rol);
        if(!user){
            res.send('desconectado');
            res.end();
            return;
        }
        if(!rolAutorizado[rol]){
            res.send('no autorizado para '+rol);
            res.end();
            return;
        }
        levantarUnTabuladoYCrearMatrix(client, params).then(function(result){
            var matrix=result.matrix;
            var tabulator=new Tabulator();
            var factor=1.0;
            console.log('Revisar ',params.tra_revisar);
            var cambia_separador_decimal= function(num, separador){
                //asumo que num siempre viene con punto
                return (separador!='.'?num.toString().replace(/\./g, ',') : num )
            }
            tabulator.toCellTable=function(cell){
                if(!cell){
                    return html.td({'class':'empty_cell'});
                }
                if (result.tabulado.tab_cel_tipo=='comun' || result.tabulado.tab_cel_tipo=='frecuencia'
                    || result.tabulado.tab_cel_tipo=='tasa'||result.tabulado.tab_cel_tipo=='suma'){
                    factor=100.0;
                }
                var nnn= [html.span(cell.denominador?cambia_separador_decimal(numeral(cell.numerador*factor/cell.denominador).format('0.0'),params.tra_separador_decimal):'')];
                if(params.tra_revisar===true){
                    if(params.tra_revisar2===true){// unicamente numerador
                        nnn.pop();
                    };
                    nnn.push(html.span(cambia_separador_decimal(numeral(cell.numerador).format('0.0'),params.tra_separador_decimal)));
                }
                if(params.tra_coefvar && cell.coefvar){
                    nnn.push(html.span({'style':'font-size:60%','vertical-align':'super'},cambia_separador_decimal(cell.coefvar,params.tra_separador_decimal)));
                    //console.log('cv', cell.coefvar);
                }
                return html.td({title:cell.numerador+'/'+cell.denominador}, nnn
                //[
                //    html.span(cell.denominador?numeral(cell.numerador*factor/cell.denominador).format('0.0'):''),
                    //html.span({'class':'superindice', 'style':'font-size:70%'},'*')
                //]
                );
            }
            matrix.caption=result.tabulado.tab_tab+' '+result.tabulado.tab_titulo+' Ciudad de Buenos Aires. Año ' + ope_anio ;
            if(req.query.dump){
                res.send(html.div([
                    html.pre(JSON.stringify(matrix,null,'  '))
                ]).toHtmlText({pretty:true}));
            }else{
                res.send(tabulator.toHtmlTable(matrix).toHtmlText({pretty:true}));
            }
            res.end();
        }).catch(MiniTools.serveErr(req,res)).then(function(){
            res.end();
            pg.log=null;
        });
    });
    app.get('/exportar',function(req,res){
        ////// traer datos
        Promises.start(function(){
            res.write(html.div({id:'leyendo'}, "leyendo...").toHtmlText({pretty:true}));
            console.log('por queriar');
            return client.query("SELECT ltrim(to_char(ocu_ocu,'00000')) as codigo_ocupacion, ocu_descripcion as descripcion_ocupacion FROM encu.ocupacion order by codigo_ocupacion").fetchAll();
        }).then(function(result){
            ////// exportar datos
            console.log('tengo los datos');
            res.write(html.div({id:'generando'}, "generando...").toHtmlText({pretty:true}));
            console.log('avise');
            return exportarDatosTxt('t_ocup_2.txt', result.rows);
        }).then(function(){
            res.write(html.div("Listo").toHtmlText({pretty:true}));
            res.end();
        }).catch(MiniTools.serveErr(req,res)).then(function(){
            pg.log=null;
        });
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
fs.stat('server.js').then(function(stats){
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
    fs.stat('server.js').then(function(stats){
        res.write('<table '+(mTimeServerJs.getTime()!=stats.mtime.getTime()?'style="color:red"':'')+'>')
        res.write('<tr><td>At start<td>'+mTimeServerJs);
        res.write('<tr><td>Last mod<td>'+stats.mtime);
        res.write('</table>')
        res.end();
    }).catch(MiniTools.serveErr(req,res));
});

app.get('/',function(req,res){
    res.send('¡Anda!');
});