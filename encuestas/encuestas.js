//UTF-8:SÍ
"use strict";

var operativo_actual;
var anio_operativo;
var $esta_es_la_base_en_produccion;
var para_supervisor=interpretarTrue(localStorage.getItem('para_supervisor'));
var es_un_recepcionista=false;
var es_ing_sup=false;
var puede_ver_todos_los_formularios=false;

window.addEventListener('load',function(){
    if(para_supervisor){
        logo_principal.parentNode.onclick=function(){
            click_ir_url(operativo_actual+".php?hacer=hoja_de_ruta_super",event);
        };
    }
});

var version_js_encuestas='v 3.00c';

var total_encuestas_ipad=0;
var pk_vacia={tra_ope:'', tra_for:'', tra_mat:'', tra_enc:0, tra_hog:0, tra_mie:0, tra_exm:0}; // AGREGAR CLAVE
var pk_nombres=array_keys(pk_vacia);

var FONDO_SALTEAR_OK='DarkGray';
var FONDO_SALTEAR_CON_VALOR='OrangeRed';
var FONDO_SALTEAR_CON_VALOR='OrangeRed';
var FONDO_OPCION_OK='SpringGreen';
var FONDO_OPCION_INVALIDA='Orange';
var FONDO_EN_BLANCO='White';
var FONDO_ARRIBA_EN_BLANCO='Chocolate';
var SEPARADOR_VARIABLE_OPCION='__';

var MAX_FILAS_MATRICES=10;

var soy_un_ipad = las_cookies.soy_un_ipad?las_cookies.soy_un_ipad!='no':/iPad/i.test(navigator.userAgent) || /iPhone/i.test(navigator.userAgent)||/Android/i.test(navigator.userAgent);
var soy_un_ipad_real = /iPad/i.test(navigator.userAgent) || /iPhone/i.test(navigator.userAgent)||/Android/i.test(navigator.userAgent);

var estados_rta=
{ ok:"opc_ok"
, opcion_inexistente:"opc_inex" // un valor que no existe entre las opciones
, ingreso_sobre_salto:"opc_sosa" // ingresó una opción sobre una variable que debía ser salteada
, salteada:"opc_salt" // esta variable no tiene valor, lo cual es correcto, porque tiene un salto que la pasa por encima
, salteada_ocultar:"opc_ocusal" // esta variable hay que saltearla y ocultarla por alguna razon especial
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

var color_estados_ud=
{ completa_ok:"#99FF66" //completa_rea
, vacia:"#66CCFF" 
, incompleta:"#FF3333" 
, completa_con_error:"#FFFF66" 
, primera_vez:"white"
, completa_norea:"#42BF03"
}

var color_fondo=
{ S1:"#C0E0FF"
, I1:"White"
, A1:"LemonChiffon"
, MD:"Pink"
, PG1:"Pink"
, GH: "#F6CED8"
, PMD:"#B6E7D3"
}

function PosicionarSaltoEn(elemento_destino){
    window.scrollTo(0,obtener_top_global(elemento_destino)-80);
}

function ir_a_primer_blanco(){
    var primer_blanco=Validar_rta_ud();
    if(primer_blanco){
        var elemento_renglon = elemento_existente(primer_blanco);
        while(elemento_renglon.className != 'renglon_variable'){
            elemento_renglon = elemento_renglon.parentNode;
        }
        while(elemento_renglon.className != 'encabezado_pregunta' && elemento_renglon.rowIndex > 0){
            elemento_renglon = elemento_renglon.parentNode.rows[elemento_renglon.rowIndex - 1];
        }
        window.scrollTo(0,obtener_top_global(elemento_renglon)-80);
    }
}
function Saltar_de_a(id_de,id_a){  
    elemento_existente(id_de).style.backgroundColor='';
    elemento_existente(id_de).style.color='';
    PosicionarSaltoEn(elemento_existente(id_a));
}

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
    return esta_pregunta_ud.marcar && esta_pregunta_ud.almacenar && valor_en_elemento==esta_pregunta_ud.marcar?esta_pregunta_ud.almacenar:
        valor_en_elemento;
}

function Valor_en_variable_a_valor_para_elemento(id_variable,rta_ud,preguntas_ud){ 
    // necesito preguntas_ud como parámetro porque puede ser una local (en el despliegue horizontal de matrices), no siempre es la global 
    var mostrar=rta_ud[id_variable];
    var esta_pregunta_ud=preguntas_ud[id_variable];
    return esta_pregunta_ud.marcar && esta_pregunta_ud.almacenar && mostrar==esta_pregunta_ud.almacenar?esta_pregunta_ud.marcar:
        mostrar;
}

