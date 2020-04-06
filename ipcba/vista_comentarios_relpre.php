<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_comentariosrelpre extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true,  'origen'=>'visita'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('recepcionista'                ,array('tipo'=>'texto', 'origen'=>'recepcionista'));
        $this->definir_campo('nombrerecepcionista'          ,array('tipo'=>'texto', 'origen'=>'nombrerecepcionista'));
        $this->definir_campo('producto'                     ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'               ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('observacion'                  ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'observacion'));
        $this->definir_campo('tipoprecio'                   ,array('tipo'=>'texto', 'origen'=>'tipoprecio'));
        $this->definir_campo('comentariosrelpre'            ,array('tipo'=>'texto', 'origen'=>'comentariosrelpre'));
    }
    function clausula_from(){
        return "control_comentariosrelpre";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'informante',
            'visita',
            'panel',
            'tarea',
            'recepcionista',
            'nombrerecepcionista',
            'producto',
            'nombreproducto',
            'observacion',
            'tipoprecio',
            'comentariosrelpre'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'
                                                   ,'panel'
                                                   ,'tarea'
                                                   ,'informante'
                                                   ,'visita'
                                                   ,'formulario'
                                                   ));
    }
}
?>