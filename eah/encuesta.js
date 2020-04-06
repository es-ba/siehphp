"use strict";
var FONDO_SALTEAR_OK='DarkGray';
var FONDO_SALTEAR_CON_VALOR='OrangeRed';
var FONDO_SALTEAR_CON_VALOR='OrangeRed';
var FONDO_OPCION_OK='SpringGreen';
var FONDO_OPCION_INVALIDA='Orange';
var FONDO_EN_BLANCO='White';
var FONDO_ARRIBA_EN_BLANCO='Chocolate';

var SEPARADOR_VARIABLE_OPCION='__';

var MAX_FILAS_MATRICES=10;

var soy_un_ipad=false;

var estados_rta=
{ ok:"opc_ok"
, opcion_inexistente:"opc_inex" // un valor que no existe entre las opciones
, ingreso_sobre_salto:"opc_sosa" // ingresó una opción sobre una variable que debía ser salteada
, salteada:"opc_salt" // esta variable no tiene valor, lo cual es correcto, porque tiene un salto que la pasa por encima
, blanco:"opc_blanco" // esta variable está en blanco porque es la que se debe ingresar ahora y no hay errores de saltos
, todavia_no:"opc_tono" // esta variable todavía no debe ingresarse porque hay una variable en blanco más arriba
, omitido:"opc_omit" // esta variable se omitió el ingreso y era obligatoria
, hay_omitidas:"opc_homi" // hay variables anteriores omitidas, estas todavía no están ingresadas ni tienen nada abajo ingresado
, fuera_de_rango_obligatorio:"opc_rano"
, fuera_de_rango_advertencia:"opc_rana"
, error_tipo:"opc_tipo" // por ejemplo en una variable numérica puso texto
, nsnc:"opc_nsnc" // es un No sabe no contesta
, sinesp:"opc_sinesp" // es un No sabe no contesta
, inconsistente:"opc_inconsistente" // pertenece a alguna inconsistencia
}

var color_fondo=
{ S1:"#C0E0FF"
, I1:"White"
, A1:"LemonChiffon"
, MD:"Pink"
}
	
function Borrar_LocalStorage(forzar){
	if(forzar || confirm('¿borrar localStorage?')){
		localStorage.clear();
		if(!forzar){
			alert('borrado');
		}
	}
}

function elemento_existente(id_elemento){
	var elemento=document.getElementById(id_elemento);
	if(!elemento){
		throw new Error("no existe el elemento "+id_elemento);
	}
	return elemento;
}

function getY( oElement ){
	var iReturnValue = 0;
	while( oElement != null ) {
		iReturnValue += oElement.offsetTop;
		oElement = oElement.offsetParent;
	}
	return iReturnValue;
}

function PosicionarSaltoEn(elemento_destino){
	window.scrollTo(0,getY(elemento_destino)-80);
}

function Saltar_de_a(id_de,id_a){
	elemento_existente(id_de).style.backgroundColor='';
	elemento_existente(id_de).style.color='';
	PosicionarSaltoEn(elemento_existente(id_a));
}

/*
  var elemento=document.getElementById('tilde_'+id_variable_cursor_actual);
  elemento.style.visibility=(valor_opcion_elegida==''?'hidden':'visible');
*/

function PonerOpcion(id_variable_cursor_actual,valor_opcion_elegida,id_pregunta_saltar){
	var ele=elemento_existente(id_variable_cursor_actual);
	if(ele.value==valor_opcion_elegida){
		ele.value='';
	}else{
		ele.value=valor_opcion_elegida;
	}
	ValidarOpcion(id_variable_cursor_actual);
}

function BorrarOpcion(id_variable_cursor_actual){
	PonerOpcion(id_variable_cursor_actual,'');
}

var suspender_validacion_onblur=false;

function Valor_de_elemento_a_variable(valor_en_elemento,id_variable){
	var esta_pregunta_ud=preguntas_ud[id_variable];
	return (
		valor_en_elemento=='//' && esta_pregunta_ud.nsnc?esta_pregunta_ud.nsnc:
		(valor_en_elemento=='--'?(esta_pregunta_ud.es_numerico || esta_pregunta_ud.opciones?-1:'SIN ESPECIFICAR'):
		(esta_pregunta_ud.marcar && esta_pregunta_ud.almacenar && valor_en_elemento==esta_pregunta_ud.marcar?esta_pregunta_ud.almacenar:
		valor_en_elemento)));
}

function Valor_en_variable_a_valor_para_elemento(id_variable,rta_ud,preguntas_ud){ 
	// necesito preguntas_ud como parámetro porque puede ser una local (en el despliegue horizontal de matrices), no siempre es la global 
	var mostrar=rta_ud[id_variable];
	var esta_pregunta_ud=preguntas_ud[id_variable];
	return (
		esta_pregunta_ud.nsnc && mostrar==esta_pregunta_ud.nsnc?'//':
		((esta_pregunta_ud.es_numerico||esta_pregunta_ud.opciones?mostrar==-1:(''+mostrar).toLowerCase()=='sin especificar')?'--':
		(esta_pregunta_ud.marcar && esta_pregunta_ud.almacenar && mostrar==esta_pregunta_ud.almacenar?esta_pregunta_ud.marcar:
		mostrar)));
}

function ValidarOpcion(id_variable_cursor_actual,forzar){
	if(forzar || !suspender_validacion_onblur){
		var valor_en_elemento=elemento_existente(id_variable_cursor_actual).value;
		var valor_a_guardar_en_rta_ud=Valor_de_elemento_a_variable(valor_en_elemento,id_variable_cursor_actual);
		var valor_anterior=rta_ud[id_variable_cursor_actual];
		if(valor_anterior!=valor_a_guardar_en_rta_ud && !(valor_anterior==null && valor_a_guardar_en_rta_ud=="")){
			MarcarSucio();
		}
		// siempre hago la asignación porque no estamos seguros de qué pasa entre null=="". Emilio
		rta_ud[id_variable_cursor_actual]=valor_a_guardar_en_rta_ud;
		var proximo=Validar_rta_ud(id_variable_cursor_actual);
		Colorear_rta_ud();
		return proximo;
	}
}

//como la anterior pero para retroceder con Flecha arriba
function ValidarOtraOpcion(id_variable_cursor_actual,forzar){
	if(forzar || !suspender_validacion_onblur){
		var valor_en_elemento=elemento_existente(id_variable_cursor_actual).value;
		rta_ud[id_variable_cursor_actual]=Valor_de_elemento_a_variable(valor_en_elemento,id_variable_cursor_actual);
		var previo=var_anterior[id_variable_cursor_actual];
		Colorear_rta_ud();
		return previo;
	}
}

function IrAPagina(pagina){
	document.location.href=document.location.href.replace(/\/[^\/]*$/,"/")+pagina;
}

var dbo={
	T_desoc2:function(id,nhogar,miembro){
		return true;
	}, 
	textoinformado:function(valor){
		return !!valor?1:0;
	},
	es_fecha:function(valor){
		return 1;
	},
	suma_t1at54b:function(id,nhogar,miembro){
		return 1;
	}
	
	
}	

