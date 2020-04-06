"use strict";

/*jshint eqnull:true */
/*jshint node:true */
/*eslint-disable no-console */

// APP

if(process.argv[2]=='--dir'){
    process.chdir(process.argv[3]);
    console.log('cwd',process.cwd());
}

var extensionServeStatic = require('extension-serve-static');

var changing = require('best-globals').changing;
var backend = require("backend-plus");
var MiniTools = require("mini-tools");

class AppSPOS extends backend.AppBackend{
    constructor(){
        super();
        this.tableStructures = {};
        this.tableStructures.usuarios   = require('./table-usuarios.js');
        this.tableStructures.operativos = require('./table-operativos.js');
        this.tableStructures.personas   = require('./table-personas.js');
        this.tableStructures.modificaciones   = require('./table-modificaciones.js');
    }
    configList(){
        return super.configList().concat([
            'def-config.yaml',
            'local-config.yaml'
        ]);
    }
    log(condition, f){
        if(new Date(this.config.log[condition])>new Date()){
            console.log(f());
        }
    }
    addLoggedServices(){
        var be = this;
        /*
        var indexOpts={
            scripts:[
                'require-bro.js',
                'json4all.js',
                'best-globals.js',
                'dialog-promise.js',
                'js-to-html.js',
                'typed-controls.js',
                'ajax-best-promise.js',
                'my-things.js',
                'my-tables.js',
                'cliente-en-castellano.js',
            ]
        };
        be.app.get('/',function(req, res, next){
            return MiniTools.serveJade(be.rootPath+'client/index', changing(indexOpts,{
                isAdmin:req.user.rol=='admin'
            }))(req, res, next);
        });
        */
        super.addLoggedServices();
        // be.app.use('/',extensionServeStatic(this.rootPath+'client',{staticExtensions:['jpg','png','html','gif']}));
    }
}

process.on('uncaughtException', function(err){
  console.log("Caught exception:",err);
  console.log(err.stack);
  process.exit(1);
});

process.on('unhandledRejection', function(err){
  console.log("unhandledRejection:",err);
  console.log(err.stack);
});

new AppSPOS().start();
