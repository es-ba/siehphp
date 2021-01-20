/* UTF-8:Sí
   compatibilidad.js
*/
"use strict";

var controles_de_compatibilidad={
// Mejorados siguiendo los consejos de http://fortuito.us/diveintohtml5/detect.html
    'soporte JSON':{gravedad:'incompatible'
    ,controlar:function(){
        return '["esto"]'==JSON.stringify(['esto']);
    }},
    'soporte para cookies':{gravedad:'incompatible'
    ,controlar:function(){
        return navigator.cookieEnabled;
    }},
    'almacenamiento local (localStorage)':{gravedad:'incompatible'
    ,controlar:function(){
        try {
            return 'localStorage' in window && window['localStorage'] !== null;
        }catch(e){
            return false;
        }
    }},
    'almacenamiento local por ventana (sessionStorage)':{gravedad:'incompatible'
    ,controlar:function(){
        sessionStorage.setItem('prueba_de_soporte_sessionStorage','soportado');
        return sessionStorage.getItem('prueba_de_soporte_sessionStorage')=='soportado';
    }},
    'almacenamiento de atributos internos (setAttribute)':{gravedad:'incompatible'
    ,controlar:function(parametros){
        parametros.div.setAttribute('prueba_attribute','soportado');
        return parametros.div.getAttribute('prueba_attribute')=='soportado';
    }},
    'posicionamiento inicial del cursor (autofocus HTML5)':{gravedad:'incomodidad'
    ,controlar:function(parametros){
        var input=document.createElement('input');
        return 'autofocus' in input;
    }},
    'movimiento lateral de teclas de cursor dentro de grillas (window.getSelection)':{gravedad:'incomodidad'
    ,controlar:function(parametros){
        return window.getSelection;
    }},
    /*
    'soporte para trabajo sin conexion (offline)':{gravedad:'incomodidad'
    ,controlar:function(parametros){
        return !!window.applicationCache;
    }},
    */
    'soporte para tratar eventos internos':{gravedad:'incompatible'
    ,controlar:function(parametros){
        return !!window.addEventListener;
    }},
    /*
    'soporte para procesos compartidos (SharedWorker)':{gravedad:'depende'
    ,controlar:function(parametros){
        return !!window.SharedWorker;
    }},
    */
    // ¡conexión Ajax debe ser el último de los controles!
    'conectividad Ajax':{gravedad:'incompatible'
    ,controlar:function(params){
    //var div2=elemento_existente('proceso_encuesta_respuesta');
    //div2.textContent="pap 1";
        var obtenido='nada_por_ahora';
        var java_inetaddr=((window.java||{}).net||{}).InetAddress||false;
        var parametrizar={
            control_compatibiliad_pre_login:'si',
            registro_incompatibilidad:params.div.textContent,
            LOCAL_ADDR:(java_inetaddr?java_inetaddr.getLocalHost().getHostAddress():false)||'desconocido'
        };
        var parametros="";
        for(var parametro in parametrizar){
            parametros+=parametro+'='+encodeURIComponent(parametrizar[parametro])+'&';
        }
        if(window.XMLHttpRequest){
            var peticion=new XMLHttpRequest();
            peticion.onreadystatechange=function(){
                switch(peticion.readyState) { 
                case 4: 
                    obtenido = peticion.responseText;
                }
            }
            peticion.open('POST', '../tedede/registrar.php', false); 
            peticion.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
            peticion.send(parametros);
        }else{
            window.location='../tedede/registrar.php?'+parametros+'html=1';
        }
        return typeof XMLHttpRequest != "undefined";
        return obtenido=='soportado';
    }}
};

function controlar_compatibilidad(nombre_div_compatibilidad){
"use strict";
    var div=elemento_existente(nombre_div_compatibilidad);
    var hubo_errores=false;
    var hubo_errores_tipo={};
    for(var control in controles_de_compatibilidad){
        //if(iterable(control,controles_de_compatibilidad)){
        //no uso la función iterable porque los navegadores viejos no la soportan entonces no se ve qué es lo que no se soporta.
            var ok=false;
            var def_control=controles_de_compatibilidad[control];
            try{
                ok=def_control.controlar({div:div});
            }catch(err){
            }
            if(!ok){
                var mensaje=document.createElement('div');
                mensaje.textContent="Falla en "+control;
                div.appendChild(mensaje);
                hubo_errores=true;
                hubo_errores_tipo[def_control.gravedad]=true;
            }
        //}
    };
    if(!hubo_errores_tipo['incompatible']){
        var boton=elemento_existente('boton_login');
        boton.value='Ingresar >>';
        boton.disabled=false;
        boton=elemento_existente('boton_sin_pass');
        boton.style.visibility='visible';
    }
    if(hubo_errores || !navigator.userAgent.match(/Chrome|Safari|iPad; CPU OS 6|iPad; CPU OS 7/)){
        div.innerHTML=div.innerHTML+"<br>El sistema no fue probado en este modelo de navegador. Si encuentra problemas durante el uso por favor avise que estaba usando un modelo no probado. Se recomienda usar una versión actualizada del navegador Google Chrome";
    }
}