function hacer_expresion_evaluable(expresion_pura){
	var expresion_evaluable=expresion_pura
			.replace(/\bis not\b/ig,"!=")
			.replace(/\bis distinct from\b/ig,"<>")
			.replace(/\band\b/ig,"&&")
			.replace(/\bor\b/ig,"||")
			.replace(/\bnot\b/ig,"!")
			.replace(/[A-Za-z]\w*(?!\w|[.(])/g,"rta_ud.var_$&")
			.replace(/rta_ud\.var_copia_/g,"copia_ud.copia_")
			.replace(/(\w*_ud\.var_\w*)/g,"($1||0)")
			.replace(/^(.*)<=>(.*)$/g,"($1) = ($2)")
			.replace(/^(.*)=>(.*)$/g,"($1) && !($2)")
			.replace(/([^><!])=/g,"$1 == ")
			.replace(/<>/ig,"!=")
			.replace(/rta_ud.var_false/g,"false")
			.replace(/rta_ud.var_true/g,"true");
	return expresion_evaluable;
}

function Revisar_Inconsistencias(){
/*
	for(var cual in consistencias){
		var consistencia=consistencias[cual];
		var expresion_junta="("+consistencia.si+") && !("+consistencia.entonces+")";
		var expresion_eval=hacer_expresion_evaluable(expresion_junta);
		alert(" de "+expresion_eval);
		alert(eval(expresion_eval)+" de "+expresion_eval);
		if(eval(expresion_eval)){
			var matches=expresion_junta.match(/[A-Za-z]\w*(?!\w|[.(])/g);
			for(var i_matches in matches){
				var nombre_variable=matches[i_matches];
				alert(matches[i_matches]);
			}
		}
	}
*/
}

var formularios_elegibles;

function guardar_en_localStorage(clave, valor){
	localStorage.removeItem(clave);
	localStorage.setItem(clave, valor); 
}
function cuenta_variables(expresion_evaluada){
	//ML
	var cadena=expresion_evaluada;
	var cantidad_variables=0;
	var inicio=0;
	while (cadena.indexOf('rta_ud.',inicio)>0) {
		cantidad_variables=cantidad_variables+1;
		inicio=cadena.indexOf('rta_ud.',inicio)+7;
	}
	return cantidad_variables;
}
function valida_variable_actual(expresion_evaluada, variable_actual){
	//ML
	var cadena=expresion_evaluada;
	var cantidad_variables=0;
	var inicio=0;
	var variable_a_comparar = '';
	while (cadena.indexOf('rta_ud.',inicio)>0) {
		cantidad_variables=cantidad_variables+1;
		variable_a_comparar = cadena.substring(cadena.indexOf('rta_ud.',inicio)+7, cadena.indexOf('||'));
		cadena = cadena.substring(cadena.indexOf('||', inicio)+2, cadena.length);
		if(variable_a_comparar == variable_actual){
			return cantidad_variables;
		}
		inicio=cadena.indexOf('rta_ud.',inicio);
	}
	return cantidad_variables;
}
function AbrirVivienda(vivienda){
	guardar_en_localStorage("pk_vivienda_actual",JSON.stringify(vivienda));
	IrAUrl('ingresar_vivienda.php');
}

function AbrirFormulario(parametros){
	try{
		guardar_en_localStorage("pk_ud_navegacion",JSON.stringify(parametros));
	}catch(err){
		alert(err.message);
		alert(JSON.stringify({encuesta: encuesta, nhogar:nhogar, formulario:formulario, miembro:miembro}));
	}
	Grabando_antes_hacer(function(){
		IrAUrl('formulario.php?usar='+parametros.formulario+'&matriz='+(parametros.matriz||''));
	});
	// OJO, al pasar a producción cambiar por 'gen/formulario_'+formulario+'.php'
}

function CargarEncuesta(datos){
	for(var id_ud in datos){
		guardar_en_localStorage("ud_"+id_ud,JSON.stringify(datos[id_ud]));
	}
	formularios_elegibles=datos.formularios_elegibles;
	guardar_en_localStorage("formularios_elegibles",JSON.stringify(formularios_elegibles));
}

function AbrirEncuesta(encuesta,nhogar,id_proc,para_que){
	encuesta=Number(encuesta);
	nhogar=Number(nhogar);
	if(para_que && para_que.toLowerCase()!='borrar'){
		alert('no sé como hacer '+para_que);
	}else{
		try{
			guardar_en_localStorage("pk_encuesta_actual",encuesta);
		}catch(err){
			alert(err.message);
		}
		Enviar('cargar_encuesta.php', {encuesta:encuesta}
			, function(datos){
				CargarEncuesta(datos);
				var reingreso_id;
				if(!id_proc){
					if(datos.comenzo_el_ingreso){
						reingreso_id=prompt('VERIFIQUE ingresando la Identificación de la ENCUESTA');
					}else{
						alert('No se puede acceder desde el botón [i] porque la encuesta todavía no fue ingresada');
						return;
					}
				}
				if(datos.id_proc!=id_proc && datos.id_proc!=reingreso_id && encuesta!=reingreso_id){
					alert('No coincide el número de encuesta con el ID de procesamiento');
				}else{
					tarea_de_etapa=datos.tarea_de_etapa;
					solo_lectura=datos.solo_lectura;
					if((para_que||'').toLowerCase()=='borrar'){
						guardar_en_localStorage("pk_encuesta_puede_borrar",encuesta);
					}else{
						guardar_en_localStorage("pk_encuesta_puede_borrar",0);
					}
					AbrirFormulario({encuesta:encuesta,nhogar:nhogar,formulario:'S1',matriz:''});
				}
			}
			, function(mensaje){
				alert("Error abriendo la encuesta: "+mensaje);
			}
		);
		// OJO, al pasar a producción cambiar por 'gen/formulario_'+formulario+'.php'
	}
}

var formulario;
var matriz;
var id_ud; // json(pk_ud)
var preguntas_ud; // Son las preguntas (y sus opciones) de la unidad de despliegue actual, es constante, es la estructura del cuestionario respecto de la UD actual. 
var rta_ud={}; // Son las respuestas de la Unidad de despliegue actual
var pk_ud={}; // Son los campos pk de la Unidad de despliegue actual
var copia_ud={}; // son las variables que se copian a otros formularios para poder ejecutar filtros
var estados_rta_ud={};
var estados_intermedios={};
var datos_viv={}; // Son los datos de la vivienda actual que se necesitan para administrar los cuestionarios. 
var sucio_db=false;
var sucio_ls=false;
var tarea_de_etapa='ingreso';
var solo_lectura='solo lectura';

var hacer_al_ensuciar=[];

function MarcarSucio(){
  // o sea que hay modificaciones no guardadas
	sucio_db=true;
	sucio_ls=true;
	for(var i in hacer_al_ensuciar){
		if(hacer_al_ensuciar.hasOwnProperty(i)){
			var hacer=hacer_al_ensuciar[i];
			hacer();
		}
	}
}

var var_anterior={}; // Son las variables anteriores correctas para volver atras con Flecha arriba

function Validar_rta_ud(id_variable_cursor_actual){
	// devuelve el lugar a saltar si está indicada id_variable_cursor_actual
	// si no devuelve la primer variable con blanco
	var proxima_variable=null; // salto desde id_variable_cursor_actual
	var var_anterior_habilitada=null; // anterior a la actual del procesamiento. 
	var salteando_hasta=false;
	var la_anterior_esta_ingresada_o_es_optativa_blanca=true;
	var esta_esta_ingresada=true;
	var ya_vi_algun_null_erroneo=false;
	var primer_null_de_la_serie=false;
	var variable_omitida=false;
	var tipo_anterior_multiple=false;
	var expresion_habilitar;
	var primer_blanco=false;
	var ultima_variable_con_valor=0;
	var cantidad_de_variables_al_momento=0;
	/////////////// CICLO POR CADA VARIABLE
	for(var var_actual in preguntas_ud){
		var_anterior[var_actual]=var_anterior_habilitada; // guarda la variable anterior habilitada
		cantidad_de_variables_al_momento++;
		if(id_variable_cursor_actual==var_anterior_habilitada){
			if(salteando_hasta){
				proxima_variable=salteando_hasta;
			}else{
				proxima_variable=var_actual;			
			}
		}
		var expresion_filtro=preguntas_ud[var_actual].expresion_filtro;
		var tipo=preguntas_ud[var_actual].multiple; 
		var variable_habilitada=true;
		var variable_mal_habilitada=false;
		if(expresion_filtro){
			///////////// Para los filtros:
			if(!salteando_hasta || salteando_hasta == var_actual){
				salteando_hasta=false;
				var valor = eval(hacer_expresion_evaluable(expresion_filtro));
				if (valor){
					salteando_hasta=preguntas_ud[var_actual].salta;
				}
			}
			variable_habilitada=false; // no es una variable habilitada, es un filtro
		} else if(!preguntas_ud[var_actual].no_es_variable) {
			/////////// Normaliza el valor de la variable unificando nulos y pasando el tipo a Number o Sting según corresponda y haciendo TRIM
			var valor=rta_ud[var_actual]; // si la variable no está especificada devuelve undefined (ej: para los casos de prueba).
			var opciones=preguntas_ud[var_actual].opciones;
			if(valor==='' || valor===undefined){
				valor=null;
			}else if(valor==null){
				// no convertir
			}else if(valor=='+' && preguntas_ud[var_actual].marcar){
				valor=preguntas_ud[var_actual].marcar;
			}else if(preguntas_ud[var_actual].es_numerico){
				if(!isNaN(valor)){ //not a number -> no es un numero
					valor=Number(valor);
				}
			}else if(typeof valor=="number"){
				valor=valor.toString();
			}else if(valor!=trim(valor)){
				valor=trim(valor);
				if(valor===''){
					valor=null;
				}
			}
			rta_ud[var_actual]=valor;
			//////////////// SALTEA si corresonde
			expresion_habilitar=preguntas_ud[var_actual].expresion_habilitar;
			variable_habilitada = (!salteando_hasta || var_actual==salteando_hasta)
				&& (!expresion_habilitar || eval(hacer_expresion_evaluable(expresion_habilitar)));
			if(!variable_habilitada){
				if(valor){
					estados_rta_ud[var_actual]=estados_rta.ingreso_sobre_salto;
				}else{
					estados_rta_ud[var_actual]=estados_rta.salteada;
				}
			}else{
				////// VALIDA EL VALOR
				salteando_hasta=false;
				if(!preguntas_ud[var_actual].la_anterior_es_multiple){
					la_anterior_esta_ingresada_o_es_optativa_blanca=esta_esta_ingresada;
				}
				if(valor===null){
					/////////// VARIABLE NO INGRESADA
					if(!primer_null_de_la_serie){
						primer_null_de_la_serie=var_actual;
					}
					if(!preguntas_ud[var_actual].la_anterior_es_multiple){
						esta_esta_ingresada=false;
					}
					if(la_anterior_esta_ingresada_o_es_optativa_blanca){
						primer_blanco=primer_blanco||var_actual;
						estados_rta_ud[var_actual]=estados_rta.blanco;
						if(preguntas_ud[var_actual].optativa){
							esta_esta_ingresada=true;
						}
					}else{
						estados_rta_ud[var_actual]=estados_rta.todavia_no;
					}
				}else{
					// si estoy acá es porque el valor no es nulo
					esta_esta_ingresada=true;
					ultima_variable_con_valor=cantidad_de_variables_al_momento;
					if(!la_anterior_esta_ingresada_o_es_optativa_blanca){
						ya_vi_algun_null_erroneo=true;	
						if(!variable_omitida){
							variable_omitida=primer_null_de_la_serie;
						}
					}
					primer_null_de_la_serie=null;
					/////////// VARIABLES CON VALORES ESPECIALES
					if(valor==preguntas_ud[var_actual].nsnc){
						estados_rta_ud[var_actual]=estados_rta.nsnc;
					}else if(valor==-1 || valor.toString().toLowerCase()=='sin especificar'){
						estados_rta_ud[var_actual]=estados_rta.sinesp;
					/////////// VARIABLES SIN OPCIONES
					}else if(opciones==undefined){
						if(preguntas_ud[var_actual].es_numerico){
							if(isNaN(valor)){
								estados_rta_ud[var_actual]=estados_rta.error_tipo;
							}else{
								valor=Number(valor);
								if(valor<preguntas_ud[var_actual].minimo || valor>preguntas_ud[var_actual].maximo){
									estados_rta_ud[var_actual]=estados_rta.fuera_de_rango_obligatorio;
								}else if(valor<preguntas_ud[var_actual].advertencia_inf || valor>preguntas_ud[var_actual].advertencia_sup){
									estados_rta_ud[var_actual]=estados_rta.fuera_de_rango_advertencia;
								}else{
									estados_rta_ud[var_actual]=estados_rta.ok;
								}
							}
						}else{
							estados_rta_ud[var_actual]=estados_rta.ok;
						}
						salteando_hasta=preguntas_ud[var_actual].salta;
					/////////// VARIABLES CON OPCIONES
					}else if(preguntas_ud[var_actual].almacenar?valor!=preguntas_ud[var_actual].almacenar:opciones[valor]==undefined){
						estados_rta_ud[var_actual]=estados_rta.opcion_inexistente;
						//// Si es una múltiple marcar y el valor es incorrecto se puede intentar salvar
						if(preguntas_ud[var_actual].almacenar && (valor!=1)){
							//// Si existiera la variable sería la misma que la actual pero reemplazando la última parte por el valor ingresado:
							var otra_variable_multiple_marcar=var_actual.replace(/[^_]*$/,valor);
							//// Veo si existe:
							if(preguntas_ud[otra_variable_multiple_marcar]){
								//// si existe hago la transformación (o sea el pase del valor de una variable a la otra). 
								rta_ud[otra_variable_multiple_marcar]=preguntas_ud[var_actual].almacenar;
								rta_ud[var_actual]=null;
								//// cambio el id_variable_cursor_actual para mover el cursor en función de la transformación que acabo de hacer
								id_variable_cursor_actual=otra_variable_multiple_marcar;
								primer_blanco=primer_blanco||var_actual;
								estados_rta_ud[var_actual]=estados_rta.blanco;
								estados_rta_ud[otra_variable_multiple_marcar]=estados_rta.ok;
							}
						}
					}else{
						estados_rta_ud[var_actual]=estados_rta.ok;
						salteando_hasta=(opciones[valor]||opciones[preguntas_ud[var_actual].marcar]||{}).salta || preguntas_ud[var_actual].salta;
					}
				}
			}
		}
		
		if(variable_habilitada /* || valor OJO:Poner esto cuando se quiera que el ENTER PARE en las "sosa" */){
			var_anterior_habilitada=var_actual;
		}
	}
	
	cantidad_de_variables_al_momento=0;
	for(var var_actual in preguntas_ud){
		cantidad_de_variables_al_momento++;
		if(preguntas_ud[var_actual].consistir){
			for(var id_cons in preguntas_ud[var_actual].consistir){
				var consistencia=preguntas_ud[var_actual].consistir[id_cons];
				var inconsistente=false;
				try{
					if(ultima_variable_con_valor >= cantidad_de_variables_al_momento || var_actual == id_variable_cursor_actual){
						inconsistente=eval(hacer_expresion_evaluable(consistencia.expr));
					}
				}catch(err){
					// aca hay que registrar las consistencias que no corren en JS.
				}
				
				var cartel=document.getElementById('cons_'+id_cons);
				if(inconsistente){
					if(!cartel){
						if('forma de cartel'=='mejor no, mejor como renglón adicional'){
							cartel=document.createElement('span');
							cartel.id='cons_'+id_cons;
							
							if(consistencia.gravedad.toLowerCase() == 'advertencia'){
								cartel.className='advertencia flotante';
							}else{
								cartel.className='inconsistencia flotante';
							}
							cartel.textContent=consistencia.expl;
							document.body.appendChild(cartel);
							cartel.style.top=getY(elemento_existente(var_actual))+50+'px';
							cartel.draggable=true;
							cartel.ondragstart=function(event){
								this.setAttribute('nuestro_posx',event.offsetX);
								this.setAttribute('nuestro_posy',event.offsetY);
							}
							cartel.ondragend=function(event){
								this.style.top =event.pageY-this.getAttribute('nuestro_posy')+"px";
								this.style.left=event.pageX-this.getAttribute('nuestro_posx')+"px";
							}
						}else{
							var ele_de_la_variable=elemento_existente(var_actual);
							var fila_de_la_variable=ele_de_la_variable;
							while((fila_de_la_variable=fila_de_la_variable.parentNode).className!='fila_pregunta'){}
							var tabla=fila_de_la_variable.parentNode.parentNode;
							cartel=tabla.insertRow(fila_de_la_variable.rowIndex+1);
							cartel.id='cons_'+id_cons;
							var celda=cartel.insertCell(-1);
							celda.colSpan=2;
							if(consistencia.gravedad.toLowerCase() == 'advertencia'){
								celda.className='advertencia';
							}else{
								celda.className='inconsistencia';
							}
							celda.textContent=consistencia.expl;
						}
					}else{
						if(cartel.nodeName=='TR'){
							cartel.style.display='table-row';
						}else{
							cartel.style.display='inline';
						}
					}
					estados_rta_ud[var_actual]=estados_rta.inconsistente;
				}else{
					if(cartel){
						cartel.style.display='none';
					}
				}
			}
		}
	}
	if(ya_vi_algun_null_erroneo){
		Marcar_Posteriores_Al_Omitidos(variable_omitida);
	}
	estados_intermedios.variable_omitida=variable_omitida;
	return id_variable_cursor_actual?proxima_variable:primer_blanco;
	// return proxima_variable;
}

function Marcar_Posteriores_Al_Omitidos(variable_omitida){
	var ya_vi_la_omitida=false;
	for(var var_actual in preguntas_ud){
		if(ya_vi_la_omitida){
			estados_rta_ud[var_actual]=estados_rta.hay_omitidas;
		}else{
			if(var_actual==variable_omitida){
				ya_vi_la_omitida=true;
				estados_rta_ud[var_actual]=estados_rta.omitido;
			}
		}
	}
}

function Colorear_rta_ud(){
	for(var var_actual in estados_rta_ud){
		var ele=elemento_existente(var_actual);
		ele.className=ele.className.replace(/ opc_.*$/,'');
		ele.className+=' '+estados_rta_ud[var_actual];
		ele.value=Valor_en_variable_a_valor_para_elemento(var_actual,rta_ud,preguntas_ud);
		for(var opc_actual in preguntas_ud[var_actual].opciones){
			var ele_opc=elemento_existente(var_actual+SEPARADOR_VARIABLE_OPCION+opc_actual);
			ele_opc.className=ele_opc.className.replace(/ opc_.*$/,'');
			if(preguntas_ud[var_actual].almacenar?opc_actual=preguntas_ud[var_actual].almacenar:opc_actual==rta_ud[var_actual]){
				ele_opc.className+=' '+estados_rta_ud[var_actual];
			}
		}
	}
}

var lista_errores_provisorios=new Object;

function Ignorar_Error_Provisoriamente(proceso){
	try{
		return proceso();
	}catch(err){
		lista_errores_provisorios[err.stack]++;
	}
}

function Mostrar_Errores_Provisorios_En(id_elemento){
	var el_div=document.getElementById('div_'+id_elemento);
	el_div.style.visibility='visible';
	el_div.style.display='inline';
	var ele=document.getElementById(id_elemento);
	ele.value=JSON.stringify(lista_errores_provisorios);
}

function Pasar_rta_ud_a_elementos_y_controlar(preguntas_ud,rta_ud,donde_meterlo,prefijo,preguntas_copiar_ud){
	for(var i in preguntas_ud){
		if(!preguntas_ud[i].no_es_variable){
			if(!rta_ud[i] && rta_ud[i]!==0 && rta_ud[i]!=="0"){
				rta_ud[i]=null;
			}else{
				var elemento=document.getElementById(prefijo+i);
				Ignorar_Error_Provisoriamente(function(){
					elemento[donde_meterlo]=Valor_en_variable_a_valor_para_elemento(i,rta_ud,preguntas_ud);
				});
			}
		}
	}
	if(preguntas_copiar_ud){
		var otras_rta={};
		for(var i in preguntas_copiar_ud){
			var def_copia=preguntas_copiar_ud[i];
			var otra_ud=JSON.stringify(cambiandole(pk_ud,def_copia.cambiador_id,true,'borrar'));
			if(!(otra_ud in otras_rta)){
				otras_rta[otra_ud]=JSON.parse(localStorage.getItem("ud_"+otra_ud));
			}
			copia_ud[def_copia.destino]=otras_rta[otra_ud][def_copia.origen];
		}
	}
	copia_ud.copia_nhogar=pk_ud.nhogar;//generalizar
	for(var i in rta_ud){
		if(!preguntas_ud[i] && !preguntas_ud[i].no_es_variable){
			//alert('en el local storage había datos "'+rta_ud[i]+'" para la variable inexistente "'+i+'"');
			delete rta_ud[i];
		}
	}
	if(formulario=='S1' && matriz==''){
		if(!rta_ud.var_participacion){
			rta_ud.var_participacion=copia_ud.copia_participacion;
		}
	}
}

function Llenar_rta_ud(){
	preguntas_ud=estructura.formulario[formulario][matriz];
	rta_ud=JSON.parse(localStorage.getItem("ud_"+id_ud));
	if(!rta_ud || rta_ud==undefined){
		rta_ud=new Object();
	}
	Pasar_rta_ud_a_elementos_y_controlar(preguntas_ud,rta_ud,"value",'',(estructura.copias[formulario]||{})[matriz]);
	var posibles_pks={miembro:'p0', ex_miembro:1, relacion:1};
	for(var posible_pk in posibles_pks){ // FALTA GENERALIZAR
		if(posible_pk in pk_ud){
			if('var_'+posible_pk in rta_ud){
				rta_ud['var_'+posible_pk]=pk_ud[posible_pk];
			}
			if('var_'+posibles_pks[posible_pk] in rta_ud){
				rta_ud['var_'+posibles_pks[posible_pk]]=pk_ud[posible_pk];
			}
		}
	}
	if(!matriz){
		for(var matriz_hija in estructura.formulario[formulario]){
			if(matriz_hija){
				var ya_agregue_una_en_blanco=false;
				var total_registros_for;
				if(matriz_hija == 'U'){
					total_registros_for = rta_ud.var_u1;
				}else if(matriz_hija == 'X'){
					total_registros_for = rta_ud.var_x5_tot;
				}else if(matriz_hija == 'P'){
					total_registros_for = rta_ud.var_total_m;
				}
				
				for(var num_renglon=1; num_renglon<=total_registros_for+12; num_renglon++){
					var fila=elemento_existente('fila_matriz_'+matriz_hija);
					var str_nueva_fila=fila.innerHTML;
					str_nueva_fila=str_nueva_fila
						.replace(/id="var_/g,'id="r'+num_renglon+'_var_'); // var_T4 p1_var_T4
					var nueva_fila=fila.parentNode.insertRow(num_renglon);
					nueva_fila.id='fila_matriz_'+matriz_hija+'_'+num_renglon;
					nueva_fila.className=fila.className;
					var rta_ud_matriz_miembro;
					if(formulario=='S1'){
						if(localStorage['pk_encuesta_puede_borrar']==pk_ud.encuesta){
							str_nueva_fila+='<input type=button value="borrar" onclick="Borrar_Formulario({encuesta:'+pk_ud.encuesta+',nhogar:'+pk_ud.nhogar+',miembro:'+num_renglon+',formulario:\'fam\', matriz:\'\', volver:false});">';
						}
						str_nueva_fila+="<td class='buttonS1'>"+boton_abre_formulario(cambiandole(pk_ud,{matriz:'P', miembro:num_renglon}));
						str_nueva_fila+=boton_abre_formulario(cambiandole(pk_ud,{formulario:'I1', miembro:num_renglon}));
						str_nueva_fila+=boton_abre_formulario(cambiandole(pk_ud,{formulario:'MD', miembro:num_renglon}));
						rta_ud_matriz_miembro=localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud,{matriz:matriz_hija, miembro:num_renglon})));
					}else if(formulario=='A1'){
						if(localStorage['pk_encuesta_puede_borrar']==pk_ud.encuesta){
							str_nueva_fila+='<input type=button value="borrar" onclick="Borrar_Formulario({encuesta:'+pk_ud.encuesta+',nhogar:'+pk_ud.nhogar+',ex_miembro:'+num_renglon+', formulario:\'ex\', matriz:\'X\', volver:false});">';
						}					
						str_nueva_fila+="<td class='buttonS1'>"+boton_abre_formulario(cambiandole(pk_ud,{matriz:'X', ex_miembro:num_renglon}));
						rta_ud_matriz_miembro=localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud,{matriz:matriz_hija, ex_miembro:num_renglon})));
					}else if(formulario=='I1'){
						if(localStorage['pk_encuesta_puede_borrar']==pk_ud.encuesta){
							str_nueva_fila+='<input type=button value="borrar" onclick="Borrar_Formulario({encuesta:'+pk_ud.encuesta+',nhogar:'+pk_ud.nhogar+',miembro:'+pk_ud.miembro+',relacion:'+num_renglon+',formulario:\'un\', matriz:\'U\',volver:false});">';
						}					
						str_nueva_fila+="<td class='buttonS1'>"+boton_abre_formulario(cambiandole(pk_ud,{matriz:'U', relacion:num_renglon}));
						rta_ud_matriz_miembro=localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud,{matriz:matriz_hija, relacion:num_renglon})));
					}
					if(rta_ud_matriz_miembro || !ya_agregue_una_en_blanco){
						nueva_fila.innerHTML=str_nueva_fila;
						ya_agregue_una_en_blanco=!rta_ud_matriz_miembro;
					}
					if(rta_ud_matriz_miembro){
						Pasar_rta_ud_a_elementos_y_controlar(
							estructura.formulario[formulario][matriz_hija]
							,JSON.parse(rta_ud_matriz_miembro)
							,"innerHTML"
							,'r'+num_renglon+'_'
						);
					}
				}
			}
		}
		if(formulario=='S1'){
			var fila_titulos=elemento_existente('titulos_matriz_P');
			fila_titulos.innerHTML=fila_titulos.innerHTML.replace(/>Fin[^<]*<\/span/,'>' + boton_abre_formulario(cambiandole(pk_ud,{formulario:'A1'}))+'</span');
		}
	}
	estados_rta_ud={};
	var primer_blanco=Validar_rta_ud();
	if(primer_blanco){
		elemento_existente(primer_blanco).focus();
	}
	Colorear_rta_ud();
	sucio_ls=false;
	sucio_db=false;
}

