"use strict";
var MUESTRA_STRING_VACIO='""';
var MUESTRA_FALTANTE="undefined";

var elemento_mostrar_casos_prueba;

var pru_casos_pru_casos=[
	{ modulo: pru_pru_comparar
	, casos: [
		{ titulo: "no recibe el unico campo"
		, entrada: {esperado:{algo:1}, obtenido:{}}
		, salida: " - .algo:1<>"+MUESTRA_FALTANTE
		}
		, 
		{ titulo: "prueba que un campo es distinto y que tiene otro error (una falta) que también la muestra"
		, entrada: {esperado:{alfa:1, beta:4, epsilon:5}, obtenido:{alfa:1, beta:2, gama:3, delta:4}}
		, salida: " - .beta:4<>2 - .epsilon:5<>"+MUESTRA_FALTANTE
		}
		, 
		{ titulo: "diferencia en nivel de profundiad 2"
		, entrada: {esperado:{alfa:1, beta:4, aleph:{a:1, b:44, c:3}}, obtenido:{alfa:1, beta:2, gama:3, delta:4, aleph:{a:1, b:22, c:3}}}
		, salida: " - .beta:4<>2 - .aleph.b:44<>22"
		}
		, 
		{ titulo: "comparación con textos vacíos"
		, entrada: {esperado:{alfa:'', beta:'', gama:'algo'}, obtenido:{alfa:'', beta:'algo', gama:''}}
		, salida: ' - .beta:'+MUESTRA_STRING_VACIO+'<>"algo" - .gama:"algo"<>'+MUESTRA_STRING_VACIO
		}
	]
	}
	,
	{ modulo: pru_pru_aplicar_cambios
	, casos: [
		{ titulo: "algunos cambios"
		, entrada: {uno:2, dos:{tres:4, cuatro:4, cinco:5}, seis:6, siete:{ocho:{nueve:9, diez:1 }}}
		, cambios: {uno:1, dos:{tres:3,                  }        , siete:{ocho:{         diez:10}}}
		, salida:  {uno:1, dos:{tres:3, cuatro:4, cinco:5}, seis:6, siete:{ocho:{nueve:9, diez:10}}}
		}
	]
	}
	,
	{ modulo: pru_cambiandole
	, casos: [
		{ titulo: "algunos cambios para cambiandole"
		, entrada: {uno:2, dos:{tres:4, cuatro:4, cinco:5}, seis:6, siete:{ocho:{nueve:9, diez:1 }}}
		, cambios: {uno:1, dos:{tres:3,                  }        , siete:{ocho:{         diez:10, agregada:11}}}
		, salida:  {uno:1, dos:{tres:3, cuatro:4, cinco:5}, seis:6, siete:{ocho:{nueve:9, diez:10, agregada:11}}}
		}
	]
	}
	,
	{ modulo: pru_cambiandole_y_borrando
	, casos: [
		{ titulo: "algunos cambios para cambiandole con opcion borrar"
		, entrada: {uno:2, dos:{tres:4, cuatro:4, para_borrar:9       , cinco:5}, seis:6, siete:{ocho:{nueve:9, diez:false   }}}
		, cambios: {uno:1, dos:{tres:3,           para_borrar:'borrar'         }        , siete:{ocho:{         diez:'borrar', agregada:11}}}
		, salida:  {uno:1, dos:{tres:3, cuatro:4                      , cinco:5}, seis:6, siete:{ocho:{nueve:9,                agregada:11}}}
		, salida_exacta: true
		}
	]
	}
];


function pru_preparar_despliegue_casos(){
	elemento_mostrar_casos_prueba=document.getElementById('mostrar_casos_prueba');
	if(!elemento_mostrar_casos_prueba){
		elemento_mostrar_casos_prueba=document.createElement("div");
		elemento_mostrar_casos_prueba.style.cssText="width:800px; border:black 1px solid; background-color:MediumAquamarine;";
		elemento_mostrar_casos_prueba.innerHTML="<p>Casos de prueba:</p>";
		// document.body.childNodes[document.body.childNodes.length-1]
		document.body.appendChild(elemento_mostrar_casos_prueba);
	}
}