function ValidarOpcion(id_variable_cursor_actual,forzar){
    if(id_variable_cursor_actual=='var_pyg1'){
        meta_reemplazo_variables(pk_ud);
    }
    if(forzar || !suspender_validacion_onblur){
        var valor_en_elemento=elemento_existente(id_variable_cursor_actual).value;
        var valor_a_guardar_en_rta_ud=Valor_de_elemento_a_variable(valor_en_elemento,id_variable_cursor_actual);
        var valor_anterior=rta_ud[id_variable_cursor_actual];
        // siempre hago la asignación porque no estamos seguros de qué pasa entre null=="". Emilio
        rta_ud[id_variable_cursor_actual]=valor_a_guardar_en_rta_ud;
        if(valor_anterior!=valor_a_guardar_en_rta_ud && !(valor_anterior==null && valor_a_guardar_en_rta_ud=="")){
            if(id_variable_cursor_actual=='var_entrea' && rta_ud.var_entrea==1 && !rta_ud.var_f_realiz_o && rta_ud_tem.var_rol!='ingresador'){                
                rta_ud.var_f_realiz_o=fechadma(new Date());
                elemento_existente('var_f_realiz_o').value=rta_ud.var_f_realiz_o;
            }
            if(variables[id_variable_cursor_actual.substring(4)].var_tipovar=='anio' && rta_ud[id_variable_cursor_actual] && (Number(rta_ud[id_variable_cursor_actual])>=0 && Number(rta_ud[id_variable_cursor_actual])<100)){                            
                rta_ud[id_variable_cursor_actual]=Number(rta_ud[id_variable_cursor_actual])+2000;
                if(rta_ud[id_variable_cursor_actual]>new Date().getFullYear()){
                    rta_ud[id_variable_cursor_actual]=rta_ud[id_variable_cursor_actual]-100;
                }
                elemento_existente(id_variable_cursor_actual).value=rta_ud[id_variable_cursor_actual];
            }
            //condiciones para vcm2018
            if( operativo_actual=='vcm2018' && ((id_variable_cursor_actual=='var_esm1' && rta_ud.var_esm1==2)||(id_variable_cursor_actual=='var_no_entrevista' && rta_ud.var_no_entrevista==1 )) && !rta_ud.var_entrea && rta_ud_tem.var_rol!='ingresador'){
                rta_ud.var_entrea=2;
                elemento_existente('var_entrea').value=rta_ud.var_entrea;
            }
            marcar_que_fue_modificado();
        }      
        var proximo=Validar_rta_ud(id_variable_cursor_actual);
        Colorear_rta_ud();
        GuardarElFormulario();
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
var dbo={}; // las funciones DBO
dbo.anio=function(str_fecha){
    var d = new Date();
    var anio_actual = String(d.getFullYear());  
    if(!str_fecha){ 
        return anio_operativo;
    } else {
        str_fecha=str_fecha.toString();
        str_fecha=str_fecha.replace("-","/");
        var partes=str_fecha.split("/");
        if (partes.length<2||partes.length>3){
            return null;
        }else if(partes.length==2) { // viene dd mm 
            partes[2]=dbo.anio();
        }else{ // viene dd mm aaaa
            if(partes[2].length==3||partes[2].length>4){
                return null;
            }else if(partes[2].length==2){ // puso aa           
                if(partes[2]>anio_actual.substring(2,4)){
                    partes[2]='19'+partes[2];
                }else{
                    partes[2]='20'+partes[2];
                }
            }else if(partes[2].length==1){
                    partes[2]='200'+partes[2];                
            }            
        }
        var fecha = partes[0]+"/"+partes[1]+"/"+partes[2];
        if(dbo.esFechaValida(partes[0],partes[1],partes[2])){
            return partes[2];
        }else{
            return null;
        }
    }
};
var fechadma=function(p_dia, p_mes, p_anio){
    if(p_dia && p_dia instanceof Date){
        p_anio=p_dia.getFullYear();
        p_mes=p_dia.getMonth()+1;
        p_dia=p_dia.getDate();
    }
    var dia;
    var mes;
    var anio;
    if(!p_dia || !p_mes || !p_anio || isNaN(p_dia) || isNaN(p_mes) || isNaN(p_anio)) {
        return '';
    }
    dia=p_dia.toString();
    mes=p_mes.toString();
    anio=p_anio.toString();    
    if(dia.length==1){
        dia='0'+dia;
    }
    if(mes.length==1){
        mes='0'+mes;
    }
    if (dbo.esFechaValida(dia,mes,anio)){
        return dia+'/'+mes+'/'+anio;    
    } else {
        return '';
    }
}
dbo.es_fecha=function(str_fecha){
        if(!str_fecha) return false;
        var partes=new Array();
        str_fecha=str_fecha.toString();
        str_fecha=str_fecha.replace("-","/");
        partes=str_fecha.split("/");
        if (partes.length<2||partes.length>3){
            return null;
        }else if(partes.length==2){
            partes[2]=dbo.anio();
        }else{
            if(partes[2].length==3||partes[2].length>4){
                return null;
            }else if(partes[2].length==2){
                if(partes[2]>12){
                    partes[2]='19'+partes[2];
                }else{
                    partes[2]='20'+partes[2];
                }
            }else if(partes[2].length==1){
                    partes[2]='200'+partes[2];
            }
        }
        var fecha = partes[0]+"/"+partes[1]+"/"+partes[2];      
        return dbo.esFechaValida(partes[0],partes[1],partes[2]);
};
dbo.textoinformado=function(valor){
    return !!valor?1:0;
};
dbo.es_fecha_con_anio=function(str_fecha){
    return dbo.es_fecha(str_fecha,true);
};
dbo.es_fecha_sin_anio=function(str_fecha){
        return dbo.es_fecha(str_fecha,false);
};
dbo.texto_a_fecha=function(str_fecha){
    var partes=new Array();
    str_fecha=str_fecha.toString();
    str_fecha=str_fecha.replace("-","/");
    partes=str_fecha.split("/");
    if (partes.length<2||partes.length>3){
        return null;
    }else if(partes.length==2) { // viene dd mm 
        partes[2]=dbo.anio();
    }else{ // viene dd mm aaaa
        if(partes[2].length==3||partes[2].length>4){
            return null;
        }else if(partes[2].length==2){ // puso aa
            if(partes[2]>dbo.anio().substring(2,4)){
                partes[2]='19'+partes[2];
            }else{
                partes[2]='20'+partes[2];
            }
        }else if(partes[2].length==1){
            partes[2]='200'+partes[2];                
        }            
    }
    var fecha = partes[0]+"/"+partes[1]+"/"+partes[2];
    if(dbo.esFechaValida(partes[0],partes[1],partes[2])){
        return partes;
    }else{
        return null;
    }       
};
dbo.esFechaValida=function(p_dia,p_mes,p_annio){
        var dia  =  parseInt(p_dia,10);
        var mes  =  parseInt(p_mes,10);
        var annio =  parseInt(p_annio,10);
        var numDias;
    switch(mes){
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            numDias=31;
            break;
        case 4: case 6: case 9: case 11:
            numDias=30;
            break;
        case 2:
            if (dbo.comprobarSiBisisesto(annio)){ numDias=29 }else{ numDias=28};
            break;
        default:
            return false;
    }
    if (dia>numDias || dia<1){
        return false;
    }
    var d = new Date();
    var anio_actual = d.getFullYear();
    if(annio<1900 || annio>anio_actual){
        return false;
    }
    return true;
};
dbo.comprobarSiBisisesto=function(annio){
    if ( ( annio % 100 != 0) && ((annio % 4 == 0) || (annio % 400 == 0))) {
        return true;
    } else {
        return false;
    }
};
dbo.nsnc=function(valor){
    if(valor===null){
        return false;
    }
    if(valor=="//"){ 
        return true;
    }
    return false;
};
dbo.fecha_30junio=function(){
    return '30/06/'+dbo.anio();
};
dbo.trimestre_operativo_base=function(){
    if (operativo_actual.substring(0,4)=='etoi' ){
        return parseInt(operativo_actual.substring(6,7));
    }else if(operativo_actual.substring(0,3)=='eah'){ 
        return 4;
    }else{
        return null;
    }
};
dbo.cant_rango_edad=function(encues, nhogar, nedad1, nedad2){
    var cant=0;
    var nro_mie=1;
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); 
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while(ud_este || ud_este!=undefined){
        if(ud_este.var_edad>=nedad1 && ud_este.var_edad<=nedad2){
            cant++;    
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return cant;
};
// Hasta acá llegan las funciones dbo
function nsnc(valor){
    if(valor===null){
        return false;
    }
    if(valor=="//"){ 
        return true;
    }
    return false;
}
function blanco(valor){
    if(valor===null || valor===''){
        return true;
    }
}
function informado(valor){
    return !blanco(valor);
}

function ver_estado_ud(id_ud_actual){
    var estado_este_ud={};
    if(localStorage.getItem("estado_ud_"+JSON.stringify(id_ud_actual))){
        estado_este_ud=JSON.parse(localStorage.getItem("estado_ud_"+JSON.stringify(id_ud_actual)));
    }else{
        estado_este_ud={estado:"primera_vez"};
    }
    return estado_este_ud.estado;
}

function periodicidad(p_rotacion_etoi, p_dominio){
    if(p_dominio==3){
        switch(operativo_actual.substring(0,3)){
            case 'eah': 
                if (anio_operativo >='2014'){
                    if(p_rotacion_etoi== 4){
                        return 'A';
                    }else{
                        return 'T';
                    } 
                }else{
                    return null;
                };
                break;
            case 'eto': 
                return 'T';
                break;
            default:    
                return null;
        }
    }else{
        return null;
    }        
}

function probar_dbo(){
    alert("hola");
}
var debug_expresion_evaluable;

function hacer_expresion_evaluable(expresion_pura){
    var expresion_evaluable=expresion_pura.toLowerCase()
            .replace(/\bis not\b/ig,"!=")
            .replace(/\bis distinct from\b/ig,"<>")
            .replace(/\band\b/ig,"&&")
            .replace(/\bor\b/ig,"||")
            .replace(/\bnot\b/ig,"!")
            .replace(/[A-Za-z]\w*(?!\w|[.(])/g,"rta_ud.var_$&")
            .replace(/rta_ud\.var_copia_/g,"copia_ud.copia_")
            .replace(/rta_ud\.var_encues/g,"pk_ud.tra_enc")
            .replace(/rta_ud\.var_nhogar/g,"pk_ud.tra_hog")
            .replace(/rta_ud\.var_nmiembro/g,"pk_ud.tra_mie")
            .replace(/rta_ud\.var_pk_/g,"pk_ud.")
            .replace(/(\w*_ud\.var_\w*)/g,"$1")
            .replace(/^(.*)<=>(.*)$/g,"($1) = ($2)")
            .replace(/^(.*)=>(.*)$/g,"($1) && !($2)")
            .replace(/([^><!])=/g,"$1 == ")
            .replace(/<>/ig,"!=")
            .replace(/rta_ud.var_false/g,"false")
            .replace(/rta_ud.var_true/g,"true");
    if(!"controlar_que_existan_los_campos"){
        expresion_evaluable=expresion_evaluable.replace(/copia_ud.copia_\w*/g,"$&.valueOf()");
    }
    debug_expresion_evaluable=expresion_evaluable;
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

function cuenta_variables(expresion_evaluada){
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
    var estado = {estado:'vacio'};
    try{
        guardar_en_localStorage("pk_ud_navegacion",JSON.stringify(parametros));
//        guardar_en_localStorage("estado_ud_actual",JSON.stringify(estado));
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
var otras_rta={}; // son los rta_ud de los otros ud de la misma encuesta. 
var rta_ud_tem={}; 
var estados_rta_ud={};
var estados_intermedios={};
var datos_viv={}; // Son los datos de la vivienda actual que se necesitan para administrar los cuestionarios. 
var modificado_db=false;
var modificado_ls=false;
var tarea_de_etapa='ingreso';
var solo_lectura='solo lectura';
var nombres_de_miembros; // Va a tener una copia de los nombres del S1 sacados de los ud de cada for:S1 y mat:P o de los provisorios de la edición actual o del seguimiento del operativo anterior (en ese orden). 
var estado_ud={}; // Son los estados -completo_ok incompleto vacio completo_con_errores- de cada unidad de despliegue
var acciones_al_modificar=[];
var consistir_momento={
    "Relevamiento 1":true,
    "Relevamiento 2":false,
};

var semanas=window.semanas||{};
var variables=window.variables||{};

window.addEventListener('load',function(){
    if(operativo_actual=='same2014'){
        semanas={
            1 :{sem_sem:1 ,
                sem_semana_referencia_desde:'2014-06-29',sem_semana_referencia_hasta:'2014-07-07',       
                sem_30dias_referencia_desde:'2014-06-29',sem_30dias_referencia_hasta:'2014-07-07',
                sem_mes_referencia:'2014-06-01',
                sem_carga_enc_desde:'2014-07-07' ,sem_carga_enc_hasta:'2014-12-31',
                sem_carga_recu_desde:'2014-07-17',sem_carga_recu_hasta:'2014-12-31'}
        };    
    }else if(operativo_actual=='etoi143'){
        semanas={
            1 :{sem_sem:1 ,sem_semana_referencia_desde:'2014-06-29',sem_semana_referencia_hasta:'2014-07-05',sem_30dias_referencia_desde:'2014-06-06',sem_30dias_referencia_hasta:'2014-07-05',sem_mes_referencia:'2014-06-01',sem_carga_enc_desde:'2014-07-07',sem_carga_enc_hasta:'2014-07-23',sem_carga_recu_desde:'2014-07-17',sem_carga_recu_hasta:'2014-08-01'},
            2 :{sem_sem:2 ,sem_semana_referencia_desde:'2014-07-06',sem_semana_referencia_hasta:'2014-07-12',sem_30dias_referencia_desde:'2014-06-13',sem_30dias_referencia_hasta:'2014-07-12',sem_mes_referencia:'2014-07-01',sem_carga_enc_desde:'2014-07-14',sem_carga_enc_hasta:'2014-07-30',sem_carga_recu_desde:'2014-07-24',sem_carga_recu_hasta:'2014-08-08'},
            3 :{sem_sem:3 ,sem_semana_referencia_desde:'2014-07-13',sem_semana_referencia_hasta:'2014-07-19',sem_30dias_referencia_desde:'2014-06-20',sem_30dias_referencia_hasta:'2014-07-19',sem_mes_referencia:'2014-07-01',sem_carga_enc_desde:'2014-07-21',sem_carga_enc_hasta:'2014-08-06',sem_carga_recu_desde:'2014-07-31',sem_carga_recu_hasta:'2014-08-15'},
            4 :{sem_sem:4 ,sem_semana_referencia_desde:'2014-07-20',sem_semana_referencia_hasta:'2014-07-26',sem_30dias_referencia_desde:'2014-06-27',sem_30dias_referencia_hasta:'2014-07-26',sem_mes_referencia:'2014-07-01',sem_carga_enc_desde:'2014-07-28',sem_carga_enc_hasta:'2014-08-13',sem_carga_recu_desde:'2014-08-07',sem_carga_recu_hasta:'2014-08-22'},
            5 :{sem_sem:5 ,sem_semana_referencia_desde:'2014-07-27',sem_semana_referencia_hasta:'2014-08-02',sem_30dias_referencia_desde:'2014-07-04',sem_30dias_referencia_hasta:'2014-08-02',sem_mes_referencia:'2014-07-01',sem_carga_enc_desde:'2014-08-04',sem_carga_enc_hasta:'2014-08-20',sem_carga_recu_desde:'2014-08-14',sem_carga_recu_hasta:'2014-08-29'},
            6 :{sem_sem:6 ,sem_semana_referencia_desde:'2014-08-03',sem_semana_referencia_hasta:'2014-08-09',sem_30dias_referencia_desde:'2014-07-11',sem_30dias_referencia_hasta:'2014-08-09',sem_mes_referencia:'2014-08-01',sem_carga_enc_desde:'2014-08-11',sem_carga_enc_hasta:'2014-08-27',sem_carga_recu_desde:'2014-08-21',sem_carga_recu_hasta:'2014-09-05'},
            7 :{sem_sem:7 ,sem_semana_referencia_desde:'2014-08-10',sem_semana_referencia_hasta:'2014-08-16',sem_30dias_referencia_desde:'2014-07-18',sem_30dias_referencia_hasta:'2014-08-16',sem_mes_referencia:'2014-08-01',sem_carga_enc_desde:'2014-08-18',sem_carga_enc_hasta:'2014-09-03',sem_carga_recu_desde:'2014-08-28',sem_carga_recu_hasta:'2014-09-12'},
            8 :{sem_sem:8 ,sem_semana_referencia_desde:'2014-08-17',sem_semana_referencia_hasta:'2014-08-23',sem_30dias_referencia_desde:'2014-07-25',sem_30dias_referencia_hasta:'2014-08-23',sem_mes_referencia:'2014-08-01',sem_carga_enc_desde:'2014-08-25',sem_carga_enc_hasta:'2014-09-10',sem_carga_recu_desde:'2014-09-04',sem_carga_recu_hasta:'2014-09-19'},
            9 :{sem_sem:9 ,sem_semana_referencia_desde:'2014-08-24',sem_semana_referencia_hasta:'2014-08-30',sem_30dias_referencia_desde:'2014-08-01',sem_30dias_referencia_hasta:'2014-08-30',sem_mes_referencia:'2014-08-01',sem_carga_enc_desde:'2014-09-01',sem_carga_enc_hasta:'2014-09-17',sem_carga_recu_desde:'2014-09-11',sem_carga_recu_hasta:'2014-09-26'},
            10:{sem_sem:10,sem_semana_referencia_desde:'2014-08-31',sem_semana_referencia_hasta:'2014-09-06',sem_30dias_referencia_desde:'2014-08-08',sem_30dias_referencia_hasta:'2014-09-06',sem_mes_referencia:'2014-08-01',sem_carga_enc_desde:'2014-09-08',sem_carga_enc_hasta:'2014-09-24',sem_carga_recu_desde:'2014-09-18',sem_carga_recu_hasta:'2014-10-03'},
            11:{sem_sem:11,sem_semana_referencia_desde:'2014-09-07',sem_semana_referencia_hasta:'2014-09-13',sem_30dias_referencia_desde:'2014-08-15',sem_30dias_referencia_hasta:'2014-09-13',sem_mes_referencia:'2014-09-01',sem_carga_enc_desde:'2014-09-15',sem_carga_enc_hasta:'2014-10-01',sem_carga_recu_desde:'2014-09-25',sem_carga_recu_hasta:'2014-10-10'},
            12:{sem_sem:12,sem_semana_referencia_desde:'2014-09-14',sem_semana_referencia_hasta:'2014-09-20',sem_30dias_referencia_desde:'2014-08-22',sem_30dias_referencia_hasta:'2014-09-20',sem_mes_referencia:'2014-09-01',sem_carga_enc_desde:'2014-09-22',sem_carga_enc_hasta:'2014-10-08',sem_carga_recu_desde:'2014-10-02',sem_carga_recu_hasta:'2014-10-17'}
        };
    }else{
        /*
        var advertencia=document.createElement('div');
        advertencia.textContent='Faltan definir las semanas de referencia para el operativo '+operativo_actual;
        advertencia.className='advertencia';
        document.body.appendChild(advertencia);
        */
    }
});




function fecha_referencia(fecha){
    var d=CrearFechaDesdeTextoISO(fecha);
    return nombre_dias[d.getDay()]+' '+ d.getDate() +' de '+ mes_referencia(fecha);
}

var nombre_meses=['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
var nombre_dias=['domingo','lunes','martes','miercoles','jueves','viernes','sábado'];
var texto_parentesco=['Jefe/a', 'Conyuge/pareja','Hijo/a', "Hijastro/a",'Yerno o nuera','Nieto/a','Padre/madre/suegro/a', 'Hermano/a','Cuñado/a','Sobrino/a','Abuelo/a','Otro familiar','Otro no familiar'];
var texto_parentesco_vcm=['Respondente', 'Conyuge/pareja','Hijo/a', "Hijastro/a",'Yerno o nuera','Nieto/a','Padre/madre/suegro/a', 'Hermano/a','Cuñado/a','Sobrino/a','Abuelo/a','Otro familiar','Otro no familiar'];

function mes_referencia(fecha){
    var d=CrearFechaDesdeTextoISO(fecha);
    return nombre_meses[d.getMonth()];
}

function meta_reemplazo_elemento(pk_ud, elemento){
  if(pk_ud.tra_for=='I1'&&pk_ud.tra_mat==''){
      var pk_ut=cambiandole(pk_ud,{tra_for:'S1',tra_mat:'P'});
      var pk_ut=otras_rta[JSON.stringify(pk_ut)];
      var nombre='_'+pk_ut.var_nombre+'_';
      var rta_ud_I1=otras_rta[JSON.stringify(pk_ud)];
      //var dia=' '+nombre_dias[rta_ud_I1.var_dia -1]+' ';
  }else if(pk_ud.tra_for=='PG1'&&pk_ud.tra_mat=='M'){
      var nombre='_'+(rta_ud.var_pyg1||'______')+'_';
  }else {
      var nombre='..........';
      //var dia='........';
  }
  if (pk_ud.tra_for=='SUP'&& (operativo_actual.substr(0,2)=='ut'||operativo_actual=='vcm2018') && pk_ud.tra_mat==''){ 
      var pk_uts=cambiandole(pk_ud,{tra_for:'S1',tra_mat:''});
      var rta_uts=otras_rta[JSON.stringify(pk_uts)];
      var numero_resp=rta_uts.var_respond;
      var nombre_resp=' '+rta_uts.var_nombrer+' ';
      var frealizac=' '+rta_uts.var_f_realiz_o+'   ';
      var pk_utsp=cambiandole(pk_ud,{tra_for:'S1',tra_mat:'P', tra_mie:parseInt(numero_resp)});
      var rta_utsp=otras_rta[JSON.stringify(pk_utsp)];
      var p4miem=operativo_actual.substr(0,2)=='ut'?rta_utsp.var_p4:rta_utsp.var_p4r;
      var relp_resp=operativo_actual.substr(0,2)=='ut'?' '+texto_parentesco[p4miem-1]+' ':' '+texto_parentesco_vcm[p4miem-1]+' ';
      var pk_utsj=cambiandole(pk_ud,{tra_for:'S1',tra_mat:'P', tra_mie: 1});
      var rta_utsj=otras_rta[JSON.stringify(pk_utsj)];
      var nombre_jefe=operativo_actual.substr(0,2)=='ut'?' '+rta_utsj.var_nombre+' ':'........';
      //a futuro si se sigue utilizando se puede hacer una función para recuperar esta información.
      var numero_respi=rta_uts.var_cr_num_miembro;
      var pk_utspi=cambiandole(pk_ud,{tra_for:'S1',tra_mat:'P', tra_mie:parseInt(numero_respi)});
      var rta_utspi=otras_rta[JSON.stringify(pk_utspi)];
      var nombre_respi=' '+rta_utspi.var_nombre+' ';
      var p4_imie=operativo_actual.substr(0,2)=='ut'?rta_utspi.var_p4:rta_utspi.var_p4r;
      var relp_respi=operativo_actual.substr(0,2)=='ut'?' '+texto_parentesco[p4_imie-1]+' ':texto_parentesco_vcm[p4_imie-1]+' ';
  }else{
      var nombre_resp='........';
      var relp_resp='........';
      var nombre_respi='........';
      var relp_respi='........';
      var nombre_jefe='........';
      var frealizac='........';
  }
  var texto_anterior=elemento.textContent;
  var texto=texto_anterior;
  texto=texto.replace(/___+/g,nombre);
  //texto=texto.replace(/---+/g,dia);
  texto=texto.replace(/@resps1/g,nombre_resp);
  texto=texto.replace(/@parents1/g,relp_resp);
  texto=texto.replace(/@respi1/g,nombre_respi);
  texto=texto.replace(/@parenti1/g,relp_respi);
  texto=texto.replace(/@njefe/g,nombre_jefe);
  texto=texto.replace(/@frealiz/g,frealizac);
  var pk_ud_tem=cambiandole(pk_ud,{tra_for:'TEM', tra_hog:0, tra_mie:0, tra_mat:'', tra_exm:0});
  rta_ud_tem=otras_rta[JSON.stringify(pk_ud_tem)];
  var semana_de_esta_encuesta=rta_ud_tem.copia_semana;
  texto=texto.replace(/@SEM_NUM/g,semanas[semana_de_esta_encuesta].sem_sem);
  texto=texto.replace(/@SEM_REF/g,fecha_referencia(semanas[semana_de_esta_encuesta].sem_semana_referencia_desde)+' a '+fecha_referencia(semanas[semana_de_esta_encuesta].sem_semana_referencia_hasta));
  texto=texto.replace(/@D30_REF/g,fecha_referencia(semanas[semana_de_esta_encuesta].sem_30dias_referencia_desde)+' a '+fecha_referencia(semanas[semana_de_esta_encuesta].sem_30dias_referencia_hasta));
  texto=texto.replace(/@MES_REF/g,mes_referencia(semanas[semana_de_esta_encuesta].sem_mes_referencia));
  if(texto && texto!=texto_anterior){
    elemento.textContent=texto;
  }
}

function marcar_que_fue_modificado(){
  // o sea que hay modificaciones no guardadas
    modificado_db=true;
    modificado_ls=true;
    if(soy_un_ipad){
        var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
        var datos_encuesta=hoja_de_ruta.encuestas[pk_ud.tra_enc];
        datos_encuesta.ultima_modificacion=new Date();
        localStorage.setItem("hoja_de_ruta",JSON.stringify(hoja_de_ruta));
    }
    for(var i in acciones_al_modificar){ if(acciones_al_modificar.hasOwnProperty(i)){
        var accion=acciones_al_modificar[i];
        accion();
    }}
}

var var_anterior={}; // Son las variables anteriores correctas para volver atras con Flecha arriba

function evaluar_en_encuestas(expresion,tolerar_fallas){
"use strict";
    // para evaluar en el contexto de este js
    var expresion_normalizada=hacer_expresion_evaluable(expresion);
    try{
        var valor=eval(expresion_normalizada);
    }catch(err){
        if(!tolerar_fallas){
            throw err;
        }
    }
    return valor;
}

var caracterizacion_estados={};

caracterizacion_estados[estados_rta.todavia_no]='esta_incompleta';
caracterizacion_estados[estados_rta.blanco]='esta_ok';
caracterizacion_estados[estados_rta.omitido]='esta_incompleta';
caracterizacion_estados[estados_rta.hay_omitidas]='esta_incompleta';

caracterizacion_estados[estados_rta.fuera_rango]='tiene_problemas';
caracterizacion_estados[estados_rta.ingreso_sobre_salto]='tiene_problemas';
caracterizacion_estados[estados_rta.opcion_inexistente]='tiene_problemas';
caracterizacion_estados[estados_rta.fuera_de_rango_obligatorio]='tiene_problemas';
caracterizacion_estados[estados_rta.fuera_de_rango_advertencia]='tiene_problemas';
caracterizacion_estados[estados_rta.error_tipo]='tiene_problemas';
caracterizacion_estados[estados_rta.inconsistente]='tiene_problemas';

caracterizacion_estados[estados_rta.salteada]='no_considerar'; // gris de salteada, no es nada
caracterizacion_estados[estados_rta.salteada_ocultar]='no_considerar'; // gris de salteada, no es nada

caracterizacion_estados[estados_rta.ok]='tiene_algo';
caracterizacion_estados[estados_rta.nsnc]='tiene_algo';
caracterizacion_estados[estados_rta.sinesp]='tiene_algo';

function Validar_rta_ud(id_variable_cursor_actual){
    // devuelve el lugar a saltar si está indicada id_variable_cursor_actual
    // si no devuelve la primer variable con blanco
    var calculando_estado_general={
        tiene_problemas:false, // true=cuando pongo en estados_rta_ud un atributo negativo
        tiene_algo:false, // true=cuando pongo en estados_rta_ud = ok
        esta_incompleta:false // true= cuando pongo en estados_rta_ud = todavia_no
    }
    // según estas tres vas a poner
    // en estado_ud_{JSONPK} = 'completa_ok' cuando tiene_algo===true && esta_incompleta===false
    //                       = 'vacia' tiene_algo===false
    //                       = 'incompleta' esta_incompleta===true && tiene_algo===true
    //                       = 'completa_con_error' cuando tiene_algo===true && esta_incompleta===false && tiene_problemas===true
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
                var valor = evaluar_en_encuestas(expresion_filtro);
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
                && (!expresion_habilitar || evaluar_en_encuestas(expresion_habilitar));
            if(!variable_habilitada){
                if(valor){
                    estados_rta_ud[var_actual]=estados_rta.ingreso_sobre_salto;
                }else if(preguntas_ud[var_actual].ocu_sal){
                    estados_rta_ud[var_actual]=estados_rta.salteada_ocultar;
                }else{
                    estados_rta_ud[var_actual]=estados_rta.salteada;
                }
            }else{
                ////// VALIDA EL VALOR
                salteando_hasta=false;
                if(!preguntas_ud[var_actual].la_anterior_es_multiple){
                    la_anterior_esta_ingresada_o_es_optativa_blanca=esta_esta_ingresada;
                }
                if(preguntas_ud[var_actual].la_anterior_es_multiple && !preguntas_ud[var_actual].esta_es_multiple
                && !preguntas_ud[var_actual].optativa){
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
                    if(preguntas_ud[var_actual].la_anterior_es_multiple && !preguntas_ud[var_actual].esta_es_multiple
                    && !preguntas_ud[var_actual].optativa){
                        esta_esta_ingresada=false;
                    }                    
                    if(la_anterior_esta_ingresada_o_es_optativa_blanca){
                        if(!preguntas_ud[var_actual].la_anterior_es_multiple || (preguntas_ud[var_actual].la_anterior_es_multiple && !preguntas_ud[var_actual].esta_es_multiple)){
                            primer_blanco=var_actual||primer_blanco;
                        }
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
                    if(valor=='//'){
                        estados_rta_ud[var_actual]=estados_rta.nsnc;
                    }else if(valor=='--'){
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
                    if((valor=='//' || valor=='--') && (preguntas_ud[var_actual].salta_nsnc||preguntas_ud[var_actual].salta)){
                        salteando_hasta=preguntas_ud[var_actual].salta_nsnc||preguntas_ud[var_actual].salta;
                    }
                }
            }
        }
        
        if(variable_habilitada /* || valor OJO:Poner esto cuando se quiera que el ENTER PARE en las "sosa" */){
            var_anterior_habilitada=var_actual;
        }
        if(!preguntas_ud[var_actual].no_es_variable) {
            if(estados_rta_ud[var_actual]==undefined){
                alert('estado undefined en '+var_actual);
            }
            if(caracterizacion_estados[estados_rta_ud[var_actual]]==undefined){
                alert('caracterizacion undefined en '+var_actual+' tiene '+estados_rta_ud[var_actual]);
            }
            if(estados_rta_ud[var_actual]==estados_rta.blanco){
                if(!preguntas_ud[var_actual].optativa && !preguntas_ud[var_actual].esta_es_multiple /* && !preguntas_ud[var_actual].siguiente || estados_rta_ud[preguntas_ud[var_actual].siguiente] === estados_rta.salteada */){
                    calculando_estado_general.esta_incompleta=true;
                }else{
                    calculando_estado_general[caracterizacion_estados[estados_rta_ud[var_actual]]]=true;
                }
            }else{
                calculando_estado_general[caracterizacion_estados[estados_rta_ud[var_actual]]]=true;
            }
        }
    }
    // alert(id_ud+' xxxx '+JSON.stringify(calculando_estado_general));
    cantidad_de_variables_al_momento=0;
    for(var var_actual in preguntas_ud){
        cantidad_de_variables_al_momento++;
        if(operativo_actual.match(/etoi|eah/i)){
            if(preguntas_ud[var_actual].consistir){
                for(var id_cons in preguntas_ud[var_actual].consistir){
                    var consistencia=preguntas_ud[var_actual].consistir[id_cons];
                    if(consistir_momento[consistencia.momento]){
                        var inconsistente=false;
                        try{
                            if(ultima_variable_con_valor >= cantidad_de_variables_al_momento || var_actual == id_variable_cursor_actual){
                                inconsistente=evaluar_en_encuestas(consistencia.expr,true);
                            }
                        }catch(err){
                            if(!"ver los errores de las consistencias que no andan en JS"){
                                var div_registro=elemento_existente('cabezal_matriz');
                                var div_error=document.createElement('div');
                                div_error.textContent="FALLA "+id_cons+" expresion "+consistencia.expr+" mensaje "+err.message;
                                div_registro.appendChild(div_error);
                            }
                        }
                        var id_cartel='cons_'+id_cons+'_'+id_ud;
                        var cartel=document.getElementById(id_cartel);
                        if(inconsistente){
                            if(!cartel){
                                if('forma de cartel'=='mejor no, mejor como renglón adicional'){
                                    cartel=document.createElement('span');
                                    cartel.id=id_cartel;
                                    if(consistencia.gravedad.toLowerCase() == 'advertencia'){
                                        cartel.className='advertencia flotante';
                                    }else{
                                        cartel.className='inconsistencia flotante';
                                    }
                                    cartel.textContent=consistencia.expl;
                                    document.body.appendChild(cartel);
                                    cartel.style.top=obtener_top_global(elemento_existente(var_actual))+50+'px';
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
                                    var tabla; // a la cual agregarle filas con explicación de las consistencias. 
                                    var renglon_a_insertar;
                                    if(consistir_momento["Relevamiento 2"]){
                                        tabla=elemento_existente('tabla_inconsistencias_R2');
                                        cartel=tabla.insertRow(-1);
                                        renglon_a_insertar=-1;
                                        var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_for;
                                        var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_hog;
                                        var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_mat;
                                        var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_mie;
                                        var celda=cartel.insertCell(-1); celda.textContent=var_actual;
                                    }else{
                                        var ele_de_la_variable=elemento_existente(var_actual);
                                        var fila_de_la_variable=ele_de_la_variable;
                                        while((fila_de_la_variable=fila_de_la_variable.parentNode).className!='renglon_variable'){}
                                        tabla=fila_de_la_variable.parentNode.parentNode;
                                        cartel=tabla.insertRow(fila_de_la_variable.rowIndex+1);
                                        renglon_a_insertar=fila_de_la_variable.rowIndex+2;
                                    }
                                    cartel.id=id_cartel;
                                    var celda=cartel.insertCell(-1);
                                    celda.colSpan=2;
                                    if(consistencia.gravedad.toLowerCase() == 'advertencia'){
                                        celda.className='advertencia';
                                    }else{
                                        celda.className='inconsistencia';
                                    }
                                    celda.textContent=consistencia.expl;
                                    var cartel2=tabla.insertRow(renglon_a_insertar);
                                    cartel2.style.display='none';
                                    cartel2.id=cartel.id+'_ayu';
                                    var celda2=cartel2.insertCell(-1);
                                    celda2.colSpan=99;
                                    celda2.className='consistencia_ayu';
                                    var mostrar_ayu=function(evento){
                                        if(evento.ctrlKey || evento.touches.length>2){
                                            var cartel_ayu=elemento_existente(this.parentNode.id+'_ayu');
                                            cartel_ayu.style.display=null;
                                        }
                                    }
                                    celda.onclick=mostrar_ayu;
                                    celda.ontouchstart=mostrar_ayu;
                                    var txt_ayu='"'+id_cons+'": ';
                                    var separador='';
                                    for(var i_var in consistencia.con_variables) if(iterable(i_var,consistencia.con_variables)){
                                        var variable=consistencia.con_variables[i_var];
                                        txt_ayu+=separador+variable+'='+evaluar_en_encuestas(variable,true);
                                        separador=', ';
                                    }
                                    celda2.textContent=txt_ayu;
                                }
                            }else{
                                if(cartel.nodeName=='TR'){
                                    cartel.style.display='table-row';
                                }else{
                                    cartel.style.display='inline';
                                }
                            }
                            if(estados_rta_ud[var_actual]!=estados_rta.ingreso_sobre_salto){
                                estados_rta_ud[var_actual]=estados_rta.inconsistente;
                            }
                        }else{
                            if(cartel && cartel.style.display!='none'){
                                cartel.style.display='none';
                            }
                        }
                    }
                }
            }
        }else{
            aplicarConsistencias(preguntas_ud, var_actual, id_variable_cursor_actual, ultima_variable_con_valor, cantidad_de_variables_al_momento);
        }
    }
    if(ya_vi_algun_null_erroneo){
        Marcar_Posteriores_Al_Omitidos(variable_omitida);
        calculando_estado_general.esta_incompleta=true;
    }
    estados_intermedios.variable_omitida=variable_omitida;
    /*según estas tres vas a poner
    en estado_ud_{ JSON PK} = 'completa_ok' cuando tiene_algo===true && esta_incompleta===false
                           = 'vacia' tiene_algo===false
                           = 'incompleta' esta_incompleta===true && tiene_algo===true
                           = 'completa_con_error' cuando tiene_algo===true && esta_incompleta===false && tiene_problemas===true*/
    //guardar_en_localStorage("debug_1",JSON.stringify(calculando_estado_general)); 
    
    if(calculando_estado_general.tiene_algo && !calculando_estado_general.esta_incompleta && !calculando_estado_general.tiene_problemas){
        guardar_en_localStorage("estado_ud_"+id_ud,JSON.stringify({estado:"completa_ok"}));  
    }else if(!calculando_estado_general.tiene_algo){
        guardar_en_localStorage("estado_ud_"+id_ud,JSON.stringify({estado:"vacia"}));  
    }else if(calculando_estado_general.esta_incompleta){
        guardar_en_localStorage("estado_ud_"+id_ud,JSON.stringify({estado:"incompleta"}));  
    }else{
        guardar_en_localStorage("estado_ud_"+id_ud,JSON.stringify({estado:"completa_con_error"}));    
    }        
    //return salteando_hasta=='fin'?'boton_fin':(id_variable_cursor_actual?proxima_variable:primer_blanco);
    return id_variable_cursor_actual?(!proxima_variable||proxima_variable=='fin'?'boton_fin':proxima_variable):primer_blanco;
    // return proxima_variable;
}

function mostrar(mensaje){
    var lugar = document.getElementById('grilla-ut-zona-derecha').childNodes[0].childNodes[0].childNodes[4];
    lugar.textContent=mensaje;
}
    


function aplicarConsistencias(preguntas_ud, var_actual, id_variable_cursor_actual, ultima_variable_con_valor, cantidad_de_variables_al_momento, ele_de_la_variable){
    if(preguntas_ud[var_actual].consistir){
        for(var id_cons in preguntas_ud[var_actual].consistir){
            var consistencia=preguntas_ud[var_actual].consistir[id_cons];
            if(consistir_momento[consistencia.momento]){
                var inconsistente=false;
                try{
                    if(ultima_variable_con_valor >= cantidad_de_variables_al_momento || var_actual == id_variable_cursor_actual){
                        inconsistente=evaluar_en_encuestas(consistencia.expr,true);
                    }
                }catch(err){
                    if(!"ver los errores de las consistencias que no andan en JS"){
                        var div_registro=elemento_existente('cabezal_matriz');
                        var div_error=document.createElement('div');
                        div_error.textContent="FALLA "+id_cons+" expresion "+consistencia.expr+" mensaje "+err.message;
                        div_registro.appendChild(div_error);
                    }
                }
                var id_cartel='cons_'+id_cons+'_'+id_ud;
                var cartel=document.getElementById(id_cartel);
                if(inconsistente){
                    if(!cartel){
                        if('forma de cartel'=='mejor no, mejor como renglón adicional'){
                            cartel=document.createElement('span');
                            cartel.id=id_cartel;
                            if(consistencia.gravedad.toLowerCase() == 'advertencia'){
                                cartel.className='advertencia flotante';
                            }else{
                                cartel.className='inconsistencia flotante';
                            }
                            cartel.textContent=consistencia.expl;
                            document.body.appendChild(cartel);
                            cartel.style.top=obtener_top_global(elemento_existente(var_actual))+50+'px';
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
                            var tabla; // a la cual agregarle filas con explicación de las consistencias. 
                            var renglon_a_insertar;
                            if(consistir_momento["Relevamiento 2"]){
                                tabla=elemento_existente('tabla_inconsistencias_R2');
                                cartel=tabla.insertRow(-1);
                                renglon_a_insertar=-1;
                                var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_for;
                                var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_hog;
                                var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_mat;
                                var celda=cartel.insertCell(-1); celda.textContent=pk_ud.tra_mie;
                                var celda=cartel.insertCell(-1); celda.textContent=var_actual;
                            }else{
                                var fila_de_la_variable=ele_de_la_variable||elemento_existente(var_actual);
                                while((fila_de_la_variable=fila_de_la_variable.parentNode).className!='renglon_variable'){}
                                tabla=fila_de_la_variable;
                                while((tabla=tabla.parentNode).tagName!='TABLE'){}
                                var numeroFilaActual=fila_de_la_variable.rowIndex==-1?fila_de_la_variable.numeroOrdenFila:fila_de_la_variable.rowIndex;
                                if(false){
                                    if(fila_de_la_variable.nextSibling){
                                        // cartel=document.createElement('tr');
                                        cartel=tabla.insertRow(2);
                                        alertPromise('tabla.rows.length='+ tabla.rows.length+'  tabla.childNodes.length='+ tabla.childNodes.length);
                                        // tabla.insertBefore(fila_de_la_variable.nextSibling, cartel);
                                        // tabla.appendChild(cartel);
                                    }else{
                                        cartel=tabla.insertRow(-1);
                                    }
                                }else{
                                    cartel=tabla.insertRow(numeroFilaActual+1 == tabla.rows.length?-1:numeroFilaActual+1);
                                }
                                renglon_a_insertar=fila_de_la_variable.rowIndex+2;
                            }
                            cartel.id=id_cartel;
                            var celda=cartel.insertCell(-1);
                            celda.colSpan=99;
                            if(consistencia.gravedad.toLowerCase() == 'advertencia'){
                                celda.className='advertencia';
                            }else{
                                celda.className='inconsistencia';
                            }
                            celda.textContent=consistencia.expl;
                            var cartel2=tabla.insertRow(renglon_a_insertar == tabla.rows.length?-1:renglon_a_insertar);
                            cartel2.style.display='none';
                            cartel2.id=cartel.id+'_ayu';
                            var celda2=cartel2.insertCell(-1);
                            celda2.colSpan=99;
                            celda2.className='consistencia_ayu';
                            var mostrar_ayu=function(evento){
                                if(evento.ctrlKey || evento.touches.length>2){
                                    var cartel_ayu=elemento_existente(this.parentNode.id+'_ayu');
                                    cartel_ayu.style.display=null;
                                }
                            }
                            celda.onclick=mostrar_ayu;
                            celda.ontouchstart=mostrar_ayu;
                            var txt_ayu='"'+id_cons+'": ';
                            var separador='';
                            for(var i_var in consistencia.con_variables) if(iterable(i_var,consistencia.con_variables)){
                                var variable=consistencia.con_variables[i_var];
                                txt_ayu+=separador+variable+'='+evaluar_en_encuestas(variable,true);
                                separador=', ';
                            }
                            celda2.textContent=txt_ayu;
                        }
                    }else{
                        if(cartel.nodeName=='TR'){
                            cartel.style.display='table-row';
                        }else{
                            cartel.style.display='inline';
                        }
                    }
                    if(!ele_de_la_variable && estados_rta_ud[var_actual]!=estados_rta.ingreso_sobre_salto){
                        estados_rta_ud[var_actual]=estados_rta.inconsistente;
                    }
                }else{
                    if(cartel){
                        cartel.style.display='none';
                    }
                }
            }
        }
    }
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
"use strict";
    for(var var_actual in estados_rta_ud){
        if(!preguntas_ud[var_actual].no_es_variable){
            var ele=elemento_existente(var_actual);
            var className=ele.className.replace(/ opc_.*$/,'');
            className+=' '+estados_rta_ud[var_actual];
            if(ele.className!=className){
                ele.className=className;
            }
            ele.value=Valor_en_variable_a_valor_para_elemento(var_actual,rta_ud,preguntas_ud);
            for(var opc_actual in preguntas_ud[var_actual].opciones){
                var ele_opc=elemento_existente(var_actual+SEPARADOR_VARIABLE_OPCION+opc_actual);
                var className=ele_opc.className.replace(/ opc_.*$/,'');
                if(preguntas_ud[var_actual].almacenar?opc_actual=preguntas_ud[var_actual].almacenar:opc_actual==rta_ud[var_actual]){
                    className+=' '+estados_rta_ud[var_actual];
                }
                if(ele_opc.className!=className){
                    ele_opc.className=className;
                }
            }
            var pregunta=document.querySelector('[referencia="pregunta-'+var_actual.replace(/^var_/,'').toUpperCase()+'"].renglon_variable')
            if(pregunta){
                var display = (estados_rta_ud[var_actual]=='opc_ocusal'?'none':'');
                if(pregunta.style.display!=display){
                    pregunta.style.display=display;
                }
            }
        }
    }
}

var lista_errores_provisorios=new Object;

function Avisar_si_da_error(proceso,haciendo){
"use strict";
    try{
        return proceso();
    }catch(err){
        alert('error '+haciendo);
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

function colocar_en_elemento_valor_con_anterior_si_hay(elemento,texto_a_meter,texto_anterior_quizas,texto_anterior_quizas2){
"use strict";
    elemento.innerHTML="";
    var span=document.createElement('span');
    if(copia_ud.copia_participacion!=2){
        if(texto_anterior_quizas || texto_anterior_quizas2){
            span.textContent=texto_anterior_quizas2||'-';
            span.className='datos_seguimiento';
            elemento.appendChild(span);
            span=document.createElement('span');
        }
    }
    if(texto_anterior_quizas || texto_anterior_quizas2){
        span.textContent=texto_anterior_quizas||'-';
        span.className='datos_seguimiento';
        elemento.appendChild(span);
        span=document.createElement('span');
    }
    span.textContent=texto_a_meter;
    elemento.appendChild(span);
}

function Pasar_rta_ud_a_elementos_y_controlar(preguntas_ud,rta_ud,donde_meterlo,prefijo,preguntas_copiar_ud,rta_ud_seguimiento,rta_ud_seguimiento2,donde){
    for(var i in preguntas_ud){
        if(!preguntas_ud[i].no_es_variable && (donde!='matriz' || !i.match(/.*_esp$/i))){
            //var elemento=document.getElementById(prefijo+i);
            var elemento=elemento_existente(prefijo+i);
            if(rta_ud && !rta_ud[i] && rta_ud[i]!==0 && rta_ud[i]!=="0"){
                rta_ud[i]=null;
                if(!soy_un_ipad && elemento.type=='number'){
                    elemento.type='text';
                }            
            }
            //Avisar_si_da_error(function(){
                var texto_a_meter=rta_ud?Valor_en_variable_a_valor_para_elemento(i,rta_ud,preguntas_ud):'';
                if(donde_meterlo=='viaDOM'){
                    colocar_en_elemento_valor_con_anterior_si_hay(
                        elemento,
                        texto_a_meter,
                        (rta_ud_seguimiento?Valor_en_variable_a_valor_para_elemento(i,rta_ud_seguimiento,preguntas_ud):null),
                        (rta_ud_seguimiento2?Valor_en_variable_a_valor_para_elemento(i,rta_ud_seguimiento2,preguntas_ud):null)
                    );
                }else{
                    elemento[donde_meterlo]=texto_a_meter;
                }
                if(!soy_un_ipad && elemento.type=='number'){
                    elemento.type='text';
                }
                if(elemento.type == 'textarea'){
                    extender_elemento_al_contenido(elemento);
                }                
            //},'desplegando la variable '+i+' en '+prefijo+i+' para '+JSON.stringify(rta_ud));
        }
    }
    Pasaje_rta_ud_a_elementos_controlar(preguntas_ud,rta_ud,preguntas_copiar_ud);
}

function Pasaje_rta_ud_a_elementos_controlar(preguntas_ud,rta_ud,preguntas_copiar_ud){
    if(preguntas_copiar_ud){
        for(var i in preguntas_copiar_ud){
            var def_copia=preguntas_copiar_ud[i];
            var otra_ud=JSON.stringify(cambiandole(pk_ud,def_copia.cambiador_id,true,'borrar'));
            if(!(otra_ud in otras_rta)){
                otras_rta[otra_ud]=JSON.parse(localStorage.getItem("ud_"+otra_ud));
            }
            Avisar_si_da_error(function(){
                if(def_copia.tipovar=='numeros'){
                    copia_ud[def_copia.destino]=Number((otras_rta[otra_ud]||[])[def_copia.origen]);
                }else{
                    copia_ud[def_copia.destino]=(otras_rta[otra_ud]||[])[def_copia.origen];
                }
            },'copiando variables');
        }
    }
    copia_ud.copia_nhogar=pk_ud.tra_hog;//generalizar
    for(var i in rta_ud){
        if(!preguntas_ud[i] || preguntas_ud[i].no_es_variable){
            //alert('en el local storage había datos "'+rta_ud[i]+'" para la variable inexistente "'+i+'"');
            delete rta_ud[i];
        }
    }
}

function pk_ud_otros_formularios_hermanos_de(una_pk_cualquiera,ultimo_campo_pk){
    var rta=[];
    for(formulario in estructura.otros_datos_formulario) if(iterable(formulario,estructura.otros_datos_formulario)){
        var matrices_del_formulario=estructura.otros_datos_formulario[formulario].matrices;
        for(matriz in matrices_del_formulario) if(iterable(matriz,matrices_del_formulario)){
            if(matrices_del_formulario[matriz].ultimo_campo_pk==ultimo_campo_pk){
                if(una_pk_cualquiera.tra_for!=formulario || una_pk_cualquiera.tra_mat!=matriz){
                    rta.push(cambiandole(una_pk_cualquiera,{tra_for:formulario, tra_mat:matriz}));
                }
            }
        }
    }
    return rta;
}

function cargar_otras_rta(){
    otras_rta={};
    var pk_otras=JSON.parse(localStorage.getItem("claves_de_"+pk_ud.tra_enc));
    for(var pk in pk_otras) if(iterable(pk,pk_otras)){
        otras_rta[pk]=JSON.parse(localStorage.getItem("ud_"+pk));
    }
}


function habilitar_boton(idboton, si_o_no, invisibilizar){
    var elemento=elemento_existente(idboton);
    var deshabilitado=si_o_no===false
    elemento.disabled=deshabilitado;  // null o true o cualquier otra cosa lo habilita
    if(invisibilizar){
        elemento.style.visibility=deshabilitado?'hidden':'visible';
    }
}  

function Llenar_rta_ud(formulario,matriz,invisible){
    consistir_momento["Relevamiento 2"]=!!invisible;
    id_ud=JSON.stringify(pk_ud);
    preguntas_ud=estructura.formulario[formulario][matriz];
    rta_ud=JSON.parse(localStorage.getItem("ud_"+id_ud));
    if(localStorage.getItem("estado_ud_"+id_ud)){
        estado_ud=JSON.parse(localStorage.getItem("estado_ud_"+id_ud));
    }
    var claves=JSON.parse(localStorage['claves_de_'+pk_ud.tra_enc]);
    var clave=claves[id_ud];
    if(clave==undefined){
        claves[id_ud]=true;
        if(rta_ud){
            alert('ATENCIÓN Hay datos en esta PC sobre esta encuesta. Puede ser una encuesta eliminada. Avisar en caso contrario.');
        }
        guardar_en_localStorage('claves_de_'+pk_ud.tra_enc,JSON.stringify(claves));
    }
    if(!rta_ud || rta_ud==undefined){
        rta_ud=new Object();
    }
    var con_personas_y_seguimiento;
    if(pk_ud.tra_for=='S1'){ // especial para poner los nombres y los satos del seguimiento
        con_personas_y_seguimiento=true;
    }
    cargar_otras_rta();
    if(!invisible){
        Pasar_rta_ud_a_elementos_y_controlar(preguntas_ud,rta_ud,"value",'',(estructura.copias[formulario]||{})[matriz]);
    }else{
        Pasaje_rta_ud_a_elementos_controlar(preguntas_ud,rta_ud,(estructura.copias[formulario]||{})[matriz]);
    }
    if(pk_ud.tra_for=='I1' && pk_ud.tra_ope==operativo_actual){ // OJO: GENERALIZAR OPERATIVO
        var pk_ud_TEM_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}));
        var datos_TEM=(
            otras_rta[pk_ud_TEM_json]||
            (otras_rta[pk_ud_TEM_json]=JSON.parse(localStorage.getItem("ud_"+pk_ud_TEM_json))) // si no la tengo la busco
        );
        copia_ud.copia_version_cuest=datos_TEM.copia_version_cuest;
        copia_ud.copia_participacion=datos_TEM.copia_participacion;
        copia_ud.copia_dominio=datos_TEM.copia_dominio;
       // copia_ud.copia_nenc=pk_ud.tra_enc;
       // copia_ud.copia_cantmen65=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,65);
        copia_ud.copia_cantmen66=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,66);
        copia_ud.copia_cantmen13=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,13);
        copia_ud.copia_cantmen15=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,15);
    }
    if(pk_ud.tra_for=='S1' && pk_ud.tra_ope==operativo_actual){ // OJO: GENERALIZAR OPERATIVO
        var pk_ud_TEM_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}));
        var datos_TEM=(
            otras_rta[pk_ud_TEM_json]||
            (otras_rta[pk_ud_TEM_json]=JSON.parse(localStorage.getItem("ud_"+pk_ud_TEM_json))) // si no la tengo la busco
        );
        copia_ud.copia_participacion=datos_TEM.copia_participacion;
        copia_ud.copia_dominio=datos_TEM.copia_dominio;
        copia_ud.copia_cantmen14=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,14);
        copia_ud.copia_cantmen65=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,65);
    }
   // if(pk_ud.tra_ope==operativo_actual && ( (pk_ud.tra_for=='A1' && operativo_actual=='ppmulti' ) || (pk_ud.tra_for=='PMD' && operativo_actual=='eah2019') ) ){ // OJO: GENERALIZAR OPERATIVO
     if(pk_ud.tra_for=='PMD' && pk_ud.tra_ope==operativo_actual){
        var pk_ud_TEM_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}));
        var datos_TEM=(
            otras_rta[pk_ud_TEM_json]||
            (otras_rta[pk_ud_TEM_json]=JSON.parse(localStorage.getItem("ud_"+pk_ud_TEM_json))) // si no la tengo la busco
        );
        copia_ud.copia_dominio=datos_TEM.copia_dominio;
        copia_ud.copia_cantmen13=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,13);
        copia_ud.copia_cantmen18=dbo.cant_menores(pk_ud.tra_enc, pk_ud.tra_hog,18);
        copia_ud.copia_cantrango6a17=dbo.cant_rango_edad(pk_ud.tra_enc, pk_ud.tra_hog,6,17);
        copia_ud.copia_cantrango3a5=dbo.cant_rango_edad(pk_ud.tra_enc, pk_ud.tra_hog,3,5);
        copia_ud.copia_cantrango15a17=dbo.cant_rango_edad(pk_ud.tra_enc, pk_ud.tra_hog,15,17);
        copia_ud.copia_cantrango3a17=dbo.cant_rango_edad(pk_ud.tra_enc, pk_ud.tra_hog,3,17);
    }
    if(pk_ud.tra_for=='S1' && pk_ud.tra_mat=='' && !invisible){ // especial para poner los nombres y los satos del seguimiento
        if(copia_ud.copia_participacion>1){
            var texto_poner='';
            var datos_participacion=function(texto_ordinal,operativo){
                var ud_anterior=otras_rta[JSON.stringify(cambiandole(pk_ud,{tra_ope:operativo}))];
                if(ud_anterior){
                    texto_poner+='participación '+texto_ordinal+': '+
                        (ud_anterior.var_entrea==1?'REA':((ud_anterior.var_entrea==2?'no-rea':'cod_esp:'+ud_anterior.var_entrea)+' '+
                            (ud_anterior.var_razon1||'-')+
                            (ud_anterior.var_razon2_1||'')+
                            (ud_anterior.var_razon2_2||'')+
                            (ud_anterior.var_razon2_3||'')+
                            (ud_anterior.var_razon2_4||'')+
                            (ud_anterior.var_razon2_5||'')+
                            (ud_anterior.var_razon2_6||'')+
                            (ud_anterior.var_razon2_7||'')+
                            (ud_anterior.var_razon2_8||'')+
                            (ud_anterior.var_razon2_9||'')
                        ))+
                        (ud_anterior.var_total_h>1?'. ERAN '+ud_anterior.var_total_h+' HOGARES':'')
                        ;
                }else if(copia_ud.copia_participacion==3 && texto_ordinal=='2010'){
                    texto_poner+='participación '+texto_ordinal+': no-rea';
                }else{
                    texto_poner+=texto_ordinal+' no participó.';
                }
            }
            datos_participacion('2011','eah2011'); // OJO: GENERALIZAR el operativo
            texto_poner+="<br>";
            datos_participacion('2012','eah2012'); // OJO: GENERALIZAR el operativo
            //elemento_existente('mas_datos_entrea').innerHTML=texto_poner;
            elemento_existente('mas_datos_entrea').innerHTML='';
        }
    }
    if(!invisible && !matriz){ // No soy el ud de una matriz, estoy en el ud principal de un formulario
        var rta_ud_renglon_seguimiento=null;
        var rta_ud_renglon_seguimiento2=null;
        for(var matriz_hija in estructura.formulario[formulario]){
            if(matriz_hija && formulario!='I1'){ // si matriz_hija=='' no es hija
                var ya_agregue_una_en_blanco=false;
                var ultimo_campo_pk=estructura.otros_datos_formulario[pk_ud.tra_for].matrices[matriz_hija].ultimo_campo_pk;
                var num_renglon=0;
                var cantidad_renglones_matriz=0;
                for(var clave_json in claves) if(iterable(clave_json,claves)){
                    var clave=JSON.parse(clave_json);
                    if(clave.tra_ope==pk_ud.tra_ope && clave.tra_hog==pk_ud.tra_hog &&
                       ((ultimo_campo_pk=='mie' || ultimo_campo_pk=='exm') && clave.tra_for==pk_ud.tra_for)){ // OJO GENERALIZAR
                        if(cantidad_renglones_matriz<clave['tra_'+ultimo_campo_pk]){
                            cantidad_renglones_matriz=clave['tra_'+ultimo_campo_pk];
                        }
                    }
                } // acá tengo en cantidad_renglones_matriz lo que surge de las claves 
                if(con_personas_y_seguimiento){
                    for(var num_mie in nombres_de_miembros) if(iterable(num_mie,nombres_de_miembros)){
                        if(cantidad_renglones_matriz<Number(num_mie) && nombres_de_miembros[num_mie].nombre != undefined){
                            cantidad_renglones_matriz=Number(num_mie);
                        }
                    }
                }
                var renglones_en_blanco_vistos=0;
                var rta_ud_renglon_matriz={};
                var pk_ud_renglon;
                var celda_nombre;
                var agregar_renglon=function(num_renglon,agregar_renglon_por_ingreso_de_un_miembro_nuevo){
                    if(agregar_renglon_por_ingreso_de_un_miembro_nuevo){
                        rta_ud_renglon_matriz=null;
                        pk_ud_renglon=cambiandole(pk_ud_renglon,{tra_mie:num_renglon});
                    }
                    if(cantidad_renglones_matriz<num_renglon && cantidad_renglones_matriz<100){
                        cantidad_renglones_matriz=num_renglon;
                    }
                    var nombre_miembro_anterior;
                    if(con_personas_y_seguimiento){
                        rta_ud_renglon_seguimiento=JSON.parse(localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud_renglon,{tra_ope:'eah2012'})))||"null");
                        rta_ud_renglon_seguimiento2=JSON.parse(localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud_renglon,{tra_ope:'eah2011'})))||"null");
                    }
                    var fila=elemento_existente('fila_matriz_'+matriz_hija);
                    var str_nueva_fila=fila.innerHTML;
                    str_nueva_fila=str_nueva_fila
                        .replace(/id="var_/g,'id="r'+num_renglon+'_var_'); // var_T4 r1_var_T4                    
                    var nueva_fila;
                    str_nueva_fila+="<td class='boton_abrir_formulario'>";
                    str_nueva_fila+=boton_abre_formulario(pk_ud_renglon,num_renglon);
                    var pks_otros_botones=pk_ud_otros_formularios_hermanos_de(pk_ud_renglon,ultimo_campo_pk);
                    if(rta_ud_renglon_matriz && pk_ud.tra_for!='A1' && pk_ud.tra_for!='PG1' && pk_ud.tra_for!='GH' && pk_ud.tra_for!='PDM' /*&& (pk_ud.tra_for=='I1' */&& pk_ud.tra_mat!='Z'){
                        for(var id_pk in pks_otros_botones) if( iterable(id_pk,pks_otros_botones)){ 
                            var datos_formulario=estructura.otros_datos_formulario[pks_otros_botones[id_pk].tra_for];
                            if (!datos_formulario.es_especial && 
                              ( (operativo_actual.substr(0,2)!='ut' && operativo_actual!='vcm2018')||(  (operativo_actual.substr(0,2)=='ut'|| operativo_actual=='vcm2018') &&(  (pk_ud.tra_for!='SUP'&& pk_ud.tra_for!='S1')|| (pk_ud.tra_for=='SUP' && pks_otros_botones[id_pk].tra_for!='S1' && pks_otros_botones[id_pk].tra_for!='I1')|| (pk_ud.tra_for=='S1' && pks_otros_botones[id_pk].tra_for!='SUP') ) )  )
                              ){ 
                            str_nueva_fila+=boton_abre_formulario(pks_otros_botones[id_pk],num_renglon);
                            }
                        }
                    }
                    nueva_fila=fila.parentNode.rows[num_renglon+1];
                    if(!nueva_fila){
                        nueva_fila=fila.parentNode.insertRow(num_renglon);
                    }
                    nueva_fila.id='fila_matriz_'+matriz_hija+'_'+num_renglon;
                    nueva_fila.className=fila.className;
                    nueva_fila.innerHTML=str_nueva_fila;
                    ya_agregue_una_en_blanco=!rta_ud_renglon_matriz;
                    nueva_fila.cells[0].textContent=num_renglon;
                    if(true || rta_ud_renglon_matriz || rta_ud_renglon_seguimiento || rta_ud_renglon_seguimiento2 || !ya_agregue_una_en_blanco || nombres_en_blanco<2 || agregar_renglon_por_ingreso_de_un_miembro_nuevo){
                        Pasar_rta_ud_a_elementos_y_controlar(
                            estructura.formulario[formulario][matriz_hija]
                            ,rta_ud_renglon_matriz
                            ,"viaDOM"
                            ,'r'+num_renglon+'_'
                            ,null
                            ,rta_ud_renglon_seguimiento
                            ,rta_ud_renglon_seguimiento2
                            ,'matriz'
                        );
                        var matriz_renglon=(rta_ud_renglon_matriz||{});
                        if (matriz_renglon!={}){
                            var matriz_p7=matriz_renglon.var_p7;
                            if (matriz_p7==3 || matriz_p7==4 || (matriz_p7===null && copia_ud.copia_participacion!=1)){
                                document.getElementById('boton_I1__'+num_renglon).disabled=true;                                
                            };
                            if(pk_ud.tra_ope=='eah2018' && pk_ud.tra_for=='S1' && pk_ud.tra_mat==''){
                                var pk_ud_I1_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'I1', tra_mat:'', tra_mie:num_renglon, tra_exm:0}));
                                var rta_ud_I1_json=localStorage.getItem("ud_"+pk_ud_I1_json);
                                var rta_ud_I1=rta_ud_I1_json?JSON.parse(rta_ud_I1_json):{};
                                var idboton='boton_MD__'+String(num_renglon);
                                if(document.getElementById(idboton)){
                                    if(rta_ud_I1.var_pd==1){
                                        habilitar_boton(idboton, true, true); 
                                    }else{
                                        habilitar_boton(idboton, false, true); 
                                    }
                                }
                            }
                        }
                        if(con_personas_y_seguimiento){
                            var crear_input=function(){
                                celda_nombre=elemento_existente('r'+num_renglon+'_var_nombre');
                                var nombre_actual=rta_ud_renglon_matriz?rta_ud_renglon_matriz.var_nombre:'';
                                var nombre_anterior=rta_ud_renglon_seguimiento?rta_ud_renglon_seguimiento.var_nombre:'';
                                var nombre_anterior2=rta_ud_renglon_seguimiento2?rta_ud_renglon_seguimiento2.var_nombre:'';
                                colocar_en_elemento_valor_con_anterior_si_hay(
                                    celda_nombre,
                                    '', //nombre_actual,
                                    nombre_anterior,
                                    nombre_anterior2
                                );
                                celda_nombre.setAttribute('nuestro_numero_renglon',num_renglon);
                                celda_nombre.setAttribute('nuestro_nombre_anterior',nombre_anterior);
                                celda_nombre.setAttribute('nuestro_nombre_anterior2',nombre_anterior2);
                                if(agregar_renglon_por_ingreso_de_un_miembro_nuevo){
                                    celda_nombre.setAttribute('nuestro_es_la_ultima_celda',1);
                                }
                                var input_nombre=document.createElement('input');
                                input_nombre.value=nombre_actual;
                                input_nombre.className='input_nombre_matriz';
                                //input_nombre.title='input_nombre_matriz_'+num_renglon+':'+nombre_actual;
                                celda_nombre.appendChild(input_nombre);
                                input_nombre.onblur=function(){
                                    var celda=this.parentNode;
                                    var num_renglon=celda.getAttribute('nuestro_numero_renglon')-0;
                                    var nombre_anterior=celda.getAttribute('nuestro_nombre_anterior');
                                    var nombre_anterior2=celda.getAttribute('nuestro_nombre_anterior2');
                                    if(this.value=='.'){
                                        this.value=nombre_anterior||nombre_anterior2||'';
                                    }
                                    var nuevo_nombre=this.value;
                                    modificado_ls=true;
                                    colocar_en_elemento_valor_con_anterior_si_hay(celda,nuevo_nombre,nombre_anterior,nombre_anterior2);
                                    var pk_rta_ud_renglon=JSON.stringify(cambiandole(pk_ud,{tra_mat:'P',tra_mie:num_renglon}));
                                    rta_ud_renglon_matriz=otras_rta[pk_rta_ud_renglon];
                                    if(!rta_ud_renglon_matriz){
                                        rta_ud_renglon_matriz={};
                                        var claves=JSON.parse(localStorage['claves_de_'+pk_ud.tra_enc]);
                                        claves[pk_rta_ud_renglon]=true;
                                        guardar_en_localStorage('claves_de_'+pk_ud.tra_enc,JSON.stringify(claves));
                                    }
                                    rta_ud_renglon_matriz.var_nombre=nuevo_nombre;
                                    guardar_en_localStorage("ud_"+pk_rta_ud_renglon,JSON.stringify(rta_ud_renglon_matriz));
                                    crear_input();
                                    if(num_renglon==cantidad_renglones_matriz){
                                        agregar_renglon(Number(num_renglon)+1,true);
                                    }
                                }
                            }
                            crear_input();
                        }
                    }
                }
                cantidad_renglones_matriz++;
                while(num_renglon<cantidad_renglones_matriz){
                    num_renglon++;
                    renglones_en_blanco_vistos++;
                    pk_ud_renglon=cambiandole(pk_ud,{tra_mat:matriz_hija});
                    pk_ud_renglon['tra_'+ultimo_campo_pk]=num_renglon;
                    rta_ud_renglon_matriz=JSON.parse(localStorage.getItem("ud_"+JSON.stringify(pk_ud_renglon))||"null");
                    agregar_renglon(num_renglon,false);                    
                }
                if(con_personas_y_seguimiento){ // agregar a la última celda la posibilidad de agregar un renglón en blanco
                    celda_nombre.setAttribute('nuestro_es_la_ultima_celda',1);
                }                
            }
        }
        if(formulario=='S1' && operativo_actual!='same2014' && operativo_actual!='ut2015'  && operativo_actual!='ut2016' && operativo_actual!='colon2015' && operativo_actual!='empav31' && operativo_actual!='eder2017' && operativo_actual!='vcm2018'){
            var boton_general_A1=elemento_existente('boton_general_A1');
            boton_general_A1.innerHTML=boton_abre_formulario(cambiandole(pk_ud,{tra_for:'A1'}),'');
        }
        if(formulario=='S1' && ( operativo_actual=='eah2014'|| operativo_actual=='eah2018') ){
            var pk_ud_A1_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'A1', tra_mat:'', tra_mie:0, tra_exm:0}));
            var rta_ud_A1_json=localStorage.getItem("ud_"+pk_ud_A1_json);
            var rta_ud_A1=rta_ud_A1_json?JSON.parse(rta_ud_A1_json):{};
            if(rta_ud_A1.var_pygf1a==1 || rta_ud_A1.var_pygf1b==1){
                var boton_general_PG1=elemento_existente('boton_general_PG1');
                boton_general_PG1.innerHTML=boton_abre_formulario(cambiandole(pk_ud,{tra_for:'PG1'}),'');
            }
        }
        if(formulario=='S1' &&( (operativo_actual.substr(0,4)=='etoi' && parseInt(operativo_actual.substr(4))>=162 && parseInt(operativo_actual.substr(4))<=172 )|| (operativo_actual.substr(0,3)=='eah' && anio_operativo=='2016' ) )&& copia_ud.copia_dominio==3){
            var boton_general_GH=elemento_existente('boton_general_GH');
            boton_general_GH.innerHTML=boton_abre_formulario(cambiandole(pk_ud,{tra_for:'GH'}),'');
        }
        if(formulario=='S1' && operativo_actual=='eah2019'){
            var boton_general_PMD=elemento_existente('boton_general_PMD');
            boton_general_PMD.innerHTML=boton_abre_formulario(cambiandole(pk_ud,{tra_for:'PMD'}),'');
        }
    }
    estados_rta_ud={};
    var primer_blanco=Validar_rta_ud();
    if(!invisible){
        if(sessionStorage['poner_foco']){
            elemento_existente(sessionStorage['poner_foco']).focus();
            sessionStorage.removeItem('poner_foco');
        }else{
            if(primer_blanco){
                elemento_existente(primer_blanco).focus();
            }
        }
        Colorear_rta_ud();
    }
    modificado_ls=false;
    modificado_db=false;
    grabar_si_es_necesario_o_seguir(!!sessionStorage['pantalla-especial-modifico-db']);
    sessionStorage['pantalla-especial-modifico-db']=false;
    if((pk_ud.tra_ope=='same2014'|| pk_ud.tra_ope=='ut2015'|| pk_ud.tra_ope=='ut2016' || pk_ud.tra_ope=='vcm2018') && pk_ud.tra_for=='S1' && pk_ud.tra_mat==''){
        var idboton='boton_I1__'+String(rta_ud.var_cr_num_miembro);
        if(document.getElementById(idboton)){
            habilitar_boton(idboton); 
            seleccionar_miembro(true); // solo controla
        }
    }
    /*
    if(pk_ud.tra_ope=='eah2018' && pk_ud.tra_for=='S1' && pk_ud.tra_mat=='P'){
        var pk_ud_I1_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'I1', tra_mat:'', tra_mie:pk_ud.tra_mie, tra_exm:0}));
        var rta_ud_I1_json=localStorage.getItem("ud_"+pk_ud_I1_json);
        var rta_ud_I1=rta_ud_I1_json?JSON.parse(rta_ud_I1_json):{};
        var idboton='boton_MD__'+String(pk_ud.tra_mie);
        if(document.getElementById(idboton)){
            if(rta_ud_I1.var_pd==1){
                habilitar_boton(idboton); 
            }else{
                habilitar_boton(idboton, false); 
            }
        }
    }
    */
    if( pk_ud.tra_ope.substr(0,2)=='ut' && pk_ud.tra_for=='SUP' && pk_ud.tra_mat==''){
        var idboton='boton_I1__'+String(rta_ud.var_sut_cr_num_miembro);
        if(document.getElementById(idboton)){
            habilitar_boton(idboton); 
            seleccionar_miembro_sup(true); // solo controla
        }
    }
    
}
    
