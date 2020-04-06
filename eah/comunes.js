"use strict";
function QueNoFalle(que_hacer){
	try{
		que_hacer();
	}catch(err){
		throw err;
	}
}


String.prototype.encomillar=function(){ 
/* transforma: esto es 'algo' bastante "bueno" \ mejorable
	 en: esto es 'algo' bastante \"bueno\" \\ mejorable
   objetivo: tener una variable string y poder meterla en un string literal js. 
   ejemplo:
   var fuente_incierta=function(){return 'esto es \'algo\' bastante "bueno" \\ mejorable'; }
   var mi_cadena=fuente_incierta();
   new setTimeout('alert('+mi_cadena.encomillar()+')',1000);
   // así se rompe: new setTimeout("alert('"+mi_cadena+"');",1000);
*/	
	return JSON.stringify(this);
}


function trim(esto) {  
	if(esto==null || esto==undefined || typeof esto!="string"){
		return esto;
	}
  return esto.replace(/^\s+|\s+$/g, '');  
}

function cambiandole(destino,cambios,borrando,borrar_si_es_este_valor){
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

function IrAUrl(direccion){
	// document.location.href=direccion;
	window.location.href=direccion;
}


function para_ordenar_numeros(texto_con_numeros){
var rta='';
var numero='';
var despues_de_la_coma=false;
texto_con_numeros+=' ';
for(var i=0; i<texto_con_numeros.length; i++){
	var letra=texto_con_numeros[i];
	if(letra.match(/[0-9]/)){
		if(despues_de_la_coma){
			rta+=letra;
		}else{
			numero+=letra;
		}
	}else{
		despues_de_la_coma=letra=='.';
		if(numero){
			while(numero.length>0 && numero[0]=='0'){
				numero=numero.substr(1);
			}
			rta+=String.fromCharCode(64+numero.length)+numero;
			numero='';
		}
		rta+=numero+letra;
	}
}
return rta.toLowerCase();
}