function boton_abre_formulario(parametros){
	var rta="<input type='button' value='"+parametros.formulario+"' onclick='AbrirFormulario("+JSON.stringify(parametros)+");'"+
		" id='boton_"+parametros.formulario+'_'+parametros.matriz+'_'+(parametros.relacion||parametros.miembro||parametros.ex_miembro||0)+"'>";
	return rta;
}

function GuardarElFormulario(){
	if(sucio_ls){
		guardar_en_localStorage("ud_"+id_ud,JSON.stringify(rta_ud));
		sucio_ls=false;
		return !soy_un_ipad; // o sea si soy un ipad aviso que está sucio. 
	}
	return false;
}

var grabar_al_volver=true; // OJO por ahora mientras sepamos que no es un iPad y esté off line

function Grabando_antes_hacer(accion, fin_etapa){
// Si no es un iPad, primero graba y luego, si se pudo grabar, se corre "accion"
// Si es un iPad, NO GRABA y corre "accion"
    accion();
    return;
	if(!solo_lectura && pk_ud && pk_ud.encuesta && !soy_un_ipad){ // OJO en el iPad no hay que intentar grabar
		Enviar('grabar.php', {pk_ud:pk_ud, rta_ud:rta_ud, estados_rta_ud:estados_rta_ud, fin_etapa:fin_etapa}
			, function(mensaje){
				sucio_db=false;
				GuardarElFormulario();
				accion(mensaje);
			}
			, function(mensaje){
				alert('hubo un problema al grabar '+mensaje);
			}
		);
	}else{
		accion();
	}
}