function boton_abre_formulario(parametros,renglon){
    var rta="<input type='button' value='"+((parametros.tra_mat=='X')?renglon:parametros.tra_mat||parametros.tra_for)+"'"
        +" style='background-color:"+color_estados_ud[ver_estado_ud(parametros)]+";' " 
//        +" title='"+JSON.stringify(parametros)+","+JSON.stringify(ver_estado_ud(parametros))+","+JSON.stringify(color_estados_ud[ver_estado_ud(parametros)])+"' " 
        +" onclick='abrir_formulario("+JSON.stringify(parametros)+");'"+
        (soy_un_ipad?' tabindex="-1" ')+
        " id='boton_"+parametros.tra_for+'_'+parametros.tra_mat+'_'+renglon+"'; "+((parametros.tra_for=='I1' && (operativo_actual=='same2014' ||  (operativo_actual.substr(0,2)=='ut' && parametros.tra_for!='SUP') ||  operativo_actual=='ut2016' || operativo_actual=='vcm2018'))?'disabled':'')+">";
    return rta;
}

function GuardarElFormulario(){
    if(modificado_ls){
        guardar_en_localStorage("ud_"+id_ud,JSON.stringify(rta_ud));
        modificado_ls=false;
        return !soy_un_ipad; // o sea si soy un ipad aviso que está sucio. 
    }
    return false;
}

