<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_control_relev_telef extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('panel'                ,array('tipo'=>'entero', 'origen'=>'panel'));
        $this->definir_campo('tarea'                ,array('tipo'=>'entero', 'origen'=>'tarea'));
        $this->definir_campo('informante'           ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'informante'));
        $this->definir_campo('nombreinformante'     ,array('tipo'=>'texto', 'origen'=>'nombreinformante'));
        $this->definir_campo('direccion'            ,array('tipo'=>'texto', 'origen'=>'direccion'));
        $this->definir_campo('visita'               ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'visita'));
        $this->definir_campo('encuestador'          ,array('tipo'=>'texto', 'origen'=>'encuestador'));
        $this->definir_campo('rubro'                ,array('tipo'=>'entero', 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'          ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('formularios'          ,array('tipo'=>'texto', 'origen'=>'formularios'));
    }
     function clausula_from(){
        return "control_relev_telef";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo'    ,
            'panel'    ,
            'tarea'    ,
            'informante'      ,
            'nombreinformante' ,
            'direccion'     ,
            'visita'  ,
            'encuestador'     ,
            'rubro'     ,
            'nombrerubro',
            'formularios'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'tarea'       
                                                    ,'informante'
                                                     ));
    }
}
?>