function VolverDelFormulario(){
	if(grabar_al_volver){
		Grabando_antes_hacer(function(){
			history.go(-1);
		});
	}else{
		history.go(-1);
	}
}

function Cerrar_Encuesta(poner_fin){
	if(!sucio_db){
		if(poner_fin){
			Enviar('grabar.php', {encuesta:pk_ud.encuesta, poner_fin:poner_fin}
				, function(){
					history.go(-1);
				}
				, function(mensaje){
					alert('No se pudo poner_fin código '+poner_fin+' el servidor informa: '+mensaje);
				}
			);
		}else{
			history.go(-1);
		}
	}else{
		alert('Debe volver a "'+elemento_existente(boton_correr_consistencias.id).value+'"');
		elemento_existente('boton_cerrar_encuesta').style.display='none';
	}
}

function DesplegarVariableFormulario(de_este_php){
	formulario=de_este_php.formulario;
	matriz=de_este_php.matriz||'';
	var campos_pk={};
	tarea_de_etapa=JSON.parse(localStorage['ud_tarea_de_etapa']);
	solo_lectura=JSON.parse(localStorage['ud_solo_lectura']);
	switch(formulario+'/'+matriz){
		case 'A1/':
		case 'S1/':campos_pk={encuesta:null, nhogar:null, formulario:null, matriz:''}; break;
		case 'MD/':
		case 'I1/':
		case 'S1/P':campos_pk={encuesta:null, nhogar:null, formulario:null, matriz:null, miembro:1}; break;
		case 'I1/U':campos_pk={encuesta:null, nhogar:null, formulario:null, matriz:null, miembro:1, relacion:1}; break;
		case 'A1/X':campos_pk={encuesta:null, nhogar:null, formulario:null, matriz:null, ex_miembro:1}; break;
	}
	Leer_formularios_elegibles();
	var parametros=JSON.parse(localStorage.getItem("pk_ud_navegacion"));
	pk_ud={};
	for(var campo in campos_pk){
		if(campo in de_este_php){
			pk_ud[campo]=de_este_php[campo]||'';
		}else{
			pk_ud[campo]=parametros[campo]||campos_pk[campo];
		}
	}
	// agregar botonera de hogares acá:
	pk_ud.nhogar=pk_ud.nhogar||1;
	id_ud=JSON.stringify(pk_ud);
	formularios_elegibles[pk_ud.encuesta+''][id_ud]=true; // agrego este formulario si no estaba (si estaba se pisa)
	guardar_en_localStorage("formularios_elegibles",JSON.stringify(formularios_elegibles));
	// para debug:
		var elemento=document.getElementById('id_ud');
		elemento.innerHTML=id_ud;
	document.body.style.backgroundColor=color_fondo[formulario];
	Llenar_rta_ud();
	if(localStorage['pk_encuesta_puede_borrar']==pk_ud.encuesta){
		
		if(formulario=='I1' && matriz==''){
			var boton_borrar = document.createElement('input');
			boton_borrar.setAttribute('type', 'button');
			boton_borrar.setAttribute('value','Borrar I1');
			boton_borrar.setAttribute('onclick','Borrar_Formulario({encuesta:'+pk_ud.encuesta+',nhogar:'+pk_ud.nhogar+',miembro:'+pk_ud.miembro+',formulario:\'i1\', matriz:\'\', volver:true});');
			elemento.appendChild(boton_borrar);
		}
		if(formulario=='MD' && matriz==''){
			var boton_borrar = document.createElement('input');
			boton_borrar.setAttribute('type', 'button');
			boton_borrar.setAttribute('value','Borrar MD');
			boton_borrar.setAttribute('onclick','Borrar_Formulario({encuesta:'+pk_ud.encuesta+',nhogar:'+pk_ud.nhogar+',miembro:'+pk_ud.miembro+',formulario:\'md\', matriz:\'\', volver:true});');
			elemento.appendChild(boton_borrar);
		}

	}
	if(formulario=='S1' && matriz==''){
		var elemento_botonera=elemento_existente('BotoneraHogares');
		var max_hogar=Math.max(pk_ud.nhogar||1,rta_ud.var_total_h||1);
		var nueva_botonera='';

		for(var i=1; i<=max_hogar; i++){
			nueva_botonera+='<input type=button value=" '+i+' " '
				+(i==pk_ud.nhogar?'class=BotonHogarActual'
					:'onclick="AbrirFormulario({encuesta:'+pk_ud.encuesta+',nhogar:'+i+',formulario:\'S1\',matriz:\'\'});"'
				)+'>';
		}
		if(localStorage['pk_encuesta_puede_borrar']==pk_ud.encuesta){
			nueva_botonera+='<hr>para borrar hogar: ';
			for(var i=0; i<=max_hogar; i++){
				nueva_botonera+='<input type=button value=" '+(i||'todos')+' " '
					+'onclick="Borrar_Encuesta({encuesta:'+pk_ud.encuesta+',nhogar:'+i+'});"'
					+'>';
			}
		}
		elemento_botonera.innerHTML=nueva_botonera;
		var boton_correr_consistencias=elemento_existente('boton_correr_consistencias');
		if(soy_un_ipad){
			boton_correr_consistencias.style.display='none';
		}else{
			if(tarea_de_etapa=='ingreso'){
				boton_correr_consistencias.value='Finalizar el ingreso';
			}
			if(solo_lectura){
				elemento_existente('boton_cerrar_encuesta').style.display='inline';
				elemento_existente('boton_ver_consistencias').style.display='inline';
				elemento_existente('boton_correr_consistencias').style.visibility='hidden';
				alert('solo lectura '+solo_lectura);
			}else{
				hacer_al_ensuciar.push(function(){elemento_existente('boton_cerrar_encuesta').style.display='none';});
			}
		}
	}
}