var grabar_al_volver=true; // OJO por ahora mientras sepamos que no es un iPad y esté off line

function Grabando_antes_hacer(accion, fin_etapa){
// Si no es un iPad, primero graba y luego, si se pudo grabar, se corre "accion"
// Si es un iPad, NO GRABA y corre "accion"
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

function Mostrar_Clave_en_el_encabezado(pk_ud){
"use strict";
    rta_ud_tem=JSON.parse(localStorage.getItem("ud_"+JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}))));
    if (pk_ud.tra_for=='S1' && pk_ud.tra_mat==''){
        var elemento=elemento_existente('ley');
        elemento.className='confidencial_ley';
    }
    for(var campo in pk_vacia) if(iterable(campo,pk_vacia)){
        if(pk_vacia[campo]===0){
            var elemento=elemento_existente(cambiar_prefijo(campo,'tra_','mostrar_')); 
            var valor_pk=pk_ud[campo];
            elemento.textContent=valor_pk;
            if(valor_pk || campo=='tra_enc'){
                elemento.parentNode.style.visibility='visible';
            }else{
                elemento.parentNode.style.visibility='hidden';
            }
            
        }
    }              
    var agregado=document.createElement('DIV');    
    agregado.textContent=si_no_es_nulo(rta_ud_tem.copia_cnombre)+si_no_es_nulo(rta_ud_tem.copia_hn)+si_no_es_nulo(rta_ud_tem.copia_hp)+' '+si_no_es_nulo(rta_ud_tem.copia_hd);
    agregado.className='cabezal_matriz_otros';
    elemento_existente('cabezal_matriz').appendChild(agregado);
    var agregado=document.createElement('DIV');    
    agregado.textContent='Lote ' + si_no_es_nulo(rta_ud_tem.copia_lote);
    if(rta_ud_tem.copia_version_cuest){
        agregado.textContent+=' - versión '+rta_ud_tem.copia_version_cuest
    }
    agregado.className='cabezal_matriz_otros';
    elemento_existente('cabezal_matriz').appendChild(agregado);    
    
    if(pk_ud.tra_for=='I1'&&pk_ud.tra_mat==''){
        var pk_ut=cambiandole(pk_ud,{tra_for:'S1',tra_mat:'P'});
        var pk_ut=otras_rta[JSON.stringify(pk_ut)];
        var nombre='Nombre: '+pk_ut.var_nombre;
        var edad='Edad: '+pk_ut.var_edad;
        var sexo='Sexo: ';
        if(pk_ut.var_sexo==1){
            sexo=sexo+'varón (1)'
        }else if (pk_ut.var_sexo==2){
            sexo=sexo+'mujer (2)'
        }
        var agregado=document.createElement('DIV');
        agregado.textContent=nombre+' - '+edad+'  - '+sexo;
        agregado.className='cabezal_matriz_otros';
        elemento_existente('cabezal_matriz').appendChild(agregado);
        
    }
    var pk_ud_tem=cambiandole(pk_ud,{tra_for:'TEM', tra_hog:0, tra_mie:0, tra_mat:'', tra_exm:0});
    rta_ud_tem=otras_rta[JSON.stringify(pk_ud_tem)];
    var participacion=rta_ud_tem.copia_participacion;
    var agregado=document.createElement('DIV');
    agregado.textContent='Participación: '+participacion;
    agregado.className='cabezal_matriz_otros';
    elemento_existente('cabezal_matriz').appendChild(agregado);
}


function meta_reemplazo_variables(pk_ud){
    var elementos=document.querySelectorAll(".meta_reem");
    for(var i=0; i<elementos.length; i++){
        var elemento=elementos[i];
        meta_reemplazo_elemento(pk_ud, elemento);
    }
}

