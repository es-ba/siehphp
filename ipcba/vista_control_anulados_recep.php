<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class vista_control_anulados_recep extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');       
        $this->definir_campo('periodo'              ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'             ,array('tipo'=>'texto' , 'es_pk'=>true, 'origen'=>'producto' ));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto' , 'origen'=>'nombreproducto' ));
        $this->definir_campo('informante'           ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('observacion'          ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('visita'               ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));
        $this->definir_campo('panel'                ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('encuestador'          ,array('tipo'=>'texto' , 'origen'=>'encuestador' ));
        $this->definir_campo('recepcionista'        ,array('tipo'=>'texto' , 'origen'=>'recepcionista' ));
        $this->definir_campo('formulario'           ,array('tipo'=>'entero', 'origen'=>'formulario'));
        $this->definir_campo('comentariosrelpre'    ,array('tipo'=>'texto' , 'origen'=>'comentariosrelpre' ));
        $this->definir_campos_orden(array('periodo','producto','informante','observacion','visita'));    
    }
     function clausula_from(){
        return "control_anulados_recep";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo', 
        'producto', 
        'nombreproducto', 
        'informante', 
        'observacion', 
        'visita',
        'panel', 
        'tarea', 
        'encuestador',
        'recepcionista', 
        'formulario', 
        'comentariosrelpre'
        );
        return $campos_solo_lectura;
    }
}
?>