function DesplegarInfoVivienda(){
	var parametros=JSON.parse(localStorage.getItem("pk_vivienda_actual"));
	var debug_1=elemento_existente('debug_1');
	debug_1.textContent=parametros+"/"+localStorage.getItem("pk_vivienda_actual");
}

var formularios_elegibles;

function Borrar_Encuesta(parametros){
	var confirmacion=prompt('Confirme que desea borrar la encuesta ingresando el número de encuesta');
	if(confirmacion==pk_ud.encuesta){
		Enviar('eliminar_encuesta.php', parametros
			, function(mensaje){
				alert(mensaje);
				IrAUrl('elegir_vivienda.php');
			}
			, function(mensaje){
				alert('ERROR. '+mensaje);
			}
		);
	}else{
		alert('no coinciden el número de encuesta ingresado con el abierto');
	}
}
function Borrar_Formulario(parametros){
	var id_produccion=localStorage.getItem("ud_id_proc");
	var volver = parametros.volver;
	var confirmacion=prompt('Confirme que desea borrar el formulario ingresando el número de encuesta');
	soy_un_ipad = true;
	if(confirmacion==pk_ud.encuesta){
		Enviar('eliminar_formulario.php', parametros
			, function(mensaje){
				alert(mensaje);
				if(volver){
					localStorage.clear();
					AbrirEncuesta(parametros.encuesta,parametros.nhogar,id_produccion,'borrar');
					
				}else{
					localStorage.clear();
					AbrirEncuesta(parametros.encuesta,parametros.nhogar,id_produccion,'borrar');
				}
				
			}
			, function(mensaje){
				alert('ERROR. '+mensaje);
			}
		);
	}else{
		alert('no coinciden el número de encuesta ingresado con el abierto');
	}
}