function DesplegarVariableFormulario(de_este_php){
"use strict";
    // Fer: QUITO: tarea_de_etapa=JSON.parse(localStorage['ud_tarea_de_etapa']);
    // Fer: QUITO: solo_lectura=JSON.parse(localStorage['ud_solo_lectura']);
    if(soy_un_ipad){
        elemento_existente('div_principal').style['-webkit-user-select']='none';
    }
    var la_pk_jsoneada=traer_de_sessionStorage("pk_ud_navegacion");
    pk_ud=JSON.parse(la_pk_jsoneada||'{}');
    var vacio_para_despliegue=!pk_ud.tra_enc;
    pk_ud=cambiandole(pk_ud,de_este_php);
   // console.log("***variable_encuestas_js ", JSON.stringify(de_este_php)+  ' la pk '+ JSON.stringify(pk_ud));
    document.body.style.backgroundColor=color_fondo[pk_ud.tra_for];
    if(vacio_para_despliegue){
        cabezal_matriz.style.display='none';
    }else{
        document.title=(pk_ud.tra_mie?pk_ud.tra_mie+':':'')+
            (pk_ud.tra_exm?pk_ud.tra_exm+'x':'')+
            (Number(pk_ud.tra_hog)>1?'h'+pk_ud.tra_hog+'/':'')+
            pk_ud.tra_enc+' '+ 
            pk_ud.tra_for+(pk_ud.tra_mat?'.'+pk_ud.tra_mat:'')+' '+
            pk_ud.tra_ope; 
        Llenar_rta_ud(pk_ud.tra_for,pk_ud.tra_mat);
        Mostrar_Clave_en_el_encabezado(pk_ud);
    }
    if(localStorage['pk_encuesta_puede_borrar']==pk_ud.tra_enc){
        if(matriz==''){
            var boton_borrar = document.createElement('input');
            boton_borrar.type='button';
            boton_borrar.value='Borrar '+formulario;
            boton_borrar.onclick='Borrar_Formulario({encuesta:'+pk_ud.tra_enc+',nhogar:'+pk_ud.tra_hog+',miembro:'+pk_ud.miembro+',formulario:"'+formulario+'", matriz:"", volver:true});';
            var elemento=elemento_existente('mostrar_enc');
            elemento.appendChild(boton_borrar);
        }
    }
    if(!vacio_para_despliegue){ 
        meta_reemplazo_variables(pk_ud);
    }
    var elemento_para_grilla=document.getElementById('var_p5b');
    if(elemento_para_grilla && pk_ud.tra_mat=='P'){
        var datos_personas=obtener_datos_personas_y_norea(operativo_actual,pk_ud.tra_enc,pk_ud.tra_hog);
        armar_mini_grilla_personas_y_norea(datos_personas,elemento_para_grilla,'miembros del hogar');
    }
    //en ut: boton_formulario_especial
    var boton_formulario_especial = document.getElementById('boton_formulario_especial');
    // en eder:grilla_boton
    var botones_variables_especiales=document.querySelectorAll('[grilla_boton]');
    var cond_ut=(operativo_actual=='ut2015' && rta_ud_tem.copia_version_cuest==2)||(operativo_actual=='ut2016' && rta_ud_tem.copia_version_cuest==1);
    var cond_eder=operativo_actual=='eder2017';
    var arr_botones=[];
    if (cond_ut){
        arr_botones.push(boton_formulario_especial);  
    }else if(cond_eder){
        botones_variables_especiales.forEach(function(boton){arr_botones.push(boton);})
    };
    arr_botones.forEach(function(boton){
        if(cond_ut||cond_eder){
            boton.onclick=function(){
                if (operativo_actual.substring(0,2)=='ut') {
                    abrir_formulario(cambiandole(pk_ud,{tra_for:'I1'}),'grilla-ut')
                }else{
                    var grilla_boton_info=boton.getAttribute("grilla_boton");             
                    abrir_formulario(cambiandole(pk_ud,{tra_for:'I1'}),'grilla-eder',grilla_boton_info)
                }    
            }
            boton.disabled=false;
        }else{
            boton.disabled=true;
        }   
    })
    
/*

if(boton_formulario_especial || botones_variables_especiales){
            if((operativo_actual=='ut2015' && rta_ud_tem.copia_version_cuest==2)||(operativo_actual=='ut2016' && rta_ud_tem.copia_version_cuest==1)||(operativo_actual=='eder2017')){
                
                boton_formulario_especial.onclick=function(){
                    if (operativo_actual.substring(0,2)=='ut') {
                        abrir_formulario(cambiandole(pk_ud,{tra_for:'I1'}),'grilla-ut')
                    }else{
                    
                        
                    
                        var grilla_boton_info=document.getElementById('boton_formulario_especial').getAttribute("grilla_boton")
                        if(grilla_boton_info){
                            grilla_boton_info=JSON.parse(boton_formulario_especial.getAttribute("grilla_boton"));
                        }
                        
                        abrir_formulario(cambiandole(pk_ud,{tra_for:'I1'}),'grilla-eder')
                    }    
                }
                boton_formulario_especial.disabled=false;
            }else{
                boton_formulario_especial.disabled=true;
            }
        }

*/    
    
    
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

/*
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
*/
var IMAGEN_LOADING="<img src='../imagenes/mini_loading.gif'>";
var IMAGEN_ERROR="<img src='../imagenes/mini_Error.png'>";

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
    /*if(preguntas_ud[id_variable].saltar_a_boton){
        if(evaluar_en_encuestas(preguntas_ud[id_variable].expresion_saltar_a_boton)){
            proximo=preguntas_ud[id_variable].saltar_a_boton;
        }
    }*/
    if(proximo){
        elemento_existente(proximo).focus();
        evento.preventDefault();
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

/*
function enter_va_a(proximo_elemento,evento){
    if(evento.which==13){ // Enter
        proximo_elemento.focus();
        event.preventDefault();
    }
}
function enter_va_a_elemento(proximo_elemento,evento){
    if(evento.which==13){ // Enter
        document.getElementById(proximo_elemento).focus();
        event.preventDefault(); 
    }  
}
*/

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

// funciones nuevas de AJUS

function grabar_si_es_necesario_o_seguir(forzar_modificado_db){
    var todo_ok=true;
    var vfecha_hora=fecha_amd_hora_hms() ;     
    if(modificado_ls){
        guardar_en_localStorage("ud_"+id_ud,JSON.stringify(rta_ud));
        modificado_ls=false;
        if(nombres_de_miembros){
            guardar_en_localStorage("miembros_"+pk_ud.tra_enc+'_'+pk_ud.tra_hog,JSON.stringify(nombres_de_miembros));
        }
    }
    if((forzar_modificado_db || modificado_db) && !soy_un_ipad){
        enviar_paquete({
            proceso:'grabar_ud',
            paquete:{pk_ud:pk_ud, rta_ud:rta_ud, estados_rta_ud:estados_rta_ud, tra_fecha_hora:vfecha_hora},
            cuando_ok:function(){
                modificado_db=false;
                // OJO: FALTA CERRAR LA PANTALLA
            },
            cuando_error:function(mensaje){
                todo_ok=false;
                alert('No se pudo grabar. La base de datos informa:\n'+mensaje);
            },
            // usar_fondo_de:boton_que_lo_llama,
            mostrar_tilde_confirmacion:true
        });
    }
    return todo_ok;
}

function grabar_y_salir(){
    if(grabar_si_es_necesario_o_seguir()){
    if(/OS 7/i.test(navigator.userAgent) || /OS 8/i.test(navigator.userAgent) || /OS 9/i.test(navigator.userAgent) || /OS [1-9][0-9]/i.test(navigator.userAgent)){
            var pk_nuevo_ud={tra_ope:pk_ud.tra_ope, tra_for:pk_ud.tra_for, tra_mat:''};
            if((pk_ud.tra_for=='S1' || pk_ud.tra_for=='SUP') && pk_ud.tra_mat==''){
                ir_a_url(location.pathname+'?hacer=formularios_de_la_vivienda');
                return;
            }else if(pk_ud.tra_mat==''){
                pk_nuevo_ud.tra_for='S1';
            }
            ir_a_url(location.pathname+'?hacer=desplegar_formulario&todo='+JSON.stringify(pk_nuevo_ud));
        }else{
            history.go(-1);
        }
    }
}

function abrir_formulario(parte_pk, ruta_especial,parametro_especial){
    if(grabar_si_es_necesario_o_seguir()){
        var pk_ud_navegacion=cambiandole(pk_ud,parte_pk,true,null);
        for(var campo in pk_vacia) if(iterable(campo,pk_vacia)){
            var valor_nulo=pk_vacia[campo];
            if(valor_nulo===0){ // si es caracter el valor nulo es '' 
                pk_ud_navegacion[campo]=parseInt(pk_ud_navegacion[campo]);
            }
        }
        guardar_en_sessionStorage("pk_ud_navegacion",JSON.stringify(pk_ud_navegacion));
        var ruta;
        if(ruta_especial){
            var partes=location.pathname.split('/');
            partes.pop();
            partes.pop();
            ruta=partes.join('/');
            if (operativo_actual.substring(0,2)=='ut') {
                ruta+="/node/grilla-ut/grilla-ut.html?";
            }else if (operativo_actual=='eder2017'){
                ruta+="/node/grilla-eder/grilla-eder.html?";
            }
        }else{
            ruta=location.pathname+"?hacer=desplegar_formulario&";
        }
        var parametros={
            'tra_ope':parte_pk.tra_ope,
            'tra_for':parte_pk.tra_for,
            'tra_mat':parte_pk.tra_mat
        }
        if(parametro_especial){
            parametros['tra_especial']=parametro_especial;
        }
        ir_a_url(ruta+"todo="+JSON.stringify(parametros));
    }
}

function boton_abrir_formulario(){
    abrir_formulario(obtener_arreglo_asociativo_con_valores_de_elementos(pk_nombres));
}

function pasar_uds_leidas_a_localStorage_y_sacarlas_del_voy_por(datos){
    if(datos.estado && datos.estado.uds_enc){
        pasar_uds_leidas_a_localStorage(datos.estado.uds_enc);
        datos.estado.uds_enc=[];
    }
    if(datos.hoja_de_ruta){
        guardar_en_localStorage("hoja_de_ruta", JSON.stringify(datos.hoja_de_ruta));
    }
}

function pasar_uds_leidas_a_localStorage(datos){
    for(var i in datos) if(datos.hasOwnProperty(i)){
        var dato=datos[i];
        if(dato.claves_de){
            guardar_en_localStorage('claves_de_'+dato.claves_de,JSON.stringify(dato.formularios));
        }else if(dato.info_de){
            guardar_en_localStorage('info_de_'+dato.info_de,JSON.stringify(dato.info));
        }/*else if(dato.datos_tem){
            guardar_en_localStorage('datos_tem_'+dato.datos_tem,JSON.stringify(dato.varios));
        }*/else{
            var pk_ud_aux=dato.pk_ud;
            rta_ud=dato.rta_ud;
            var ud_ud_id='ud_'+JSON.stringify(pk_ud_aux);
            guardar_en_localStorage(ud_ud_id,JSON.stringify(rta_ud));
            if(!pk_ud){
                pk_ud=pk_ud_aux;
            }
            if(pk_ud.tra_ope!=operativo_actual && pk_ud_aux.tra_ope==operativo_actual){
                pk_ud=pk_ud_aux;
            }
            if(pk_ud.tra_ope!='S1' && pk_ud_aux.tra_ope==operativo_actual && pk_ud_aux.tra_ope=='S1'){
                pk_ud=pk_ud_aux;
            }
        }
    }
}

function leer_encuesta(params){
    var ok=false;
    controlar_parametros(params,{
        pk_ud:null,
        numero_control:null,
        usar_fondo_de:{validar:es_elemento}
    });
    enviar_paquete({
        proceso:'leer_encuesta_a_localStorage',
        paquete:params.pk_ud,
        cuando_ok:function(datos){
            pasar_uds_leidas_a_localStorage(datos);
            var elemento_rta=elemento_existente('proceso_encuesta_respuesta');
            elemento_rta.textContent='metí en el localStorage '+JSON.stringify(datos).length;
            ok=true;
        },
        cuando_error:function(mensaje){
            alert('no pude abrir la encuesta por: '+mensaje);
        },
        usar_fondo_de:params.usar_fondo_de
    });
    return ok;
}
function leer_formulario(params){
    controlar_parametros(params,{
        pk_ud:null,
        usar_fondo_de:{validar:es_elemento}
    });
    enviar_paquete({
        proceso:'leer_formulario_a_localStorage',
        paquete:params.pk_ud,
        cuando_ok:function(datos){
            pk_ud=datos.pk_ud;
            rta_ud=datos.rta_ud;
            var ud_ud_id='ud_'+JSON.stringify(pk_ud);
            guardar_en_localStorage(ud_ud_id,JSON.stringify(rta_ud));
            var elemento_rta=elemento_existente('proceso_formulario_respuesta');
            elemento_rta.textContent='metí en el localStorage '+JSON.stringify(datos).length;
        },
        cuando_error:function(mensaje){
            alert('no pude abrir el formulario por: '+mensaje);
        },
        usar_fondo_de:params.usar_fondo_de
    });
}

function boton_leer_formulario(){
    leer_formulario({
        pk_ud:obtener_arreglo_asociativo_con_valores_de_elementos(pk_nombres),
        usar_fondo_de:elemento_existente('boton_leer_formulario')
    });
}

function boton_leer_encuesta(){
    leer_encuesta({
        pk_ud:obtener_arreglo_asociativo_con_valores_de_elementos(['tra_ope','tra_enc','tra_numero_control']),
        usar_fondo_de:elemento_existente('boton_leer_encuesta')
    });
}

function boton_ingresar_encuesta(yendo_luego_al_formulario){
    if(leer_encuesta({
        pk_ud:{tra_ope:elemento_existente('tra_ope').value, tra_enc:parseInt(elemento_existente('tra_enc').value), tra_numero_control:parseInt(elemento_existente('tra_hn').value)},
        usar_fondo_de:elemento_existente('boton_ingresar_encuesta')
    })){
        if(yendo_luego_al_formulario){
            abrir_formulario(cambiandole(pk_vacia,{tra_ope:pk_ud.tra_ope, tra_for:(yendo_luego_al_formulario), tra_enc:pk_ud.tra_enc, tra_hog:1}));
        }else{
            guardar_en_sessionStorage("pk_ud_navegacion",JSON.stringify(cambiandole(pk_vacia,{tra_ope:pk_ud.tra_ope, tra_enc:pk_ud.tra_enc, tra_hog:1})));
            ir_a_url(location.pathname+"?hacer=formularios_de_la_vivienda");
        }
    }
}

function boton_ingresar_tem(){
    boton_ingresar_encuesta('TEM');
}

function hacer_backup_encuesta(){
    var elemento_disparador=this;
    elemento_disparador.style.color='#0044FF';
    elemento_disparador.textContent='pr';
    var pk_tem=JSON.parse(elemento_disparador.datos_pk);
    var hoja_de_ruta=JSON.parse(localStorage['hoja_de_ruta']);
    setTimeout(function(){
        var claves_jsoneadas=JSON.parse(localStorage.getItem('claves_de_'+pk_tem.tra_enc));
        var paquete={
            paq_enc:pk_tem.tra_enc,
            paq_momento:new Date(),
            paq_hdr:hoja_de_ruta,
            paq_uds:{},
        };
        for(var clave_json in claves_jsoneadas) if(iterable(clave_json,claves_jsoneadas)){
            paquete.paq_uds[clave_json]=JSON.parse(localStorage['ud_'+clave_json]);
        }
        elemento_disparador.textContent='cr';
        setTimeout(function(){
            var datos_a_enviar=CryptoJS.AES.encrypt(JSON.stringify(paquete),'JSON.stringify(-1)').toString();
            elemento_disparador.textContent='tx';
            enviar_paquete({
                // destino:'http://10.32.3.145/sieh2014/registro.php',
                destino:'https://www.estadisticaciudad.gob.ar/sieh2014/registro.php',
                preprocesar_paquete:parametros_via_url,
                postprocesar_paquete:false,
                paquete:{
                    usuario:'dmovil',
                    clave:'durrutia2014',
                    numero:pk_tem.tra_enc,
                    insalacion:-1,
                    dispositivo:'P.'+hoja_de_ruta.sufijo_rol+':'+hoja_de_ruta.per,
                    agente:hoja_de_ruta.per,
                    grupo:'F '+hoja_de_ruta.fecha_carga_enc,
                    observaciones:datos_a_enviar
                },
                cuando_ok:function(mensaje){
                    elemento_disparador.textContent='ok';
                    elemento_disparador.style.color='#22CC00';
                    var hoja_de_ruta=JSON.parse(localStorage['hoja_de_ruta']);
                    hoja_de_ruta.encuestas[pk_tem.tra_enc].ultimo_backup=new Date();
                    localStorage.setItem('hoja_de_ruta',JSON.stringify(hoja_de_ruta));
                    elemento_disparador.title=mensaje;
                    if(elemento_backup_total){
                        elemento_backup_total.textContent=elemento_backup_total.textContent?haciendo_backup_de.length:'';
                    }
                    hacer_backup_en_cadena();
                },
                cuando_error:function(mensaje){
                    elemento_disparador.textContent='E!';
                    elemento_disparador.style.color='#FF3333';
                    elemento_disparador.title=mensaje;
                    if(elemento_backup_total){
                        elemento_backup_total.style.color='red';
                    }
                    hacer_backup_en_cadena();
                },
                usar_fondo_de:elemento_disparador,
                mostrar_tilde_confirmacion:true,
                asincronico:true
            });
        },0);
    },0);
}

var elemento_backup_total=null;

var haciendo_backup_de=[];

function hacer_backup_en_cadena(inmediato){
    if(haciendo_backup_de.length>0){
        var elemento_backupeador=haciendo_backup_de.pop();
        setTimeout(function(){
            hacer_backup_encuesta.call(elemento_backupeador);
        },inmediato?0:500);
    }
}

function desplegar_hoja_de_ruta_uvi(){
"use strict";
    var carga_incompleta=false;
    var elementos_de_encuestas_modificadas=[];
    log_pantalla_principal('por conectar los eventos');
    if(window.applicationCache) window.applicationCache.addEventListener('updateready', function(e) {
        if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {
            window.applicationCache.swapCache();
            if (confirm('Se va a actualizar la página porque hubo un cambio offline ¿procedo?')) {
                window.location.reload();
            }
        }
    }, false);
    if(window.applicationCache) window.applicationCache.addEventListener('error', function(e) {
        if(window.applicationCache.status!=1){
            var texto=document.createElement('div');
            texto.textContent='procediendo';
            div_principal2.appendChild(texto);
        }
    }, false);
    if(localStorage["hoja_de_ruta"]){
        var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
        log_pantalla_principal('Desjotasonee hoja_de_ruta ');
        var elemento=elemento_existente('mostrar_carga');
        try{
            var fecha=new Date(hoja_de_ruta['fecha_carga_'+hoja_de_ruta.sufijo_rol]);
            if(fecha){
                elemento.textContent=fecha.getDate()+'/'+(Number(fecha.getMonth())+1);
            }
        }catch(err){
            elemento.textContent=hoja_de_ruta['fecha_carga_'+hoja_de_ruta.sufijo_rol];
        }
        elemento=elemento_existente('nombre_rol_hdr');
        elemento.textContent=hoja_de_ruta.rol;
        elemento=elemento_existente('mostrar_encuestador');
        elemento.textContent=hoja_de_ruta.per;
        log_pantalla_principal('por poner el botón de copia de seguridad');
        var boton_backup=document.createElement("button");
        boton_backup.textContent="Copia de Seguridad";
        boton_backup.onclick=copia_de_seguridad;
        boton_backup.id='boton_backup';
        /* Ya no vamos a hacer copias internas vía notepad
        div_principal2.appendChild(boton_backup);
        */
        var elemento_tabla=document.createElement("table");
        elemento_tabla.className='hdr_tabla';
        var elemento_fila=elemento_tabla.insertRow(-1);
        var elemento_celda;
        var agregar_celda=function(texto,clase){
            elemento_celda=elemento_fila.insertCell(-1);
            elemento_celda.textContent=texto;
            elemento_celda.className=clase;
            return elemento_celda;
        }
        agregar_celda('','');
        /*
        agregar_celda('calle','hdr_titulo');
        agregar_celda('numero','hdr_titulo');
        agregar_celda('piso','hdr_titulo');
        agregar_celda('dto','hdr_titulo');
        agregar_celda('varios','hdr_titulo');
        */
        agregar_celda('domicilio','hdr_titulo');
        agregar_celda('área','hdr_titulo');
        agregar_celda('sem','hdr_titulo');
        agregar_celda('part','hdr_titulo');
        agregar_celda('p','hdr_titulo');
        agregar_celda('c.s.','hdr_titulo');
        log_pantalla_principal('armando la tabla');
        var fecha=new Date();
        var fecha_actual=formatearFecha(fecha);        
        var semanas_existentes=[];
        var vuelta=0;
        for(var i in hoja_de_ruta.encuestas) if(iterable(i,hoja_de_ruta.encuestas)){
            total_encuestas_ipad++;
            log_pantalla_principal('poniendo los datos de la encuesta '+i);
            elemento_fila=elemento_tabla.insertRow(-1);
            var fila_encuesta=hoja_de_ruta.encuestas[i];
            elemento_celda=elemento_fila.insertCell(-1);            
            var pk_tem=JSON.stringify({tra_ope:operativo_actual,tra_for:'TEM',tra_mat:'',tra_enc:Number(fila_encuesta.encuesta),tra_hog:0,tra_mie:0,tra_exm:0});
            var datos_json_tem=localStorage.getItem("ud_"+pk_tem);
            if(datos_json_tem){
                rta_tem=JSON.parse(localStorage.getItem("ud_"+pk_tem));               
            }
            var sem_semana_referencia_hasta=semanas[rta_tem.copia_semana].sem_semana_referencia_hasta;//2014-07-05
            var es_sem_repetida=false;
            for (var i in semanas_existentes) if(iterable(i,semanas_existentes)){
                if(semanas_existentes[i]==rta_tem.copia_semana){
                    es_sem_repetida=true;                  
                }
            }
            if (!es_sem_repetida){
                semanas_existentes[vuelta]=rta_tem.copia_semana;
                //alert (vuelta+' '+semanas_existentes[vuelta]);
                vuelta++;
                
            }
            var desactivar_boton=fecha_actual<sem_semana_referencia_hasta;
            var elemento_boton=document.createElement('input');
            elemento_boton.type='button';
            elemento_boton.value=fila_encuesta.encuesta;
            elemento_boton.setAttribute('nuestro_encuesta',fila_encuesta.encuesta);
            elemento_boton.disabled=desactivar_boton;
            elemento_boton.onclick=function(){
                var tra_enc=parseInt(this.getAttribute('nuestro_encuesta'),10);
                guardar_en_sessionStorage("pk_ud_navegacion",JSON.stringify(cambiandole(pk_vacia,{tra_ope:operativo_actual, tra_enc:tra_enc})));
                ir_a_url(location.pathname+"?hacer=formularios_de_la_vivienda");
            }
            var hay_for = new Array();
            hay_for['S1']=false;
            hay_for['S1_P']=false;
            hay_for['A1']=false;
            hay_for['I1']=false;
            var estado_de_esta_ud;
            var pase=false;
            var todos_los_estados_de_esta_encuesta = new Array();
            var estado_encuesta="primera_vez";
            var claves_de_las_encuestas=localStorage.getItem("claves_de_"+fila_encuesta.encuesta);
            log_pantalla_principal('buscando datos dentro de las pk '+claves_de_las_encuestas);
            var pk_enc=JSON.parse(claves_de_las_encuestas); 
            if(claves_de_las_encuestas){
                for(var pk_cada_ud_json in pk_enc) if(iterable(pk_cada_ud_json,pk_enc)){
                    var pk_cada_ud=JSON.parse(pk_cada_ud_json);
                    if(pk_cada_ud.tra_for!='TEM' && pk_cada_ud.tra_ope==operativo_actual){ // OJO generalizar y falta tener en cuenta los hogares NOREA
                        if(pk_cada_ud.tra_for=='S1' && pk_cada_ud.tra_mat==''){
                            hay_for['S1']=true;
                        }
                        if(pk_cada_ud.tra_for=='S1' && pk_cada_ud.tra_mat=='P'){
                            hay_for['S1_P']=true;
                        }
                        if(pk_cada_ud.tra_for=='A1'){
                            hay_for['A1']=true;
                        }
                        if(pk_cada_ud.tra_for=='I1'){
                            hay_for['I1']=true;
                        }
                        estado_de_esta_ud=ver_estado_ud(pk_cada_ud);
                        todos_los_estados_de_esta_encuesta.push(estado_de_esta_ud); 
                    }
                }
            }
            log_pantalla_principal('revisando los estados');
            if (in_array('completa_norea', todos_los_estados_de_esta_encuesta)){
                estado_encuesta='completa_norea';
            } else if (hay_for['S1']&&hay_for['S1_P']&&hay_for['A1']&&hay_for['I1']) /*else if (hay_for['S1']&&hay_for['S1_P']&&(hay_for['A1']||/ut(\d)+/.test((operativo_actual)))&&hay_for['I1'])*/{
                    estado_encuesta='completa_ok';
                    if (in_array('incompleta', todos_los_estados_de_esta_encuesta)){
                        estado_encuesta='incompleta';
                    } else if (in_array('vacia', todos_los_estados_de_esta_encuesta)){
                        estado_encuesta='incompleta';                
                    } else if (in_array('completa_con_error', todos_los_estados_de_esta_encuesta)){
                        estado_encuesta='completa_con_error';                
                    } 
            } else if (!hay_for['S1']&&!hay_for['A1']){
                estado_encuesta='vacia';
            } else {
                estado_encuesta='incompleta';
            }
            var rta_tem;
            var pk_tem;
            log_pantalla_principal('agregando las celdas');
            //ojo generalizar tra_ope
            pk_tem=JSON.stringify({tra_ope:operativo_actual,tra_for:'TEM',tra_mat:'',tra_enc:fila_encuesta.encuesta,tra_hog:0,tra_mie:0,tra_exm:0});
            var datos_json_tem=localStorage.getItem("ud_"+pk_tem);
            log_pantalla_principal('JSON de la TEM '+datos_json_tem);
            if(datos_json_tem){
                rta_tem=JSON.parse(localStorage.getItem("ud_"+pk_tem));               
                elemento_boton.style.background=color_estados_ud[estado_encuesta];
                elemento_boton.title=estado_encuesta;
                elemento_celda.appendChild(elemento_boton);
                log_pantalla_principal('agregando celdas a la fila');
                var completo_edificio=(rta_tem.copia_ident_edif!=null && rta_tem.copia_edificio==null)?' '+rta_tem.copia_ident_edif:'';
               // agregar_celda(fila_encuesta.domicilio+' Edif. '+si_no_es_nulo(rta_tem.copia_ident_edif),'hdr_celda'); //ident_edif lo reemplazaron por sector-edificio-entradar
                agregar_celda(fila_encuesta.domicilio+' Edif. ' +si_no_es_nulo(rta_tem.copia_sector)+si_no_es_nulo(rta_tem.copia_edificio)+si_no_es_nulo(rta_tem.copia_entrada)+ completo_edificio,'hdr_celda');
                agregar_celda(rta_tem.copia_lote,'hdr_celda hdr_area');
                agregar_celda(rta_tem.copia_semana,'hdr_celda');
                agregar_celda(rta_tem.copia_participacion,'hdr_celda');
                agregar_celda(periodicidad(rta_tem.copia_rotaci_n_etoi,rta_tem.copia_dominio),'hdr_celda');
                var ver1=(fila_encuesta.ultimo_backup||"0");
                var ver2=fila_encuesta.ultima_modificacion>=(fila_encuesta.ultimo_backup||"0");
                var estado_backup=fila_encuesta.ultima_modificacion>=(fila_encuesta.ultimo_backup||"0")?'m':(fila_encuesta.ultimo_backup?'r':'');
                var elemento_backup=agregar_celda(estado_backup,'hdr_celda');
                elemento_backup.datos_pk=pk_tem;
                elemento_backup.onclick=hacer_backup_encuesta; 
                if(estado_backup!='r' && estado_backup!==''){
                    elementos_de_encuestas_modificadas.push(elemento_backup);
                }
                //desde aca agregado para probar observaciones en hoja de ruta ipad
                var obs_ant='';
                if(rta_tem.copia_participacion >1){
                  var info_ope=JSON.parse(localStorage.getItem("info_de_"+fila_encuesta.encuesta));
                  var pk_S1_ant=JSON.stringify({tra_ope:info_ope.operativo_anterior,tra_for:'S1',tra_mat:'',tra_enc:fila_encuesta.encuesta,tra_hog:1,tra_mie:0,tra_exm:0});
                  var rta_S1_ant=JSON.parse(localStorage.getItem("ud_"+pk_S1_ant));
                  var pk_S1_otrant=rta_tem.copia_participacion>=3?JSON.stringify(cambiandole(pk_S1_ant,{tra_ope:info_ope.operativo_anterior_anterior,tra_for:'S1',tra_mat:'',tra_enc:fila_encuesta.encuesta,tra_hog:1,tra_mie:0,tra_exm:0})):'';
                  var rta_S1_otrant=pk_S1_otrant==''?'':JSON.parse(localStorage.getItem("ud_"+pk_S1_otrant));
                  obs_ant=info_ope.operativo_anterior+': '+si_no_es_nulo(rta_S1_ant.var_s1a1_obs)+' '+info_ope.operativo_anterior_anterior+': '+si_no_es_nulo(rta_S1_otrant.var_s1a1_obs);
                }
                var elemento_fila=elemento_tabla.insertRow(-1);
                agregar_celda('','');
                agregar_celda(obs_ant?'Obs: '+ obs_ant:'','hdr_observaciones');
                elemento_celda.colSpan=6;
                //hasta aqui agregado obs hoja ruta de ipad
            }else{
                carga_incompleta=true;
            }
        }
        if(carga_incompleta){
            var texto=document.createElement('div');
            texto.textContent='carga incompleta';
            texto.className='mensaje_error';
            elemento_existente('div_principal2').appendChild(texto);
        }else{
            elemento_existente('div_principal2').appendChild(elemento_tabla);
            //pie de tabla con cantidad de encuestas ipad
            var elemento_tabla_pie=document.createElement("table");
            elemento_tabla_pie.className='pie_tabla';
            var elemento_fila=elemento_tabla.insertRow(-1);
            var elemento_celda;
            var agregar_celda=function(texto,clase){
                elemento_celda=elemento_fila.insertCell(-1);
                elemento_celda.textContent=texto;
                elemento_celda.className=clase;
                return elemento_celda;
            }
            agregar_celda('','pie_titulo');
            agregar_celda('Total de encuestas: '+total_encuestas_ipad,'pie_titulo');
            agregar_celda('','pie_titulo');
            agregar_celda('','pie_titulo');
            agregar_celda(elementos_de_encuestas_modificadas.length?'s/r:':'','pie_titulo');
            elemento_backup_total=agregar_celda(elementos_de_encuestas_modificadas.length||'','hdr_celda');
            if(elementos_de_encuestas_modificadas.length>0){
                elemento_backup_total.style.color='red';
                elemento_backup_total.style.fontFamily='Arial';
                elemento_backup_total.style.fontWeight='bold';
                elemento_backup_total.onclick=function(){
                    elemento_backup_total.style.color='blue';
                    elemento_backup_total.style.backgroundColor='#44CCCC';
                    haciendo_backup_de=elementos_de_encuestas_modificadas;
                    hacer_backup_en_cadena(true);
                }
            }
            elemento_backup_total
            //pie de tabla con cantidad de encuestas ipad
            var elemento_tabla_vacio=document.createElement("table");
            elemento_tabla_vacio.className='sem_vacia';
            var elemento_fila=elemento_tabla_vacio.insertRow(-1);
            agregar_celda(' ','pie_vacio');
            agregar_celda(' ','pie_vacio');
            agregar_celda(' ','pie_vacio');
            agregar_celda(' ','pie_vacio');
            agregar_celda(' ','pie_vacio');
            elemento_existente('div_principal2').appendChild(elemento_tabla_vacio);
            if("muestra semanas"){ // OJO GENERALIZAR SEMANA_MOSTRAR
                var elemento_tabla_sem=document.createElement("table");
                elemento_tabla_sem.className='sem_tabla';
                var elemento_fila=elemento_tabla_sem.insertRow(-1);
                agregar_celda('Sem','tit_semana');
                agregar_celda('Desde','tit_semana');
                agregar_celda('Hasta','tit_semana');
                agregar_celda('30 días desde','tit_semana');
                agregar_celda('30 días hasta','tit_semana');
                agregar_celda('Mes referencia','tit_semana');
                
                for (var i in semanas_existentes) if(iterable(i,semanas_existentes)){
                    var elemento_fila=elemento_tabla_sem.insertRow(-1);            
                    agregar_celda(semanas_existentes[i],'datos_semana');
                    var sem_desde=fecha_referencia(semanas[semanas_existentes[i]].sem_semana_referencia_desde);
                    var sem_hasta=fecha_referencia(semanas[semanas_existentes[i]].sem_semana_referencia_hasta);
                    var sem_30_desde=fecha_referencia(semanas[semanas_existentes[i]].sem_30dias_referencia_desde);
                    var sem_30_hasta=fecha_referencia(semanas[semanas_existentes[i]].sem_30dias_referencia_hasta);
                    var sem_mes_ref=mes_referencia(semanas[semanas_existentes[i]].sem_mes_referencia);                
                    agregar_celda(sem_desde,'datos_semana');
                    agregar_celda(sem_hasta,'datos_semana');
                    agregar_celda(sem_30_desde,'datos_semana');
                    agregar_celda(sem_30_hasta,'datos_semana');
                    agregar_celda(sem_mes_ref,'datos_semana');
                    elemento_existente('div_principal2').appendChild(elemento_tabla_sem);
                }
            }
        }
    }else{
        var texto=document.createElement('div');
        texto.textContent='Sin encuestas';
        mostrar_como_cachea();
    }
}

function desplegar_installing(){
    var div=document.createElement('div');
    elemento_existente('div_principal2').append(div);
    div.innerHTML=`
        <div id=instalando>
            <h2>instalando...</h2>
            <div id=error-console></div>
            <div id=archivos style="max-height:70%; overflow-y:scroll;"></div>
            <button id=arrancar style="display:none">Instalación Lista. Empezar</button>
        </div>
        <div id=consolex style="background-color:#AAA; font-size:80%;"></div>
    `
}

function vaciar_principal2(){
    var div2 = document.getElementById('div_principal2')
    if(div2 == null){
        div2 = document.createElement('div');
        div2.id='div_principal2';
    }
    div2.innerHTML=`
        <div id=nueva-version-detectada style="display:none">Nueva versión detectada <button id=actualizar>Instalar</button></div>
        <div id=buscando-version style="display:none">Buscando una nueva versión</div>
        <div id=console style="background-color:#AAA; font-size:80%; overflow-y:scroll; max-height:100px"></div>
    `;
    div_principal.appendChild(div2);
    return div2;
}

function console_log(message, obj, id){
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(message));
    if(obj!=null){
        if(obj instanceof Error){
            div.appendChild(document.createTextNode(obj.message));
            div.style.color='red';
        }else{
            div.appendChild(document.createTextNode(JSON.stringify(obj)));
        }
    }
    (document.getElementById(id||'console')||document.getElementById('console')).appendChild(div);
}

function desplegar_hoja_de_ruta(){
    vaciar_principal2();
    window.addEventListener('error', function myErrorHandler(error, url, lineNumber) {
        console_log('¡! '+(url||'')+':'+(lineNumber||''), error.message, 'error-console');
    });
    var swa = new ServiceWorkerAdmin();
    swa.installIfIsNotInstalled({
        onEachFile: (url, error)=>{
            console_log('file: ',url);
            console_log(url, error, 'archivos')
        },
        onInfoMessage: (m)=>console_log('message: ', m),
        onError: (err, context)=>{
            console_log('error: '+(context?` en (${context})`:''), err);
            console_log(context, err, 'error-console')
        },
        onJustInstalled:async (run)=>{
            document.getElementById('arrancar').style.display='';
            document.getElementById('arrancar').onclick=()=>{
                run()
            }
        },
        onReadyToStart:(installing)=>{
            vaciar_principal2();
            if(installing){
                desplegar_installing();
            }else{
                desplegar_hoja_de_ruta_uvi(); // uvi = una vez instalada
                var hdr_version = document.getElementById('hdr_version');
                hdr_version.onclick=()=>{
                    swa.check4newVersion();
                    document.getElementById('buscando-version').style.display='';
                    setTimeout(()=>{ document.getElementById('buscando-version').style.display='none' }, 3000);
                }
            }
        },
        onNewVersionAvailable:(install)=>{
            document.getElementById('nueva-version-detectada').style.display='';
            document.getElementById('buscando-version').style.display='none';
            document.getElementById('actualizar').onclick=()=>{
                install();
            }
        }
    })
}

function Grillita(nombre_contenedor,encuesta){
    this.elemento_tabla=document.createElement("table");
    this.elemento_tabla.id = 'tabla_'+nombre_contenedor;
    this.elemento_tabla.className = 'editor_tabla';
    this.maximo = 0;
    this.columnas_visibles={fecha:true, hora:true, anotacion:true};
    this.despliegue = function(tabla_visitas){
        elemento_existente(nombre_contenedor).innerHTML="";
        var elemento_fila; //=this.elemento_tabla.insertRow(-1);
        var elemento_caption = this.elemento_tabla.createCaption();
        elemento_caption.className = 'tabla_titulos';
        elemento_caption.textContent = 'Visitas';
        elemento_fila=this.elemento_tabla.insertRow(-1);
        elemento_fila.className = 'tabla_titulos';
        for(var nombre_columna in this.columnas_visibles)if(iterable(nombre_columna,this.columnas_visibles)){
            var elemento_celda = elemento_fila.insertCell(-1);
            // elemento_celda.colSpan=9;
            elemento_celda.textContent = nombre_columna;
            elemento_celda.className = 'celda_comun';
        }
        for(var row in tabla_visitas) if(iterable(row,tabla_visitas)){
            this.agregar_fila(tabla_visitas[row], this.elemento_tabla, row, false);
        }
        elemento_existente(nombre_contenedor).appendChild(this.elemento_tabla);
        var boton_agregar=document.createElement("input");
        boton_agregar.value= "agregar renglón a Visitas";
        boton_agregar.type="button";
        boton_agregar.onclick=this.agregar_renglon;
        //boton_agregar.setAttribute('enc',encuesta);
        boton_agregar.setAttribute('ultimorenglon',row);
        boton_agregar.la_tabla=this.elemento_tabla;
        boton_agregar.el_objeto_grilla=this;
        elemento_existente(nombre_contenedor).appendChild(boton_agregar);
    }
    this.agregar_renglon=function(){
        var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
        var ult_num_renglon=this.getAttribute('ultimorenglon');
        var num_renglon=Number(ult_num_renglon)+1;
        var ultimo_renglon_existente=hoja_de_ruta.encuestas[encuesta].visitas[ult_num_renglon];
        hoja_de_ruta.encuestas[encuesta].visitas[num_renglon]=
            cambiandole(ultimo_renglon_existente,{
                fecha:'',
                hora:'',
                anoenc:num_renglon,
                anotacion:''
            });
        this.el_objeto_grilla.agregar_fila(
            hoja_de_ruta.encuestas[encuesta].visitas[num_renglon],
            this.la_tabla,
            num_renglon
        );
        this.setAttribute('ultimorenglon',num_renglon);
        guardar_en_localStorage("hoja_de_ruta",JSON.stringify(hoja_de_ruta));
    }
    this.agregar_fila = function(fila_de_tabla_visitas, elemento_tabla, indice){
        var elemento_fila=elemento_tabla.insertRow(-1);
        elemento_fila.id = indice;
        for(var column in fila_de_tabla_visitas) if(iterable(column,fila_de_tabla_visitas)) if(this.columnas_visibles[column]){
            if(column){
                var clase_accesoria='';
                var elemento_celda=elemento_fila.insertCell(-1);
                // elemento_celda.colSpan=9;
                elemento_celda.className='celda_tabla_grillita';
                var elemento_input=document.createElement("input");
                elemento_input.id=nombre_contenedor+'_'+indice+'_'+column;
                clase_accesoria = 'celda_input_grillita_'+column;
                elemento_input.className='celda_input_grillita'+' '+clase_accesoria;
                elemento_input.onblur = this.guardar; 
                elemento_input.setAttribute('campo',column);
                elemento_input.setAttribute('renglon',indice);
                //elemento_input.title=elemento_input.id;
                //OJO:se necesita un origen de datos para saber a que campo pertenece el tipo numerico
                if(soy_un_ipad && (column == 'fecha' || column == 'hora')){
                    elemento_input.type = 'tel';
                }
                elemento_input.value=fila_de_tabla_visitas[column];
                elemento_celda.appendChild(elemento_input);
            }
        }
    }
    this.guardar = function(evt){
        var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
        var num_renglon=this.getAttribute('renglon');
        var campo=this.getAttribute('campo');
        hoja_de_ruta.encuestas[encuesta].visitas[num_renglon][campo]=this.value;
        guardar_en_localStorage("hoja_de_ruta", JSON.stringify(hoja_de_ruta));
    }
}


function desplegar_visitas_de_la_vivienda(){
"use strict";
    pk_ud=JSON.parse(traer_de_sessionStorage("pk_ud_navegacion"));
    var json_hoja_de_ruta=localStorage["hoja_de_ruta"];
    if(json_hoja_de_ruta){
        var hoja_de_ruta=JSON.parse(json_hoja_de_ruta);
        if(hoja_de_ruta.encuestas.hasOwnProperty(pk_ud.tra_enc)){
            var visitas = hoja_de_ruta.encuestas[pk_ud.tra_enc].visitas;
            var grilla_visitas = new Grillita('grilla_visitas',pk_ud.tra_enc);
            if(visitas){
                grilla_visitas.despliegue(visitas);
            }
        }
    }
    if(!soy_un_ipad){
        var nombre_grilla = 'anoenc';
        var editor=editores[nombre_grilla]=new Editor(nombre_grilla,nombre_grilla,{anoenc_ope:pk_ud.tra_ope, anoenc_enc:pk_ud.tra_enc});
        elemento_existente('div_principal').appendChild(editor.obtener_el_contenedor_dom());
        editor.cargar_grilla(document.body,false);
    }        
    if(tiene_rol_subcoor_campo || tiene_rol_recepcionista || tiene_rol_procesamiento){
        setTimeout(function(){ 
            var div_aviso=document.createElement('div');
            div_aviso.textContent='cargando resultados de la supervisión ';
            var ruedita=document.createElement('img');
            ruedita.src='../imagenes/mini_loading.gif';
            div_aviso.appendChild(ruedita);
            document.body.appendChild(div_aviso);
            var nombre_grilla = 'verificador_supervision';
            var editor=editores[nombre_grilla]=new Editor(nombre_grilla,nombre_grilla,{vis_enc:pk_ud.tra_enc});
            elemento_existente('div_principal').appendChild(editor.obtener_el_contenedor_dom());
            editor.cargar_grilla(document.body,false, function(){ div_aviso.style.display='none'; }); 
        },100);
    }    
}

function cartel_sinohay_inconsistencias_r2(){
 var elem_tab_r2=document.getElementById('tabla_inconsistencias_R2');
 var elem_filas_r2=elem_tab_r2.getElementsByTagName('tr');
 var cant=elem_filas_r2.length-1;
 var elem_celda_cartel=document.getElementById('cartel_r2_ok');
 elem_celda_cartel.textContent= (cant==0)?': no se detectaron inconsistencias para controlar':''; 
};

function correr_consistencias_relevamiento_2( fcallback ){
"use strict";
    var pk_ud_antes_de_empezar=pk_ud; 
    for(var json_pk_ud_actual in JSON.parse(localStorage.getItem("claves_de_"+pk_ud.tra_enc))){
        var pk_ud_actual=JSON.parse(json_pk_ud_actual);
        if(pk_ud_actual.tra_for!='TEM' && pk_ud_actual.tra_ope==operativo_actual){ // OJO GENERALIZAR
            pk_ud=pk_ud_actual;
            Llenar_rta_ud(pk_ud.tra_for,pk_ud.tra_mat,'invisible=true');
            // alert('Vi el estado del botón '+localStorage.getItem("estado_ud_"+JSON.stringify(pk_ud_actual))+' pk: '+JSON.stringify(pk_ud_actual));
        }
    }
    fcallback && fcallback();  
}

function desplegar_formularios_de_la_vivienda(){
"use strict";
    var elemento_boton_fin={};
    pk_ud=JSON.parse(traer_de_sessionStorage("pk_ud_navegacion"));
    document.title=pk_ud.tra_enc+' formularios de la encuesta '+operativo_actual;
    log_pantalla_principal('desjotasoneado el pk_ud');
    var ver_que_pk_tengo;
    var que_obtuve;
    var sin_parse;
    var clave;
    rta_ud_tem=JSON.parse(sin_parse=localStorage.getItem(clave="ud_"+JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}))));
    if(es_un_recepcionista && rta_ud_tem.var_estado>=40 && rta_ud_tem.var_estado<60 && (rta_ud_tem.var_sup_dirigida||rta_ud_tem.var_sup_aleat)==4){
        para_supervisor=true;
    }
    var elemento=elemento_existente('mostrar_enc');
    elemento.textContent=pk_ud.tra_enc;    
    var elemento2=elemento_existente('direccion');
    var st_hab= si_no_es_nulo(rta_ud_tem.copia_hab)? (' hab: '+ rta_ud_tem.copia_hab):'';
    elemento2.textContent=si_no_es_nulo(rta_ud_tem.copia_cnombre)+si_no_es_nulo(rta_ud_tem.copia_hn)+si_no_es_nulo(rta_ud_tem.copia_hp)+' '+si_no_es_nulo(rta_ud_tem.copia_hd) + st_hab ;
    var elemento3=elemento_existente('lote');    
    elemento3.textContent='Lote ' + si_no_es_nulo(rta_ud_tem.copia_lote);
    var elemento4=elemento_existente('participacion');    
    elemento4.textContent=' - Participación ' + si_no_es_nulo(rta_ud_tem.copia_participacion);
    var elemento5=elemento_existente('ident_edif'); //el elemento edificio no está definido en document por eso se sigue usando ident_edif
    var det_edificio=(rta_ud_tem.copia_ident_edif!=null && rta_ud_tem.copia_edificio==null)?' '+rta_ud_tem.copia_ident_edif:''
    elemento5.textContent=' - Edif. ' +si_no_es_nulo(rta_ud_tem.copia_sector)+si_no_es_nulo(rta_ud_tem.copia_edificio)+si_no_es_nulo(rta_ud_tem.copia_entrada)+det_edificio;
    var elemento6=elemento_existente('periodicidad');
    elemento6.textContent=' - Per. ' + si_no_es_nulo(periodicidad(rta_ud_tem.copia_rotaci_n_etoi,rta_ud_tem.copia_dominio));
    log_pantalla_principal('puesto el encabezado');
    var claves=JSON.parse(localStorage['claves_de_'+pk_ud.tra_enc]);
    log_pantalla_principal('desplegando la tabla principal '+JSON.stringify(tabla_armar_principal));
    var pk_ud_S1_hog1_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_hog:1, tra_mie:0, tra_exm:0}));
    var rta_ud_S1_hog1_json=localStorage.getItem("ud_"+pk_ud_S1_hog1_json);
    var rta_ud_S1_hog1=rta_ud_S1_hog1_json?JSON.parse(rta_ud_S1_hog1_json):{};
    var pk_ud_A1_hog1_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'A1', tra_mat:'', tra_hog:1, tra_mie:0, tra_exm:0}));
    var rta_ud_A1_hog1_json=localStorage.getItem("ud_"+pk_ud_A1_hog1_json);
    var rta_ud_A1_hog1=rta_ud_A1_hog1_json?JSON.parse(rta_ud_A1_hog1_json):{};    
    var total_hog_declarados=(rta_ud_S1_hog1||{}).var_total_h||1;

    log_pantalla_principal('desjotasoneada la clave');
    var tabla={
        "1":{
            "S1":{
                "1":{
                    json_clave:JSON.stringify(cambiandole(pk_ud,{tra_for:"S1",tra_hog:1})),
                    leyenda:"nuevo"
                }
            }
        }
    };
    for(var json_clave in claves) if(iterable(json_clave,claves)){
        var clave=JSON.parse(json_clave);
        if(clave.tra_ope==pk_ud.tra_ope && clave.tra_hog && clave.tra_mat==''){
            log_pantalla_principal('preparando botones de '+json_clave);
            if(tabla[clave.tra_hog]==undefined){
                tabla[clave.tra_hog]={};
            }
            if(tabla[clave.tra_hog][clave.tra_for]==undefined){
                tabla[clave.tra_hog][clave.tra_for]={};
            }
            var datos_formulario=estructura.otros_datos_formulario[clave.tra_for];
            var ultimo_campo_pk='tra_'+datos_formulario.matrices[''].ultimo_campo_pk;
            tabla[clave.tra_hog][clave.tra_for][clave[ultimo_campo_pk]]={
                leyenda:'abrir'+(ultimo_campo_pk=='tra_hog'?'':' '+datos_formulario.matrices[''].ultimo_campo_pk+clave[ultimo_campo_pk]), 
                json_clave:json_clave
            };
        }
    }
    var maximo_hogar_encontrado=0;
    var tabla_armar_principal={};
    log_pantalla_principal('armando la tabla principal');
    for(var hogar in tabla){
        if(Number(hogar)>maximo_hogar_encontrado){
            maximo_hogar_encontrado=Number(hogar);
        }
        for(var formulario in estructura.otros_datos_formulario){
            var datos_formulario=estructura.otros_datos_formulario[formulario];
            if(datos_formulario.es_principal){
                tabla_armar_principal[hogar]={};
            }
        }
        for(var formulario in estructura.otros_datos_formulario) if(formulario!='TEM'){
            var datos_formulario=estructura.otros_datos_formulario[formulario];
            var ultimo_campo_pk=datos_formulario.matrices[''].ultimo_campo_pk;                                    
            if (rta_ud_tem.var_rea==0 || rta_ud_tem.var_rea==2){
                var es_norea=true;
            }else{
                var es_norea=false;
            } 
    //        console.log('especial ',datos_formulario.es_especial);            
            if (puede_ver_todos_los_formularios || 
               (!es_ing_sup && !para_supervisor && !datos_formulario.tarea ||
               !es_ing_sup && para_supervisor && (datos_formulario.tarea || es_norea) 
               || (datos_formulario.tarea && es_ing_sup) //para que pueda ingresar el rol sup_ing los formularios de SUP
               )&& !datos_formulario.es_especial
            ){  
                if(tabla_armar_principal[hogar][formulario]==undefined){
                    tabla_armar_principal[hogar][formulario]={};
                }
                if(tabla[hogar][formulario]){
                    for(var cual in tabla[hogar][formulario]){
                        tabla_armar_principal[hogar][formulario][cual]=tabla[hogar][formulario][cual];
                    }
                }else if(ultimo_campo_pk=='hog'){
                    if(formulario!='PG1'){ //GENERALIZAR. Entiendo que esta condición debe ser siempre FALSE para cualquier cuestionario, no tengo tiempo de probarlo lo suficiente
                        if(formulario!='SUP' || (formulario=='SUP'&& !puede_ver_todos_los_formularios)||
                           (formulario=='SUP'&& puede_ver_todos_los_formularios && ( rta_ud_tem.var_estado==65 || (rta_ud_tem.var_estado>=40 && rta_ud_tem.var_estado<60) )   /*&& (rta_ud_tem.var_sup_dirigida||rta_ud_tem.var_sup_aleat)==4 */)){
                            tabla_armar_principal[hogar][formulario][ultimo_campo_pk=='hog'?hogar:1]={leyenda:'nuevo', json_clave:null};
                        }  
                    }
                }
            }
        }
    }
    for(var numero_hogar_faltante=maximo_hogar_encontrado; numero_hogar_faltante<total_hog_declarados; numero_hogar_faltante++){
        numero_hogar_faltante++;
        var pk_ud_S_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_hog:numero_hogar_faltante, tra_mie:0, tra_exm:0}));
        tabla_armar_principal[numero_hogar_faltante]={};
        tabla_armar_principal[numero_hogar_faltante]['S1']={}
        tabla_armar_principal[numero_hogar_faltante]['S1'][numero_hogar_faltante]={leyenda:'nuevo', json_clave:null};
    }
    tabla = tabla_armar_principal;
    var elemento_tabla=document.createElement("table");
    var datos_personas_y_visitas=[];
    for(var hogar in tabla){
        var elemento_fila=elemento_tabla.insertRow(-1);
        var elemento_celda=elemento_fila.insertCell(-1);
        elemento_celda.colSpan=9;
        elemento_celda.textContent='Hogar '+hogar;
        elemento_celda.className='fdlv_fila_hogar';
        var datos_personas_y_visitas_un_hogar=obtener_datos_personas_y_norea(operativo_anterior,pk_ud.tra_enc, Number(hogar))
        if(datos_personas_y_visitas_un_hogar){
            datos_personas_y_visitas.push(datos_personas_y_visitas_un_hogar);
        }
        for(var formulario in tabla[hogar]){
            for(var cual in tabla[hogar][formulario]){
                log_pantalla_principal('Por mostrar '+hogar+':'+formulario);
                elemento_fila=elemento_tabla.insertRow(-1);
                elemento_fila.className='fdlv_fila_formulario';
                elemento_celda=elemento_fila.insertCell(-1);
                var elemento_boton=document.createElement('input');
                elemento_boton.type='button';
                elemento_boton.value=formulario;
                var pk_destino;
                pk_destino=JSON.stringify(cambiandole(pk_ud,{tra_hog:Number(hogar),tra_for:formulario,tra_mat:''}));
                var destino_del_boton=tabla[hogar][formulario][cual].json_clave||pk_destino;
                elemento_boton.setAttribute('nuestro_destino',destino_del_boton);
                elemento_boton.onclick=function(){
                    var nueva_pk_ud=JSON.parse(this.getAttribute('nuestro_destino'));
                    abrir_formulario(nueva_pk_ud);
                }
                // coloreamos los botones según el estado:
                var json_estado_formulario=localStorage.getItem("estado_ud_"+destino_del_boton);
                if(json_estado_formulario){
                    log_pantalla_principal('json_estado_formulario '+json_estado_formulario);
                    var estado_formulario_del_boton=JSON.parse(json_estado_formulario).estado; //
                    log_pantalla_principal('pk_destino '+pk_destino);
                    if(estado_formulario_del_boton ==='completa_ok' && formulario ==='S1' && JSON.parse(pk_destino).tra_mat==="") {
                        var json_rta_ud=localStorage.getItem("ud_"+destino_del_boton);
                        log_pantalla_principal('json_rta_ud '+json_rta_ud);
                        if(json_rta_ud){
                            var entrea=JSON.parse(json_rta_ud).var_entrea;
                            if(entrea===2){
                                estado_formulario_del_boton='completa_norea';
                                guardar_en_localStorage("estado_ud_"+pk_destino,JSON.stringify({estado:estado_formulario_del_boton}));  
                            }
                        }
                    }
                    //estado_formulario_del_boton='completa' && Formulario='S1' mat='' preguntar estado varible var_entrea. si es 2 => 
                    // estado_formulario_del_boton=completa_norea
                    elemento_boton.title=estado_formulario_del_boton;
                    elemento_boton.style.backgroundColor=color_estados_ud[estado_formulario_del_boton];
                }
                log_pantalla_principal('por agregar el boton '+hogar+'+'+formulario+'+'+cual);
                if (formulario !=='GH' ||( formulario=='GH' &&( (operativo_actual.substr(0,4)=='etoi' && parseInt(operativo_actual.substr(4))>=162 && parseInt(operativo_actual.substr(4))<=172 ) || (operativo_actual.substr(0,3)=='eah' && anio_operativo=='2016' ) ) && rta_ud_tem.copia_dominio==3)){                
                    elemento_celda.appendChild(elemento_boton);
                    elemento_celda=elemento_fila.insertCell(-1);
                    elemento_celda.textContent=tabla[hogar][formulario][cual].leyenda;
                }    
                if (formulario==='S1'){
                // leer ud_pk_destino y rescatar var_total_m para informarlo al lado del boton
                    var json_rta_S1=localStorage.getItem("ud_"+pk_destino);
                    if(json_rta_S1){
                        var cant_miembros = JSON.parse(json_rta_S1).var_total_m;
                        if (cant_miembros){
                            elemento_celda=elemento_fila.insertCell(-1);
                            elemento_celda.textContent='Miembros: '+cant_miembros;
                        }
                    }
                }
            }            
        }
    }    
    if(pk_ud.tra_ope==operativo_actual){ // OJO: GENERALIZAR OPERATIVO
        var pk_ud_TEM_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0, tra_mie:0, tra_exm:0}));
        var datos_TEM=(
            otras_rta[pk_ud_TEM_json]||
            (otras_rta[pk_ud_TEM_json]=JSON.parse(localStorage.getItem("ud_"+pk_ud_TEM_json))) 
        );
        copia_ud.copia_participacion=datos_TEM.copia_participacion;
        copia_ud.copia_dominio=datos_TEM.copia_dominio;
    }
    if(datos_personas_y_visitas.length && copia_ud.copia_dominio!=4 && copia_ud.copia_dominio!=5){
        var boton_personas;
        boton_personas=document.createElement('input');
        boton_personas.type='button';
        boton_personas.value='+info';
        boton_personas.style.left='350px';
        boton_personas.style.position='relative';
        //boton_personas.title=JSON.stringify(datos_personas_y_visitas);
        boton_personas.onclick=function(){
            var donde=boton_personas;
            for(var i=0; i<datos_personas_y_visitas.length; i++){
                donde=armar_mini_grilla_personas_y_norea(datos_personas_y_visitas[i],donde,'participación anterior'+(i?' hogar '+(i+1):'')).vacio_abajo;
                boton_personas.disabled=true;
            }
        };
        elemento_existente('div_principal').appendChild(boton_personas);
        elemento_existente('div_principal').appendChild(document.createElement('br'));
    }
    if(para_supervisor){
        var div_supervision=document.createElement('div');
        div_supervision.className='datos_supervision';
        elemento_existente('div_principal').appendChild(div_supervision);
        var agregar_texto=function(texto){
            var div_texto=document.createElement('div');
            div_texto.textContent=texto;
            div_supervision.appendChild(div_texto);
        }   
        var codigoRea='';        
        if(rta_ud_tem.var_rea==0 || rta_ud_tem.var_rea==2){
            codigoRea='NO REA ' + rta_ud_tem.var_norea;        
        } else if (rta_ud_tem.var_rea==1 || rta_ud_tem.var_rea==3){
            codigoRea='REA';
        }
        var tipo_sup='';
        if(rta_ud_tem.var_sup_aleat==3){
            tipo_sup='aleatoria presencial';
        } else if (rta_ud_tem.var_sup_aleat==4){
            tipo_sup='aleatoria telefónica';
        } else if (rta_ud_tem.var_sup_dirigida==3){
            tipo_sup='dirigida presencial';
        } else if (rta_ud_tem.var_sup_dirigida==4){
            tipo_sup='dirigida telefónica';
        }        
        agregar_texto('Datos de relevamiento para supervisión');        
        agregar_texto('Tipo de supervisión: '+tipo_sup);
        agregar_texto('Codigo encuestador: '+si_no_es_nulo(rta_ud_tem.var_cod_enc));
        agregar_texto('Código recuperador: '+si_no_es_nulo(rta_ud_tem.var_cod_recu));
        agregar_texto('Estado encuesta: '+si_no_es_nulo(codigoRea));
        agregar_texto('Cantidad de hogares: '+si_no_es_nulo(rta_ud_tem.var_hog_tot));        
        agregar_texto('Respondente: '+si_no_es_nulo(rta_ud_S1_hog1.var_respond)+' '+si_no_es_nulo(rta_ud_S1_hog1.var_nombrer));        
        agregar_texto('Observaciones: '+si_no_es_nulo(rta_ud_S1_hog1.var_s1a1_obs));
        agregar_texto('Teléfono: '+si_no_es_nulo(rta_ud_A1_hog1.var_telefono)+si_no_es_nulo(rta_ud_S1_hog1.var_tel1));
        agregar_texto('Móvil: '+si_no_es_nulo(rta_ud_A1_hog1.var_movil)+si_no_es_nulo(rta_ud_S1_hog1.var_tel2));
        for (var i=2; i<=total_hog_declarados; i++ ){
            var pk_ud_S1_hog_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_hog:i, tra_mie:0, tra_exm:0}));
            var rta_ud_S1_hog_json=localStorage.getItem("ud_"+pk_ud_S1_hog_json);
            var el_s1=rta_ud_S1_hog_json?JSON.parse(rta_ud_S1_hog_json):{};
            var pk_ud_A1_hog_json=JSON.stringify(cambiandole(pk_ud,{tra_for:'A1', tra_mat:'', tra_hog:i, tra_mie:0, tra_exm:0}));
            var rta_ud_A1_hog_json=localStorage.getItem("ud_"+pk_ud_A1_hog_json);
            var el_a1=rta_ud_A1_hog_json?JSON.parse(rta_ud_A1_hog_json):{};
            var xresp_hogi='';
            var xtel_hogi='';
            if (el_s1){
              xresp_hogi='HOGAR '+i+' Respondente:'+si_no_es_nulo(el_s1.var_respond)+' '+si_no_es_nulo(el_s1.var_nombrer);
            }  
            if (el_a1){
              xtel_hogi=' | Teléfono: '+si_no_es_nulo(el_a1.var_telefono)+si_no_es_nulo(el_s1.var_tel1) + ' | Móvil:'+si_no_es_nulo(el_a1.var_movil)+si_no_es_nulo(el_s1.var_tel2);
            }
            agregar_texto(xresp_hogi+xtel_hogi);
        }
    }    
    elemento_existente('div_principal').appendChild(elemento_tabla);
    log_pantalla_principal('poniendo botones de inconsistencias');
    var nombre_grilla='inconsistencias';
    var elemento_boton=document.createElement('input');
    elemento_boton.type='button';
    elemento_boton.value='Controlar las consistencias de los formularios de esta encuesta';
    elemento_boton.id='boton_controlar_R2';
    elemento_boton.onclick=function(){
        correr_consistencias_relevamiento_2(cartel_sinohay_inconsistencias_r2);
        elemento_boton_fin.listo1=true;
    }
    elemento_existente('div_principal').appendChild(elemento_boton);
    // otro boton
    if(!soy_un_ipad){
        var elemento_br=document.createElement('br');
        elemento_existente('div_principal').appendChild(elemento_br);
        var editor=editores[nombre_grilla]=new Editor(nombre_grilla,nombre_grilla,{inc_enc:pk_ud.tra_enc});
        elemento_boton=document.createElement('input');
        elemento_boton.type='button';
        elemento_boton.value='Controlar el ingreso de los formularios de esta encuesta';
        elemento_boton.id='boton_controlar';        
        elemento_boton.onclick=function(){
            elemento_boton_fin.listo2=true;
            if(elemento_boton_fin.listo1){
                elemento_boton_fin.disabled=false;
            };
            proceso_formulario_boton_ejecutar('correr_consistencias','boton_controlar',{valores:{
                tra_ope:operativo_actual,
                tra_enc:pk_ud.tra_enc,
                tra_con:'#todo'
            }},null,null,false);
        
        /*
            enviar_paquete({
                proceso:'control_encuesta',
                paquete:{tra_ope:pk_ud.tra_ope, tra_enc:pk_ud.tra_enc},
                cuando_ok:function(respuesta){ 
                    elemento_existente('proceso_formulario_respuestas').textContent=respuesta;
                    editor.filtro_para_lectura.inc_con='#!=opc_inconsistente';
                    editor.cargar_grilla(elemento_boton,false); // filtrar por 
                    elemento_boton_fin.listo2=true;
                    if(elemento_boton_fin.listo1){
                        elemento_boton_fin.disabled=false;
                    }
                },
                usar_fondo_de:elemento_existente('boton_controlar')
            });
        */
        };
        elemento_existente('div_principal').appendChild(elemento_boton);
        var div_inconsistencias=document.createElement('div');
        div_inconsistencias.id='proceso_formulario_respuesta'; 
        elemento_existente('div_principal').appendChild(div_inconsistencias);
        // elemento_existente('div_principal').appendChild(editor.obtener_el_contenedor_dom());
        var sufijo=rta_ud_tem.var_rol=='recuperador'?'recu':'enc';
        if(rta_ud_tem["var_a_ingreso_"+sufijo]){
            if(!rta_ud_tem["var_fin_ingreso_"+sufijo]){
                elemento_boton_fin=document.createElement('input');
                elemento_boton_fin.type='button';
                elemento_boton_fin.value='Fin de ingreso';
                elemento_boton_fin.id='id_elemento_boton_fin';
                elemento_boton_fin.disabled=true;
                elemento_boton_fin.listo1=false;
                elemento_boton_fin.listo2=false;
                elemento_boton_fin.onclick=function(){
                    enviar_paquete({
                        proceso:"fin_de_ingreso",
                        paquete:{
                            tra_enc:pk_ud.tra_enc,
                            tra_rol:rta_ud_tem.var_rol
                        },    
                        cuando_ok:function(mensaje){
                            elemento_boton_fin.disabled=true;
                            elemento_boton_fin.value=mensaje;
                        },
                        usar_fondo_de:elemento_boton_fin,
                        mostrar_tilde_confirmacion:true
                    });
                }
                elemento_existente('div_principal').appendChild(elemento_boton_fin);
            }else{
                var elemento_aviso=document.createElement('input');
                elemento_aviso.type='button';
                elemento_aviso.value='ingreso finalizado';
                elemento_aviso.disabled=true;
                elemento_existente('div_principal').appendChild(elemento_aviso);
            }
        }
    }
    var elemento_respuestas=document.createElement('div');
    elemento_respuestas.id='proceso_formulario_respuestas';
    elemento_existente('div_principal').appendChild(elemento_respuestas);
    var elemento_consistencias_R2=document.createElement('table');
    elemento_consistencias_R2.id='tabla_inconsistencias_R2';
    var fila=elemento_consistencias_R2.insertRow(0);
    var celda=fila.insertCell(0);
    celda.textContent="Inconsistencias";
    celda.colSpan=9;
    var celda1=fila.insertCell(1);
    celda1.textContent='';
    celda1.id='cartel_r2_ok';
    elemento_existente('div_principal').appendChild(elemento_consistencias_R2);
    if (!para_supervisor){
      log_pantalla_principal('poniendo el botón de operaciones especiales');
      poner_boton_para_borrar_todos_los_formularios();
    }
}

