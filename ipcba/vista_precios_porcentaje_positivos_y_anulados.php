<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class vista_precios_porcentaje_positivos_y_anulados extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto'  , 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('informante'           ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('panel'                ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('operativo'            ,array('tipo'=>'texto', 'origen'=>'operativo'));
        $this->definir_campo('formulario'           ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('preciospotenciales'   ,array('tipo'=>'entero', 'origen'=>'preciospotenciales'));
        $this->definir_campo('positivos'            ,array('tipo'=>'entero', 'origen'=>'positivos'));
        $this->definir_campo('anulados'             ,array('tipo'=>'entero', 'origen'=>'anulados'));
        $this->definir_campo('porcentaje'           ,array('tipo'=>'texto', 'origen'=>'porcentaje'));
        $this->definir_campo('atributospotenciales' ,array('tipo'=>'entero', 'origen'=>'atributospotenciales'));
        $this->definir_campo('atributospositivos'   ,array('tipo'=>'entero', 'origen'=>'atributospositivos'));
        $this->definir_campo('porcatributos'        ,array('tipo'=>'texto', 'origen'=>'porcatributos'));

        $this->definir_campos_orden(array('periodo','informante','formulario'));
      
    }
     function clausula_from(){
        return "precios_porcentaje_positivos_y_anulados";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo',
        'informante',
        'panel',
        'tarea',
        'operativo',
        'formulario',
        'preciospotenciales',
        'positivos',
        'anulados',
        'porcentaje',
        'atributospotenciales',
        'atributospositivos',
        'porcatributos'
        );
        return $campos_solo_lectura;
    }
}
?>