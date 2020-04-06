<?php
//UTF-8:SÍ

function mostrar_visor($este){
    $este->salida->enviar('Encuesta','',array('tipo'=>'label','for'=>'tra_enc'));
    $este->salida->enviar('','',array('tipo'=>'input','id'=>'tra_enc','autofocus'=>true,'style'=>'width:4.2em','value'=>'512392'));
    $este->salida->enviar_boton('traer','',array('onclick'=>'visor_encuesta_traer()'));
    $este->salida->enviar_boton('cambiar filtros','',array('onclick'=>'visor_encuesta_ocultar_mostrar_filtros(null)','id'=>'cambiar_filtros'));
    enviar_grilla($este->salida,'TEM'            ,array(),false,array('simple'=>'true'));
    $tabla_matrices=$este->nuevo_objeto("Tabla_matrices");
    $tabla_matrices->leer_varios(array('mat_for'=>'#!=TEM&!=SUP'));
    while($tabla_matrices->obtener_leido()){
        enviar_grilla($este->salida,'respuestas_'.$tabla_matrices->datos->mat_for.'_'.$tabla_matrices->datos->mat_mat,array(),false,array('simple'=>'true'));
    }
    /*
    enviar_grilla($este->salida,'respuestas_S1_' ,array(),false,array('simple'=>'true'));
    enviar_grilla($este->salida,'respuestas_S1_P',array(),false,array('simple'=>'true'));
    enviar_grilla($este->salida,'respuestas_A1_' ,array(),false,array('simple'=>'true'));
    enviar_grilla($este->salida,'respuestas_A1_X',array(),false,array('simple'=>'true'));
    enviar_grilla($este->salida,'respuestas_I1_' ,array(),false,array('simple'=>'true'));
    */
    $este->salida->enviar_script(<<<JS
function visor_encuesta_traer(){
"use strict";
    for(var i in editores) if(iterable(i,editores)){
        var editor=editores[i];
        var nombre_campo_enc=editor.datos.pks[0];
        var tra_enc=elemento_existente('tra_enc').value;
        editor.filtro_manual[nombre_campo_enc]=tra_enc
        editor.cargar_grilla(document.body,false);
        // editor.refrescar();
    }
}

function visor_encuesta_ocultar_mostrar_filtros(mostrar){
"use strict";
    if(mostrar==null){
        mostrar=editores.TEM.fila_filtro.style.display=='none';
    }
    elemento_existente('cambiar_filtros').value=(mostrar?'ocultar':'mostrar')+' filtros';
    for(var i in editores) if(iterable(i,editores)){
        var editor=editores[i];
        if(editor.fila_filtro){
            editor.fila_filtro.style.display=(mostrar?'table-row':'none');
            editor.fila_botones_orden.style.display=(mostrar?'table-row':'none');
        }
    }
}

JS
    );
}

?>