function poner_boton_para_borrar_todos_los_formularios(){
"use strict";
    var boton_borrar=document.createElement('input');
    boton_borrar.value='Operaciones especiales';
    boton_borrar.type='button';
    boton_borrar.onclick=function(){
        // var div=elemento_existente('div_borrar');
        if(div_borrar.style.display=='none'){
            div_borrar.style.display='block';
        }else{
            div_borrar.style.display='none';
        }
    }
    elemento_existente('div_principal').appendChild(boton_borrar);
    var div_borrar=document.createElement('div');
    div_borrar.id='div_borrar';
    var texto1=document.createElement('span');
    texto1.textContent='Quiero ';
    div_borrar.appendChild(texto1);
    var cuadro_texto=document.createElement('input');
    cuadro_texto.id='operacion_especial';
    cuadro_texto.style.width='100px';
    div_borrar.appendChild(cuadro_texto);
    var texto2=document.createElement('span');
    texto2.textContent=' todos los formularios de la vivienda ';
    div_borrar.appendChild(texto2);
    var cuadro_texto2=document.createElement('input');
    cuadro_texto2.id='numero_encuesta';
    cuadro_texto2.style.width='100px';
    div_borrar.appendChild(cuadro_texto2);
    var boton_aceptar_borrar=document.createElement('input');
    boton_aceptar_borrar.value='Confirmar';
    boton_aceptar_borrar.type='button';
    boton_aceptar_borrar.onclick=function(){
        var operacion=operacion_especial.value;
        if(operacion.toLowerCase()!='borrar'){
            alert('No se conoce la operación '+operacion);
        }else if(numero_encuesta.value!=pk_ud.tra_enc){
            alert('No coincide el número de vivienda con '+pk_ud.tra_enc);
        }else{
            if(confirm('procedo a borrar')){
                borrar_todos_los_formularios(pk_ud.tra_enc);
            }
        }
    }
    div_borrar.style.display='none';
    div_borrar.appendChild(boton_aceptar_borrar);
    elemento_existente('div_principal').appendChild(div_borrar);
}