function Leer_formularios_elegibles(){
	if(localStorage["formularios_elegibles"]){
		formularios_elegibles=JSON.parse(localStorage["formularios_elegibles"]);
	}else{
		formularios_elegibles=new Object;
	}
}

function Abrir_Formulario_id(){
	var f=document.forms.abrir_formulario_id;
	AbrirFormulario(f.encuesta.value, f.nhogar.value, f.formulario.value, f.matriz.value, f.miembro.value);
}

function ToggleVisible(id){
	var elemento=elemento_existente(id);
	elemento.style.visibility=elemento.style.visibility=='hidden'?'visible':'hidden';
}

function descripciones_de_error(err){
	return ' '+(err.description||'')+' '+(err.message||'')+' '+(err.type_error||'');
}

function Enviar(destino, variable_sin_jsonear, finalizacion_ok, finalizacion_por_error, asincronico){
	if(!asincronico){
		document.body.style.cursor = "wait";
	}
	var peticion=new XMLHttpRequest();
	var rta=false;
	try{
		peticion.onreadystatechange=function(){
			switch(peticion.readyState) { 
				case 4: 
					try{
						rta = peticion.responseText;
						if(peticion.status!=200){
							finalizacion_por_error('Error de status '+peticion.status+' '+peticion.statusText,true);
						}else if(rta){
							try{
								var obtenido=JSON.parse(rta);
								if(obtenido.ok){
									try{
										finalizacion_ok(obtenido.mensaje);
										document.body.style.cursor = "default";
									}catch(err_llamador){
										document.body.style.cursor = "default";
										finalizacion_por_error(descripciones_de_error(err_llamador),true);
									}
								}else{
									document.body.style.cursor = "default";
									finalizacion_por_error(obtenido.mensaje,true);
								}
							}catch(err_json){
								document.body.style.cursor = "default";
								finalizacion_por_error('ERROR PARSEANDO EL JSON '+':'+err_json.description+' / '+JSON.stringify(err_json)+' / '+rta,false);
							}
						}else{
							document.body.style.cursor = "default";
							finalizacion_por_error(peticion.responseText,true);
						}
					}catch(err){
						document.body.style.cursor = "default";
						finalizacion_por_error(descripciones_de_error(err),false);
					}
			}
		}
		peticion.open('POST', destino, (asincronico?true:false)); // !sincronico);
		peticion.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		var parametros="todo="+encodeURIComponent(JSON.stringify(variable_sin_jsonear));
		peticion.send(parametros);
	}catch(err){
		document.body.style.cursor = "default";
		finalizacion_por_error(err);
	}
	if(!asincronico){
		document.body.style.cursor = "default";
		return rta;
	}else{
		document.body.style.cursor = "progress";
	}
}

