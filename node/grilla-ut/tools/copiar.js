"use strict";
var fs=require('fs');
var pendientes=5;


function copiar(base, origen, nombreDelJs){
    var origenPath= './node_modules'+'/'+base;
    var destinoPath='./';
    if(!origen){
        origen=base;
    }
    origenPath=origenPath+'/'+origen;
    if(nombreDelJs){
        origenPath=origenPath+'/'+nombreDelJs+'.js';
        destinoPath=destinoPath+nombreDelJs+'.js';
    }else{
        if(origen==base){
            origenPath=origenPath+'.js';
        }else{
            origenPath=origenPath+'/'+base+'.js';
        }
        destinoPath=destinoPath+base+'.js';
    }
    fs.readFile(origenPath,function(err,data){
        if(err){
            throw new Error("no se pudo leer origenPath"+origen+' '+err)
        }
        fs.writeFile(destinoPath,data,'utf8',function(err){
            if(err){
                throw new Error("No pudo leer destinoPath "+destinoPath+' '+err);
            }
            pendientes--;
            if(!pendientes){
                console.log("Terminé de copiar archivos");
            }
        });
    })
}

copiar("js-to-html", ""); 
copiar("typed-controls", "", "detect-browser"); 
copiar("mini-tools", "lib");
copiar("tedede", "lib");
copiar("best-globals", "");