function borrar_todos_los_formularios(tra_enc){
    var claves_jsoneadas=JSON.parse(localStorage.getItem('claves_de_'+tra_enc));
    var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
    var formularios_borrados=JSON.parse(localStorage.getItem('formularios_borrados')||'[]');
    var clave_tem;
    var claves_nuevas={};
    for(var clave_json in claves_jsoneadas) if(iterable(clave_json,claves_jsoneadas)){
        var clave=JSON.parse(clave_json);
        if(clave.tra_for=='TEM'){
            // esta no se borra porque es la tem 
            clave_tem=clave_json; // me guardo la clave correspondiente a la TEM para restaurar "claves_de_"
            claves_nuevas[clave_tem]=true;
        }else if(clave.tra_ope==operativo_actual){ // OJO GENERALIZAR
            var ud_clave_a_borrar="ud_"+clave_json;
            if(clave.tra_for=='S1' && clave.tra_mat==''){
                localStorage.removeItem('miembros_'+clave.tra_enc+'_'+clave.tra_hog);
            }
            formularios_borrados.push({cuando:new Date(), clave:clave, datos:JSON.parse(localStorage.getItem(ud_clave_a_borrar))});
            localStorage.removeItem(ud_clave_a_borrar);
            localStorage.removeItem("estado_ud_"+clave_json);
        }else{
            claves_nuevas[clave_json]=true;
        }
    }
    guardar_en_localStorage("hoja_de_ruta", JSON.stringify(hoja_de_ruta));
    guardar_en_localStorage('claves_de_'+tra_enc,JSON.stringify(claves_nuevas));
    guardar_en_localStorage('formularios_borrados',JSON.stringify(formularios_borrados));
    ir_a_url(location.pathname+'?hacer=hoja_de_ruta');
}

