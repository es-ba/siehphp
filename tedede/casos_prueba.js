//UTF-8:SÍ
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
        ,
		{ titulo: "vaciar un arreglo x"
		, entrada: {uno:1, tres:3, dos:[{a:'a',b:'b'},{c:'c',d:'d'}]}
		, cambios: {uno:2,         dos:[]}
		, salida:  {uno:2, tres:3, dos:[]}
		, salida_exacta: true
		}
        ,
		{ titulo: "cambiar un objeto por un arreglo"
		, entrada: {uno:1, tres:3, dos:{cuatro:4}}
		, cambios: {uno:2,         dos:[]}
		, salida:  {uno:2, tres:3, dos:[]}
		, salida_exacta: true
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
		elemento_mostrar_casos_prueba.innerHTML="<p>Casos de prueba (js):</p>";
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
            try{
                casos_modulo.modulo(caso);
            }catch(err){
                pru_mostrar_error('EXEPCION '+descripciones_de_error(err),caso.entrada,caso.salida);
            }
		}
	}
	elemento_mostrar_casos_prueba.innerHTML+="<hr>"+cant_modulos_probados+" módulos probados, "+cant_casos_probados+" casos probados.";
}

function pru_mostrar_error(mensaje,esperado,obtenido){
    var li=document.createElement('li');
    var texto=document.createTextNode(mensaje+' en ');
    var small=document.createElement('small');
    small.textContent=JSON.stringify(obtenido)+"/"+JSON.stringify(esperado);
    li.appendChild(texto);
    li.appendChild(small);
    document.body.appendChild(li);
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

function pru_eval(caso){
"use strict";
    var obtenido=eval(caso.entrada);
    pru_comparar(caso.salida,obtenido,caso.titulo);
}

function pru_comparar_combinatorio(esperado_combinatorio,str_obtenido){
    var sufijo_sin_revisar=str_obtenido;
    var revisado='';
    if(!esperado_combinatorio){
        return "Falta especificar el valor esperado";
    }
    if(!esperado_combinatorio.length){
        return "El esperado combinatorio debe tener algún elemento";
    }
    for(var i in esperado_combinatorio) if(esperado_combinatorio.hasOwnProperty(i)){
        var parte=esperado_combinatorio[i];
        if(typeof(parte)=='string'){
            var revisar=sufijo_sin_revisar.substr(0,parte.length);
            sufijo_sin_revisar=sufijo_sin_revisar.substr(parte.length);
            if(revisar!=parte){
                return 'Iguales hasta '+revisado+' pero no coincide la parte literal esperada "'+parte+'" y la obtenida "'+revisar+'" resto "'+sufijo_sin_revisar;
            }
        }else{
            if(!('todas' in parte)){
                return 'Falta indicar el tipo de combinación en '+JSON.stringify(esperado_combinatorio);
            }
            var alternativas_pendientes=parte.todas.slice(0);
            while(alternativas_pendientes.length>0){
                var hay=false;
                for(var j in alternativas_pendientes) if(alternativas_pendientes.hasOwnProperty(j)){
                    var alternativa=alternativas_pendientes[j];
                    if(typeof(alternativa)=='string'){
                        var revisar=sufijo_sin_revisar.substr(0,alternativa.length);
                        if(revisar==alternativa){
                            hay=true;
                            sufijo_sin_revisar=sufijo_sin_revisar.substr(alternativa.length);
                            alternativas_pendientes.splice(j,1);
                            break; 
                        }
                    }else{
                        return 'Las alternativas deben ser todas string en '+JSON.stringify(parte.todas);
                    }
                }
                if(!hay){
                    return 'Iguales hasta '+revisado+' pero faltan las alternativas "'+JSON.stringify(alternativas_pendientes)+'" resto "'+sufijo_sin_revisar;
                }
            }
        }
    }
}

function pru_comparar(esperado,obtenido,titulo,comparador){
	var rta=(comparador||pru_comparar_str)(esperado,obtenido,7,'');
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

function pru_probador_modulo(caso,ejecutar){
    var comparar_salida=false;
    try{
        var obtenido=ejecutar(caso);
        if('excepcion' in caso){
            pru_mostrar_error('ERROR se esperaba una excepción: '+caso.excepcion,'',caso.titulo);
        }else{
            comparar_salida=true;
        }
    }catch(err){
        var mensaje_err=typeof(err)=='string'?err:(err.message||err.text||'');
        if(!('excepcion' in caso)){
            pru_mostrar_error('ERROR excepción NO esperada: '+err.toString(),'',caso.titulo);
        }else if(mensaje_err!=caso.excepcion){
            pru_mostrar_error('ERROR distinta de la esperada: ',caso.excepcion,err.toString());
        }
    }
        if("salidas_posibles" in caso){
            var uno_correcto=false;
            for(var i in caso.salidas_posibles) if(caso.salidas_posibles.hasOwnProperty(i)){
                var salida=caso.salidas_posibles[i];
                uno_correcto=uno_correcto||salida==obtenido;
            }
            if(!uno_correcto){
                pru_comparar(caso.salidas_posibles,obtenido,caso.titulo);
            }
        }
        if('salida' in caso){
            pru_comparar(caso.salida,obtenido,caso.titulo);
        }
        if('salida_combinatoria' in caso){
            pru_comparar(caso.salida_combinatoria,obtenido,caso.titulo,pru_comparar_combinatorio);
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

function QueNoFalle(que_hacer){
	try{
		que_hacer();
	}catch(err){
		throw err;
	}
}

var pru_casos=pru_casos_pru_casos;


var pru_casos_comunes=[
  { modulo: pru_eval
  , casos:
    [ { titulo: "EL time zone es -0300"
      , entrada: "TIME_ZONE_STR"
      , salida: "-0300" 
      }
    , { titulo: "contruir una fecha con CrearFechaDesdeTextoISO"
      , entrada: "CrearFechaDesdeTextoISO('2013-12-28').toString()"
      , salida: new Date(2013,12-1,28).toString() 
      }  
    , { titulo: "fecha_referencia(fecha)"
      , entrada: "fecha_referencia('2013-12-28')"
      , salida: "sábado 28 de diciembre" 
      }  
    ]
  }
];

pru_casos=pru_casos.concat(pru_casos_comunes);
