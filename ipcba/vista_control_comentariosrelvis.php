<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_comentariosrelvis extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('informante'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('visita'                       ,array('tipo'=>'entero', 'es_pk'=>true,  'origen'=>'visita'));
        $this->definir_campo('panel'                        ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                        ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('encuestador'                  ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('nombreencuestador'            ,array('tipo'=>'texto', 'origen'=>'nombreencuestador'));
        $this->definir_campo('recepcionista'                ,array('tipo'=>'texto', 'origen'=>'recepcionista'));
        $this->definir_campo('nombrerecepcionista'          ,array('tipo'=>'texto', 'origen'=>'nombrerecepcionista'));
        $this->definir_campo('rubro'                        ,array('tipo'=>'entero', 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'                  ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('nombreformulario'             ,array('tipo'=>'texto', 'origen'=>'nombreformulario'));
        $this->definir_campo('comentarios'                  ,array('tipo'=>'texto', 'origen'=>'comentarios'));
    }
    function clausula_from(){
        return "control_comentariosrelvis";
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
            'encuestador',
            'nombreencuestador',
            'recepcionista',
            'nombrerecepcionista',
            'rubro',
            'nombrerubro',
            'formulario',
            'nombreformulario',
            'comentarios'
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