var cant_modulos_probados;
var cant_casos_probados;

function probar_todo(){
	pru_preparar_despliegue_casos();
	cant_modulos_probados=0;
	cant_casos_probados=0;
	for(var i_m in pru_casos){
		var casos_modulo=pru_casos[i_m];
		cant_modulos_probados++;
		for(var i_c in casos_modulo.casos){
			cant_casos_probados++;
			var caso=casos_modulo.casos[i_c];
			casos_modulo.modulo(caso);
		}
	}
	elemento_mostrar_casos_prueba.innerHTML+="<hr>"+cant_modulos_probados+" módulos probados, "+cant_casos_probados+" casos probados.";
}

function pru_mostrar_error(mensaje,esperado,obtenido){
	elemento_mostrar_casos_prueba.innerHTML+=
		("<li>"+mensaje+" en <small>"+JSON.stringify(obtenido)+"/"+JSON.stringify(esperado)+"</small></li>\n");
}

function pru_comparar_str(esperado,obtenido,profundidad,prefijo){
	var rta='';
	if(esperado instanceof Object && obtenido instanceof Object && profundidad>0){
		for(var i in esperado){
			var valor_esperado=esperado[i];
			var valor_obtenido=obtenido[i];
			rta+=pru_comparar_str(valor_esperado,valor_obtenido,profundidad-1,prefijo+"."+i);
		}
	}else{
		if(JSON.stringify(esperado)!=JSON.stringify(obtenido)){
			var separador=' - ';
			rta+=separador+prefijo+":"+JSON.stringify(esperado)+"<>"+JSON.stringify(obtenido);
		}
	}
	return rta;
}

var pru_parar_en_el_primero=false;

function pru_comparar(esperado,obtenido,titulo){
	var rta=pru_comparar_str(esperado,obtenido,7,'');
	if(rta){
		if(titulo==undefined){
			pru_mostrar_error('ERROR'+rta,esperado,obtenido);
		}else{
			pru_mostrar_error('ERROR'+rta,'',titulo);
		}
		if(pru_parar_en_el_primero){
			alert('dio error mirá como quedó');
			throw new Error("Paramos en el primer error");
		}
	}
}

function pru_pru_comparar(caso){
	pru_comparar(pru_comparar_str(caso.entrada.esperado,caso.entrada.obtenido,7,''),caso.salida,caso.titulo);
}

function pru_aplicar_cambios(destino,cambios){
	for(var campo in cambios){
		var valor=cambios[campo];
		if(valor instanceof Object && destino[campo] instanceof Object && !(valor instanceof Date)){
			pru_aplicar_cambios(destino[campo],valor)
		}else{
			QueNoFalle(function(){
				destino[campo]=valor;
			});
		}
	}
}

function pru_pru_aplicar_cambios(caso){
	pru_aplicar_cambios(caso.entrada,caso.cambios);
	pru_comparar(caso.salida,caso.entrada,caso.titulo);
}

function pru_cambiandole_base(caso,borrar,como_borrar){
	var al_empezar_eran_asi_de_distintos=pru_comparar_str(caso.entrada,caso.salida);
	var obtenido=cambiandole(caso.entrada,caso.cambios,borrar,como_borrar);
	var luego_son_asi_de_distintos=pru_comparar_str(caso.entrada,caso.salida);
	pru_comparar(al_empezar_eran_asi_de_distintos,luego_son_asi_de_distintos,"ojo el cambiandole cambia el parametro");
	pru_comparar(caso.salida,obtenido,caso.titulo);
	if(caso.salida_exacta){
		pru_comparar(obtenido,caso.salida,caso.titulo);
	}
}

function pru_cambiandole(caso){
	pru_cambiandole_base(caso,false,false);
}

function pru_cambiandole_y_borrando(caso){
	pru_cambiandole_base(caso,true,'borrar');
}

var pru_casos=pru_casos_pru_casos;

/*
window.onbeforeunload=function(){
	alert('por escapar');
}
window.ondeviceorientation=function(){
	alert('cambio de orientación');
}
window.onunload=function(){
	alert('haciendo unload');
}
*/