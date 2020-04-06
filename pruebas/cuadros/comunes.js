// para strict
var version_comunes='20110921';

function QueNoFalle(que_hacer){
	try{
		que_hacer();
	}catch(err){
		throw err;
	}
}

function trim(esto) {  
	if(esto==null || esto==undefined){
		return esto;
	}
  return esto.replace(/^\s+|\s+$/g, '');  
}

function calcularTop( oElement ){
	var iReturnValue = 0;
	while( oElement != null ) {
		iReturnValue += oElement.offsetTop;
		oElement = oElement.offsetParent;
	}
	return iReturnValue;
}

function calcularLeft( oElement ){
	var iReturnValue = 0;
	while( oElement != null ) {
		iReturnValue += oElement.offsetLeft;
		oElement = oElement.offsetParent;
	}
	return iReturnValue;
}


function cambiandole(destino,cambios,borrando,borrar_si_es_este_valor){
"use strict";
    if(destino instanceof Object && !(destino instanceof Date)){
        var respuesta={};
        for(var campo in destino){
            var cambio=cambios[campo];
            if(cambio==undefined){
                respuesta[campo]=destino[campo];
            }else if(borrando && cambio===borrar_si_es_este_valor){
            }else{
                respuesta[campo]=cambiandole(destino[campo],cambio,borrando,borrar_si_es_este_valor);
            }
        }
        for(var campo in cambios){
            var cambio=cambios[campo];
            if(!(campo in destino) && (!borrando || !(cambio===borrar_si_es_este_valor))){
                respuesta[campo]=cambio;
            }
        }
        return respuesta;
    }else{
        if(cambios==undefined){
            return destino;
        }else{
            return cambios;
        }
    }
}