var IMAGEN_LOADING="<img src='imagenes/mini_loading.gif'>";
var IMAGEN_ERROR="<img src='imagenes/mini_Error.png'>";

function TransmitirTodo(){
	var msg=elemento_existente("mensajes_transmitir_todo");
	msg.innerHTML=IMAGEN_LOADING;
	var i;
	var lo_que_voy_a_mandar=[];
	for(i=0; i<100; i++){
		lo_que_voy_a_mandar[i]={};
		lo_que_voy_a_mandar[i].numero=i;
		lo_que_voy_a_mandar[i].datos=estructura;
	}
	Enviar('recibir.php', lo_que_voy_a_mandar
		, function(respuesta){
			msg.innerHTML="<br>Recibí esta respuesta:<br><pre>"+respuesta+"</pre>";
		}
		, function(error,durante_la_transmision){
			msg.innerHTML=IMAGEN_ERROR+" "+durante_la_transmision+"<br>Recibí esta informe de error:<br><pre>"+error+"</pre>";
		}
	);
}

function PresionTeclaEnVariable(id_variable,evento){
	var tecla=(document.all) ? evento.keyCode : evento.which; 
	if(tecla!=13){
		return;
	}
	suspender_validacion_onblur=true;
	var proximo=ValidarOpcion(id_variable,true);
	if(!proximo){
		proximo=preguntas_ud[id_variable].siguiente;
	}
	if(preguntas_ud[id_variable].saltar_a_boton){
		if(eval(hacer_expresion_evaluable(preguntas_ud[id_variable].expresion_saltar_a_boton))){
			proximo=preguntas_ud[id_variable].saltar_a_boton;
		}
	}
	if(proximo){
		elemento_existente(proximo).focus();
	}
	suspender_validacion_onblur=false;
}

function PresionOtraTeclaEnVariable(id_variable,evento){

	var tecla=(document.all) ? evento.keyCode : evento.which; 
	if(tecla!=38){
		return;
	}
	suspender_validacion_onblur=true;
	var previo=ValidarOtraOpcion(id_variable,true);
	if(previo){
		elemento_existente(previo).focus();
	}	
	suspender_validacion_onblur=false;
}

function enviar_formulario_interno(tipo){
	var formulario=document.forms.formulario_interno;
	var parametros={};
	var verificado=true;
	for(var cual in formulario){
		if(!isNaN(cual)){
			var campo=formulario[cual];
			if(campo.id=='verifico' && !campo.value){
				verificado=false;
			}
			if(!campo.getAttribute('no_pasar')){
				parametros[campo.id]=campo.value;
			}
		}
	}
	if(verificado){
		Enviar('formulario_interno.php?tipo=soporte',{tipo:tipo,parametros:parametros}
			, function(mensaje){
				alert('Ok '+mensaje);
			}
			, function(mensaje){
				alert('ERROR AL PROCESAR EL FORMULARIO: '+mensaje);
			}
		);
	}else{
		alert('No grabó los datos porque no se tildó la casilla de verificación');
	}
}

var editor_inconsistencias;
var editor_his_inconsistencias;
var editor_his_respuestas;
var editor_errores_salto;

function CorrerConsistencias(boton,encuesta,grabando_y_corriendo_consistencias_si_corresponde){
    var destino=document.getElementById('inconsistencias');
    if(!destino){
        var padre=boton.parentNode;
        editor_inconsistencias=new Editor('inconsistencias','inconsistencias',{inc_nenc:encuesta},1);
        padre.innerHTML=padre.innerHTML+editor_inconsistencias.obtener_el_contenedor('span');
        if('el servidor no me va a contestar esto si no soy procesamiento'){
            editor_errores_salto=new Editor('errores_salto','errores_salto',{res_encuesta:encuesta},1);
            padre.innerHTML=padre.innerHTML+editor_errores_salto.obtener_el_contenedor('span');
            editor_his_respuestas=new Editor('his_respuestas','his_respuestas',{res_encuesta:encuesta},1);
            padre.innerHTML=padre.innerHTML+editor_his_respuestas.obtener_el_contenedor('span');
            editor_his_inconsistencias=new Editor('his_inconsistencias','his_inconsistencias',{inc_nenc:encuesta},1);
            padre.innerHTML=padre.innerHTML+editor_his_inconsistencias.obtener_el_contenedor('span');
        }
    }
	var cargar_grillas_para_ver_inconsistencias=function(respuesta){
		editor_inconsistencias.cargar_grilla(boton);
		editor_his_inconsistencias.cargar_grilla(boton);
		editor_his_respuestas.cargar_grilla(boton);
		editor_errores_salto.cargar_grilla(boton);
		if(respuesta && respuesta.habilitar_boton_mandar_a){
			elemento_existente('boton_ver_consistencias').style.display=(!respuesta.habilitar_boton_mandar_a[3])?'inline':'none';
			elemento_existente('boton_cerrar_encuesta').style.display=respuesta.habilitar_boton_mandar_a[3]?'inline':'none';
			elemento_existente('fin_encuesta_4').style.display=respuesta.habilitar_boton_mandar_a[4]?'inline':'none';
			elemento_existente('fin_encuesta_5').style.display=respuesta.habilitar_boton_mandar_a[5]?'inline':'none';
			elemento_existente('fin_encuesta_6').style.display=respuesta.habilitar_boton_mandar_a[6]?'inline':'none';
		}
	}
	if(grabando_y_corriendo_consistencias_si_corresponde){
		Grabando_antes_hacer(cargar_grillas_para_ver_inconsistencias,tarea_de_etapa||'no especificada'); // le pongo no especificada para que sea igual un final de etapa o sea para que consista.
	}else{
		cargar_grillas_para_ver_inconsistencias(false);
	}
}

