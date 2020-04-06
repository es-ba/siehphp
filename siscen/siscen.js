function boton_grabar_nov(origen,accion){
"use strict";
    var todo_ok=true;
    enviar_paquete({
        proceso:'grabar_novedad_req',
        paquete:{
            tra_proy:elemento_existente('tra_proy').value, 
            tra_req:elemento_existente('tra_req').value, 
            tra_comentario:elemento_existente('tra_comentario').value, 
            tra_accion:accion,  
            tra_origen:origen,
        },        
        cuando_ok:function(datos){
            ir_a_url(location.pathname+"?hacer=agregar_novedades_req&todo="+JSON.stringify({
            'tra_proy':elemento_existente('tra_proy').value,
            'tra_req':elemento_existente('tra_req').value,            
        })+'&y_luego=buscar');
        },
        cuando_error:function(mensaje){            
        },        
        usar_fondo_de:elemento_existente(accion),
        mostrar_tilde_confirmacion:true
    });
}

function boton_agregar_novedad_req(proy,req){
"use strict";
    ir_a_url(location.pathname+"?hacer=agregar_novedades_req&todo="+JSON.stringify({
        'tra_proy':elemento_existente('tra_proy').value,
        'tra_req':elemento_existente('tra_req').value,            
    })+'&y_luego=buscar');
}

function habilitar_botones_req(idElementoEnFoco){
"use strict";
    var comentario=document.getElementById('tra_comentario');
    var prioridad=document.getElementById('tra_nuevo_prioridad');
    var plazo=document.getElementById('tra_nuevo_plazo');
    var costo=document.getElementById('tra_nuevo_costo');
    var valor_comentario=trim(comentario.value+(idElementoEnFoco=='tra_comentario'?'x':''));
    var valor_prioridad=trim(prioridad.value+(idElementoEnFoco=='tra_nuevo_prioridad'?'x':''));
    var valor_plazo=trim(prioridad.value+(idElementoEnFoco=='tra_nuevo_plazo'?'x':''));
    var valor_costo=trim(costo.value+(idElementoEnFoco=='tra_nuevo_costo'?'x':''));
    var array_botones = new Array(); 
    array_botones = document.getElementsByName('boton_flujo');
    var comentario_activo=valor_comentario.length>0;
    var prioridad_activa=!comentario_activo && valor_prioridad.length>0;
    var plazo_activo=!comentario_activo && valor_plazo.length>0;
    var costo_activo=!comentario_activo && !prioridad_activa && valor_costo.length>0;
    for(var j=0;j<array_botones.length;j++){
        document.getElementsByName('boton_flujo').item(j).disabled=prioridad_activa || costo_activo;
    }
    comentario.disabled=prioridad_activa || costo_activo || plazo_activo;
    cambiar_prioridad.disabled=comentario_activo || costo_activo || plazo_activo;
    prioridad.disabled=comentario_activo || costo_activo || plazo_activo;
    cambiar_costo.disabled=comentario_activo || prioridad_activa || plazo_activo;
    costo.disabled=comentario_activo || prioridad_activa || plazo_activo;
    cambiar_plazo.disabled=comentario_activo || prioridad_activa || costo_activo;
    plazo.disabled=comentario_activo || prioridad_activa || costo_activo;
}

function boton_cambiar_atributo_req(atributo){
"use strict";
    var todo_ok=true;
    var paquete={
        tra_proy:elemento_existente('tra_proy').value, 
        tra_req:elemento_existente('tra_req').value, 
    };
    paquete['tra_nuevo_'+atributo]=elemento_existente('tra_nuevo_'+atributo).value,
    enviar_paquete({
        proceso:'cambiar_'+atributo+'_req',
        paquete:paquete,        
        cuando_ok:function(datos){
            ir_a_url(location.pathname+"?hacer=agregar_novedades_req&todo="+JSON.stringify({
            'tra_proy':elemento_existente('tra_proy').value,
            'tra_req':elemento_existente('tra_req').value,            
        })+'&y_luego=buscar');            
        },
        cuando_error:function(mensaje){            
        },        
        usar_fondo_de:elemento_existente('cambiar_'+atributo),
        mostrar_tilde_confirmacion:true
    });
}

function conF5correrEjecutar(accion){
    tra_sql.addEventListener('blur',function(){
        accion();
        alert('listo');
    });
/* ejemplos de deshabilitar F5:
http://stackoverflow.com/questions/2482059/disable-f5-and-browser-refresh-using-javascript
http://stackoverflow.com/questions/14707602/capturing-f5-keypress-event-in-javascript-using-window-event-keycode-in-window-o
http://jsfiddle.net/SpYk3/C85Hs/
http://stackoverflow.com/questions/1400528/is-there-a-way-to-capture-override-ctrl-r-or-f5-on-ie-using-javascript
http://lineadecodigo.com/javascript/capturar-la-tecla-f5-con-javascript/

Tener en cuenta que donde los ejemplos dicien

document.onkeydown=ALGO;

nosotros hacemos

document.addEventListener('keydown')=ALGO;
*/
}