function poner_como_primer_child(repositorio,nodo_a_agregar){
    var primer_child=repositorio.firstChild;
    if(primer_child){
        repositorio.insertBefore(nodo_a_agregar,primer_child);
    }else{
        repositorio.appendChild(nodo_a_agregar);
    }
}

function poner_como_segundo_child(repositorio,nodo_a_agregar){
    var segundo_child=repositorio.childNodes[2];
    if(segundo_child){
        repositorio.insertBefore(nodo_a_agregar,segundo_child);
    }else{
        repositorio.appendChild(nodo_a_agregar);
    }
}

function poner_cartel_advertencia_llamativa(mensaje){
    var texto=document.createElement('div');
    texto.textContent=mensaje;
    texto.className='mensaje_error_grave';
    poner_como_segundo_child(elemento_existente('div_principal'),texto);
}

function mostrar_advertencia_descargado(){
    if(localStorage.getItem('estado_carga')=='descargado'){
        poner_cartel_advertencia_llamativa('NO USAR. Las encuestas de este dispositivo ya fueron descargadas');
    }
    if(localStorage.getItem('estado_carga')=='descarga_parcial'){
        poner_cartel_advertencia_llamativa('ATENCIÓN. DESCARGA PARCIAL. DEBE TERMINAR DE DESCARGAR');
    }
    if(navigator.userAgent.match(/iPad; CPU OS 5/)){
        poner_cartel_advertencia_llamativa('ATENCIÓN. Versión del iOS 5.');
    }
    if(navigator.userAgent.match(/iPad/) && !navigator.standalone){
        poner_cartel_advertencia_llamativa('ATENCIÓN. Está usando el sistema desde el Safari. Debe usar el ícono en la pantalla de inicio');
    }
}

function cambiar_cache_offline(){
      if(window.applicationCache) window.applicationCache.swapCache();
      window.location.reload();
}
function buscar_rol(){
    if(localStorage["hoja_de_ruta"]){
        var hoja_de_ruta=JSON.parse(localStorage["hoja_de_ruta"]);
        var rol=hoja_de_ruta.rol=='supervisor'?3:(hoja_de_ruta.rol=='recuperador'?2:1);
        return rol;
    }
    return interpretarTrue(localStorage.getItem('para_supervisor'))?3:1;
}

function controlar_offline(){
    var fondo=elemento_existente('div_principal');
    var boton_log=document.createElement('button');
    boton_log.textContent=(localStorage.getItem('log_pantalla_principal')?'Apagar ':'Encender ')+'el log en la pantalla principal ';
    boton_log.onclick=function(){
        if(localStorage.getItem('log_pantalla_principal')){
            localStorage.removeItem('log_pantalla_principal');
            alert('apagado');
        }else{
            guardar_en_localStorage('log_pantalla_principal','si');
            alert('encendido');
        }
    }
    fondo.appendChild(boton_log);
    mostrar_status(fondo,'version_js_tedede', true);
    mostrar_status(fondo,'version_js_encuestas', true);
    mostrar_status(fondo,'window.applicationCache.status',true);
    mostrar_status(fondo,'navigator.onLine',true);
    mostrar_status(fondo,'soy_un_ipad',true);
    mostrar_status(fondo,'location.host',true);
    mostrar_status(fondo,'navigator.userAgent',true);
    mostrar_status(fondo,'location.href',true);
    mostrar_status(fondo,'Versión refrescada');
    var boton=document.createElement('button');
    boton.textContent='refrescar ahora la cache';
    boton.onclick=cambiar_cache_offline;
    fondo.appendChild(boton);
    var restaurador=document.createElement('textarea');
    restaurador.id='texto_backup';
    fondo.appendChild(restaurador);
    var boton=document.createElement('button');
    boton.textContent='Restaurar el backup';
    boton.onclick=function(){
        if(prompt('clave restauracion')==1248){
            texto_backup.value=restaurar_backup_carga(texto_backup.value);
        }
    }
    var div_url=document.createElement('div');
    div_url.style.border='1px solid gray';
    fondo.appendChild(div_url);
    var nueva_url=document.createElement('input');
    nueva_url.id='nueva_url_para_ir';
    nueva_url.style.minWidth='500px';
    nueva_url.value=location.pathname+location.search;
    div_url.appendChild(nueva_url);
    var boton_ir=document.createElement('button');
    boton_ir.textContent='ir';
    boton_ir.onclick=function(){
        location.href=nueva_url.value;
    }
    div_url.appendChild(boton_ir);
    var div2=document.createElement('div');
    fondo.appendChild(div2);
    var boton_js=document.createElement('button');
    boton_js.textContent='consola JS';
    boton_js.onclick=function(){
        location.href='../pruebas/ejemplo.html';
    }
    div2.appendChild(boton_js);
    /* ya no hay backup en el notepad
    fondo.appendChild(boton);
    */
}

var metadatos_backup={
    estado_carga:{
        tipo:"texto"
    },
    hoja_de_ruta:{
        encuestas:{
            claves_de_:{ 
                "":{ 
                    ud_:{ tipo:"texto"} 
                }
            }
        }
    }
};

function obtener_parte_de_la_carga(rta,indice_sufijo,pasos){
"use strict";
    for(var indice_prefijo in pasos) if(iterable(indice_prefijo,pasos)){
        var paso=pasos[indice_prefijo];
        var indice_ls=indice_prefijo+indice_sufijo;
        var datos=localStorage.getItem(indice_ls);
        rta[indice_ls]=datos;
        if(!paso.tipo){
            datos=JSON.parse(localStorage.getItem(indice_ls));
            for(var que_iterar in paso) if(iterable(que_iterar,paso)){
                var base_iteracion=que_iterar?datos[que_iterar]:datos;
                for(var nuevo_sufijo in base_iteracion) if(iterable(nuevo_sufijo,base_iteracion)){
                    obtener_parte_de_la_carga(rta,nuevo_sufijo,paso[que_iterar]);
                }
            }
        }
    }
}

function obtener_toda_la_carga(){
"use strict";
    var rta={};
    obtener_parte_de_la_carga(rta,'',metadatos_backup);
    return rta;
}

function copia_de_seguridad_preparar(){
    var hoja_de_ruta=JSON.parse(localStorage.getItem('hoja_de_ruta'));
    var contenido={
        fecha:new Date(), 
        per:hoja_de_ruta.per, 
        fecha_carga_enc:hoja_de_ruta.fecha_carga_enc,
        datos:obtener_toda_la_carga(),
        ok:version_js_encuestas
    }
    resultado_backup.textContent=JSON.stringify(contenido);
}

function restaurar_backup_carga(backup_json){
"use strict";
    var backup;
    try{
        backup=JSON.parse(backup_json);
    }catch(err){
        return 'El backup parece tener un formato inválido (no-JSON) '+err.description;
    }
    try{
        if(!backup.ok){
            return 'El backup está incompleto (sin señal ok)';
        }
        for(var clave in backup.datos) if(iterable(clave,backup.datos)){
            guardar_en_localStorage(clave,backup.datos[clave]);
        }    
    }catch(err){
        return 'Hubo un error restaurando el backup (en la clave '+clave+')';
    }
}

function copia_de_seguridad(){
"use strict";
    if(!(ele=document.getElementById("resultado_backup"))){ // QAcod if(=)
        var ele=document.createElement("div");
        ele.id="resultado_backup";
        div_principal.appendChild(ele);
    }
    ele.innerHTML="<img src='../imagenes/mini_loading.gif'>";
    setTimeout(copia_de_seguridad_preparar,100);
}

function SetPieRemito(event){
    //var tamano = document.body.clientHeight;
    var tamano = document.body.offsetHeight;
    var paginas = 0;
    var resto = 0;
            
    paginas = tamano / 1318;
    resto = tamano % 1318;
    paginas = Math.floor(paginas);
                        
    if((1338 - resto) > 75 ){
        paginas++;
    }
    var altura = (1318 * paginas) - 75;
    document.getElementById("PieDePagina").style.top = altura.toString() + "px";
    document.getElementById("PieDePagina").style.position="absolute";
    document.getElementsByTagName("html").style.zoom = 1;         
}

function ejecutar_claves_a_conciliar(){
"use strict";
    var columnas_sensibles={enc:1, hog:1, mie:1, exm:1};
    var cambios_en={}; // en qué columnas hubo cambios
    var total_en={}; // cuenta el total en cada columna
    var distintos_en_columna={};
    var registros=editores.claves_a_conciliar.datos.registros;
    mensajes_conciliar.textContent='';
    var mostrar_error=function(mensaje){
        mensajes_conciliar.textContent+=mensaje;
        mensajes_conciliar.style.backgroundColor='Orange';
    }
    var mostrar_ok=function(mensaje){
        mensajes_conciliar.textContent+=mensaje;
        mensajes_conciliar.style.backgroundColor='LightGreen';
    }
    for(var columna in columnas_sensibles) if(iterable(columna,columnas_sensibles)){
        distintos_en_columna[columna]={};
        for(var pk_registro in registros) if(iterable(pk_registro,registros)){
            var registro=registros[pk_registro];
            if(registro["vie_"+columna]!=registro["nue_"+columna]){
                cambios_en[columna]=(cambios_en[columna]||0)+1;
            }  
            total_en[columna]=(total_en[columna]||0)+1;
            if (registro["vie_"+columna]==0){
                total_en[columna]--;
            }
            distintos_en_columna[columna][registro["vie_"+columna]]=true;
        }
    }
    if(array_keys(cambios_en).length>1 && (array_keys(cambios_en).length>2 || cambios_en['hog']==0 || cambios_en['mie']==0)){
        mostrar_error('no se pueden hacer cambios en más de una columna a la vez');
    }else if(array_keys(cambios_en).length==0){
        mostrar_error('no hay cambios');
    // }else if(array_keys(distintos_en_columna["enc"]).length>1 && cambios_en['hog']>0){
    //    mostrar_error('no se puede cambiar el hogar si se abrieron dos encuestas');
    }else if(array_keys(distintos_en_columna["enc"]).length>1 && cambios_en['mie']>0){
        mostrar_error('no se puede cambiar los miembros si se abrieron dos encuestas');
    }else if(array_keys(distintos_en_columna["enc"]).length==1 && cambios_en['enc']>0){
        mostrar_error('no se puede cambiar el número de encuesta si se abre una sola');
    // }else if(cambios_en['hog']>0 && total_en['hog']!=cambios_en['hog']){
    //    mostrar_error('Debe cambiar todos los hogares para una encuesta, el cambio no puede ser parcial. ');    
    }else{
        enviar_paquete({
            proceso:'conciliar_claves_ejecutar',
            paquete:{tra_registros:registros},
            cuando_ok:mostrar_ok,
            cuando_error:mostrar_error,
            usar_fondo_de:boton_ejecutar_claves_a_conciliar,
            asincronico:true
        });
    }
}
function ejecutar_visitas_a_conciliar(){
"use strict";
    var primer_encuesta=sessionStorage.getItem('tra_enc');
    var segunda_encuesta=sessionStorage.getItem('tra_enc2');
    var columnas_sensibles={enc:1, anoenc:1};
    var cambios_en={}; // en qué columnas hubo cambios
    var total_en={}; // cuenta el total en cada columna
    var distintos_en_columna={};
    var encuesta_incorrecta=false;
    var registros=editores.visitas_a_conciliar.datos.registros;
    mensajes_conciliar_visitas.textContent='';
    var mostrar_error=function(mensaje){
        mensajes_conciliar_visitas.textContent+=mensaje;
        mensajes_conciliar_visitas.style.backgroundColor='Orange';
    }
    var mostrar_ok=function(mensaje){
        mensajes_conciliar_visitas.textContent+=mensaje;
        mensajes_conciliar_visitas.style.backgroundColor='LightGreen';
    }
    for(var columna in columnas_sensibles) if(iterable(columna,columnas_sensibles)){
        distintos_en_columna[columna]={};
        for(var pk_registro in registros) if(iterable(pk_registro,registros)){
            var registro=registros[pk_registro];
            if(registro["vie_"+columna]!=registro["nue_"+columna]){
                cambios_en[columna]=(cambios_en[columna]||0)+1;
                if(columna='enc'){
                    if(registro["nue_"+columna]!=primer_encuesta && registro["nue_"+columna]!=segunda_encuesta){
                        encuesta_incorrecta=true;
                    }
                }                
            }  
            total_en[columna]=(total_en[columna]||0)+1;
            if (registro["vie_"+columna]==0){
                total_en[columna]--;
            }
            distintos_en_columna[columna][registro["vie_"+columna]]=true;
        }
    }
    if(array_keys(cambios_en).length==0){
        mostrar_error('no hay cambios');
    }else if(array_keys(distintos_en_columna["enc"]).length==1 && cambios_en['enc']>0){
        mostrar_error('no se puede cambiar el número de encuesta si se abre una sola');
    }else if(cambios_en['enc']>0 && encuesta_incorrecta){
        mostrar_error('se cambió por un número de encuesta distinto de los ingresados al inicio');    
    }else{
        enviar_paquete({
            proceso:'conciliar_visitas_ejecutar',
            paquete:{tra_registros:registros},
            cuando_ok:mostrar_ok,
            cuando_error:mostrar_error,
            usar_fondo_de:boton_ejecutar_visitas_a_conciliar,
            asincronico:true
        });
    }
}
function formatearFecha(fecha){//devuelve formato string tipo 2014-04-02
    var mes =fecha.getMonth()+1;
    if (mes<10){
        mes='0'+mes;
    }
    var dia =fecha.getDate();
    if (dia<10){
        dia='0'+dia;
    }                
    return fecha.getFullYear()+'-'+mes+'-'+dia;        
}

function obtener_datos_personas_y_norea(operativo,encuesta,hogar){
    // vamos con los datos:
    var ud_s1=localStorage['ud_'+JSON.stringify({tra_ope:operativo,tra_for:'S1',tra_mat:'',tra_enc:encuesta,tra_hog:hogar,tra_mie:0,tra_exm:0})];    
    var datos={};
    if(ud_s1){ // o sea si hay datos de la visita anterior
        var ud_s1=JSON.parse(ud_s1);
        datos.s1=ud_s1;
        if(ud_s1.var_entrea!=1){
        }else{
            var num_per=0;
            datos.personas=[];
            datos.a1=[];
            while(num_per++<=30){
                var ud_p=localStorage['ud_'+JSON.stringify({tra_ope:operativo,tra_for:'S1',tra_mat:'P',tra_enc:encuesta,tra_hog:hogar,tra_mie:num_per,tra_exm:0})];             
                if(ud_p){
                    ud_p=JSON.parse(ud_p);
                    ud_p.num_per=num_per;
                    datos.personas.push(ud_p);
                }               
            }
            var ud_a1=localStorage['ud_'+JSON.stringify({tra_ope:operativo,tra_for:'A1',tra_mat:'',tra_enc:encuesta,tra_hog:hogar,tra_mie:0,tra_exm:0})];    
            
            if(ud_a1){              
                ud_a1=JSON.parse(ud_a1);
                datos.a1.push(ud_a1);
            }
        }
        return datos;
    }else{
        return false;
    }
}

function armar_mini_grilla_personas_y_norea(datos,elemento_cercano,mensaje){
    var div=document.createElement('div');
    div.className='mini_grilla';
    div.style.position='absolute';
    var left=obtener_left_global(elemento_cercano);
    var top=obtener_top_global(elemento_cercano);
    var nuevo_left=left+(elemento_cercano.offsetWidth||elemento_cercano.clientWidth)+8;
    div.style.left=nuevo_left+'px';
    div.style.top=top+'px';
    div.style.width=760-nuevo_left+'px';
    document.body.appendChild(div);
    var ud_s1=datos?datos.s1:false;
    if(ud_s1){ // o sea si hay datos de la visita anterior
        var tabla=document.createElement('table');
        div.appendChild(tabla);
        if(mensaje){
            var caption=document.createElement('caption');
            caption.textContent=mensaje;
            tabla.caption=caption;
        }
        var fila;
        var agregar_celda=function(dato,clase){
            var celda=fila.insertCell(-1);
            celda.className=clase||'mini_grilla';
            celda.textContent=dato;
            return celda;
        }
        if(ud_s1.var_entrea!=1){
            fila=tabla.insertRow(-1);
            agregar_celda('NOREA');
            agregar_celda(ud_s1.var_razon1+(ud_s1.var_razon2_1||ud_s1.var_razon2_2||ud_s1.var_razon2_3||ud_s1.var_razon2_4||ud_s1.var_razon2_5||ud_s1.var_razon2_6||ud_s1.var_razon2_7||ud_s1.var_razon2_8||ud_s1.var_razon2_9));
        }else{
            var fila=tabla.insertRow(-1);
            agregar_celda('N°','mini_grilla_titulo');
            agregar_celda('nombre','mini_grilla_titulo');
            agregar_celda('edad','mini_grilla_titulo');         
            for(var i_p in datos.personas) if(datos.personas.hasOwnProperty(i_p)){
                var ud_p=datos.personas[i_p];
                var num_per=ud_p.num_per;
                var fila=tabla.insertRow(-1);
                agregar_celda(num_per+(ud_s1.var_respond==num_per?'*':''));
                agregar_celda(ud_p.var_nombre);
                agregar_celda(ud_p.var_edad);               
            }
            var ud_a1=datos.a1[0];
            if(ud_a1){
                if(ud_a1.var_telefono){
                    fila=tabla.insertRow(-1);
                    var celda=agregar_celda('tel: '+ud_a1.var_telefono);    
                    celda.colSpan=3;
                }
                if(ud_a1.var_movil){
                    fila=tabla.insertRow(-1);
                    var celda=agregar_celda('móvil: '+ud_a1.var_movil); 
                    celda.colSpan=3;
                }
            }
        }
    }else{
        div.appendChild(document.createTextNode('--'));
    }
    var div_vacio_abajo=document.createElement('div');
    div.appendChild(div_vacio_abajo);
    var vacio_abajo=document.createElement('span');
    div_vacio_abajo.appendChild(vacio_abajo);
    // div_vacio_abajo.textContent='.';
    div.vacio_abajo=vacio_abajo;
    return div;
}