function enter_va_a(proximo_elemento,evento){
	if(evento.which==13){ // Enter
		proximo_elemento.focus();
	}
}

function nulo_a_neutro(p_valor){
	return p_valor===null?0:p_valor;
}

function MarcarSupervisiones(parametros,este_boton){
	var esta_fila=este_boton.parentNode.parentNode
	// alert(parametros[0]+' y '+parametros[1]+' es '+esta_fila);
	Enviar('marcar_supervisiones.php', parametros, 
		function(mensaje){
			esta_fila.cells[4].style.backgroundColor='Cyan';
		}
		, function(mensaje){
			alert(mensaje);
		}
	);
}

function Mostrar_Estado_Ipad(){
	var tabla=elemento_existente('estados_admin_ipad');
	tabla.innerHTML="";
	var fila;
	var celda;
	fila=tabla.insertRow(-1);
	celda=fila.insertCell(-1);
	celda.textContent="Número de IPAD";
	celda=fila.insertCell(-1);
	celda.textContent=localStorage['numero_de_ipad'];
	fila=tabla.insertRow(-1);
	celda=fila.insertCell(-1);
	celda.textContent="Lote cargado"
	celda=fila.insertCell(-1);
	celda.textContent=localStorage['numero_de_lote'];
	fila=tabla.insertRow(-1);
	celda=fila.insertCell(-1);
	celda.textContent="Encuestas cargadas"
	celda=fila.insertCell(-1);
	celda.textContent=localStorage['encuestas_cargadas'];
}

function Numerar_Ipad(){
	var numero_de_ipad=prompt('Ingrese el nuevo número de IPAD');
	var confirme_ipad=prompt('Ingrese el código de confirmación');
	if(Number(numero_de_ipad)+11==Number(confirme_ipad)){
		guardar_en_localStorage("numero_de_ipad",numero_de_ipad);
	}else{
		alert('error al grabar número de IPAD');
	}
	Mostrar_Estado_Ipad();
}

function Cargar_Lote_a_Ipad(){
	var numero_de_lote=prompt('Ingrese el número de lote a cargar dentro del IPAD '+localStorage['numero_de_ipad']);
	if(numero_de_lote){
		guardar_en_localStorage("numero_de_lote",numero_de_lote);
		Enviar('cargar_encuesta.php', {lote:numero_de_lote}
			, function(datos){
				guardar_en_localStorage('encuestas_cargadas',JSON.stringify(datos.encuestas_cargadas));
				CargarEncuesta(datos);
			}
			, function(mensaje){
				alert('Error al cargar '+mensaje);
			}
		);
		// CargarEncuesta(respuesta);
	}
	Mostrar_Estado_Ipad();
}

function Refresacar_encuestas_a_ingresar(){
	var tabla=elemento_existente('encuestas_a_ingresar');
	tabla.innerHTML="";
	var encuestas_cargadas=JSON.parse(localStorage['encuestas_cargadas']);
	for(var i in encuestas_cargadas){ if(encuestas_cargadas.hasOwnProperty(i)){
		var nenc=encuestas_cargadas[i];
		var fila=tabla.insertRow(-1);
		var celda=fila.insertCell(-1);
		var boton=document.createElement('button');
		boton.textContent='abrir '+nenc;
		boton.setAttribute('nuestro_encuesta',nenc);
		boton.style.fontSize='100%';
		boton.onclick=function(){
			AbrirFormulario({encuesta:Number(this.getAttribute('nuestro_encuesta')),nhogar:1,formulario:'S1',matriz:''});
		}
		celda.appendChild(boton);
	}}
}

function DescargarEncuesta(encuesta){ 		
	var consola=elemento_existente('consola');
	var elegibles_de_esta_encuesta=formularios_elegibles[encuesta+''];
	for(var id_ud in elegibles_de_esta_encuesta){
		var pk_ud=JSON.parse(id_ud);
		var contenido_jsoneado=localStorage['ud_'+id_ud];
		consola.innerHTML=consola.innerHTML+' '+pk_ud.nhogar+' '+pk_ud.formulario+' '+(pk_ud.miembro||'');
		if(!contenido_jsoneado){
			consola.innerHTML=consola.innerHTML+'! ';
		}else{
			var rta_ud=JSON.parse(contenido_jsoneado);
			var estados_rta_ud=null;
			Enviar('grabar.php', {pk_ud:pk_ud, rta_ud:rta_ud, estados_rta_ud:estados_rta_ud, fin_etapa:null}
				, function(mensaje){
					consola.innerHTML=consola.innerHTML+'.';
				}
				, function(mensaje){
					var un_span=document.createElement('span');
					un_span.textContent=mensaje;
					consola.appendChild(un_span);
				}
			);
		}
	}
}

function Descargar_Lote_desde_Ipad_paso(posicion_dentro_de_encuestas_cargadas){
	var encuestas_cargadas=JSON.parse(localStorage['encuestas_cargadas']);
	var consola=elemento_existente('consola');
	if(posicion_dentro_de_encuestas_cargadas<encuestas_cargadas.length){
		var encuesta=encuestas_cargadas[posicion_dentro_de_encuestas_cargadas];
		consola.innerHTML=consola.innerHTML+' <b>'+encuesta+'</b> ';
		DescargarEncuesta(encuesta);
		setTimeout('Descargar_Lote_desde_Ipad_paso('+(Number(posicion_dentro_de_encuestas_cargadas)+1)+')',100); 
	}else{
		consola.innerHTML=consola.innerHTML+'<br>fin de transmición';
	}
}

function Descargar_Lote_desde_Ipad(){
Leer_formularios_elegibles();
elemento_existente('consola').innerHTML='Descargando encuestas:';
var t=setTimeout("Descargar_Lote_desde_Ipad_paso(0);",100);
}

function Borrar_Local_Storage_en_iPad(){
	var menos_nueve=prompt('Ingrese código de verificación de borrado');
	if(menos_nueve==-9){
		var numero_de_ipad=localStorage['numero_de_ipad'];
		Borrar_LocalStorage(true);
		guardar_en_localStorage("numero_de_ipad",numero_de_ipad);
		Mostrar_Estado_Ipad();
	}
}