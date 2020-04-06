"use strict";

/*jshint eqnull:true */
/*jshint node:true */
/*eslint-disable no-console */

// APP

var Path = require('path');

if(process.argv[2]=='--dir'){
    process.chdir(process.argv[3]);
    console.log('cwd',process.cwd());
}

var extensionServeStatic = require('extension-serve-static');

var changing = require('best-globals').changing;
var backend = require("backend-plus");
var MiniTools = require("mini-tools");

class AppEmpa extends backend.AppBackend{
    constructor(){
        super();
        this.tableStructures = {};
        this.tableStructures.requerimientos = require('./table-requerimientos.js');
        this.tableStructures.proyectos = require('./table-proyectos.js');
        this.tableStructures.req_nov = require('./table-req_nov.js');
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
        super.addLoggedServices();
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

new AppEmpa().start();
