"use strict";
/*jshint eqnull:true */
/*jshint node:true */
/*eslint-disable no-console */

// APP

var extensionServeStatic = require('extension-serve-static');

// var Promises = require('best-promise');

var backend = require("backend-plus");
var MiniTools = require("mini-tools");

var sql = require('mssql');

class AppMarco extends backend.AppBackend{
    configList(){
        return super.configList().concat([
            'def-config.yaml',
            'local-config.yaml'
        ]);
    }
    addLoggedServices(){
        super.addLoggedServices();
        var be = this;
        be.app.use('/',extensionServeStatic(this.rootPath+'client',{staticExtensions:['jpg','png','html','gif']}));
        be.app.get('/',MiniTools.serveJade(this.rootPath+'client/marco'));
        be.app.get('/prueba', function(req,res){
            return be.procesoPrueba(req,res);
        });
    }
    mandarMensaje(res,mensaje){
        res.write(mensaje+(new Array(2000)).join(' ')+'<br>');
    }
    procesoPrueba(req,res){
        var comenzo=new Date();
        var be = this;
        res.append('Content-Type', 'text/html; charset=utf-8');
        var timer = setInterval(function(){
            be.mandarMensaje(res,'van '+(new Date().getTime()-comenzo.getTime())+' milisegundos');
        },2000);
        be.mandarMensaje(res,'intento conectarme');
        console.log('conectando a ',be.config.marco.connstr);
        sql.connect(be.config.marco.connstr).then(function(){
            be.mandarMensaje(res,'conectado!');
            return new sql.Request().query('SELECT TOP 10 [Ccodigo],[cNombre],[IdCalleSiac] FROM [BD_Marco].[dbo].[tbCalles]');
        }).then(function(recordset) {
            console.dir(recordset);
            be.mandarMensaje(res, JSON.stringify(recordset));
        }).catch(function(err){
            console.log("ERROR", err);
            console.log("STACK", err.stack);
            be.mandarMensaje(res, "ERROR: "+err.message);
        }).then(function(){
            clearInterval(timer);
            res.end('Listo, no espero más');
        });
    }
}

new AppMarco().start();