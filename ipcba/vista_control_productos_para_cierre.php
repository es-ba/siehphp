<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_control_productos_para_cierre extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('calculo'              ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'calculo'));
        $this->definir_campo('producto'             ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'       ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('variacion'            ,array('tipo'=>'decimal', 'origen'=>'variacion'));
        $this->definir_campo('incidencia'           ,array('tipo'=>'decimal', 'origen'=>'incidencia'));
        $this->definir_campo('cantincluidos'        ,array('tipo'=>'entero', 'origen'=>'cantincluidos'));
        $this->definir_campo('cantrealesincluidos'  ,array('tipo'=>'entero', 'origen'=>'cantrealesincluidos'));
        $this->definir_campo('cantimputados'        ,array('tipo'=>'entero', 'origen'=>'cantimputados'));        
        $this->definir_campo('svariacion'           ,array('tipo'=>'decimal', 'origen'=>'s_variacion'));
        $this->definir_campo('scantincluidos'       ,array('tipo'=>'entero', 'origen'=>'s_cantincluidos'));
        $this->definir_campo('scantrealesincluidos' ,array('tipo'=>'entero', 'origen'=>'s_cantrealesincluidos'));
        $this->definir_campo('scantimputados'       ,array('tipo'=>'entero', 'origen'=>'s_cantimputados'));
        $this->definir_campo('tvariacion'           ,array('tipo'=>'decimal', 'origen'=>'t_variacion'));
        $this->definir_campo('tcantincluidos'       ,array('tipo'=>'entero', 'origen'=>'t_cantincluidos'));
        $this->definir_campo('tcantrealesincluidos' ,array('tipo'=>'entero', 'origen'=>'t_cantrealesincluidos'));
        $this->definir_campo('tcantimputados'       ,array('tipo'=>'entero', 'origen'=>'t_cantimputados'));
    }
    function clausula_from(){
        return "control_productos_para_cierre";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'calculo',
            'producto',
            'nombreproducto',
            'variacion',
            'incidencia',
            'cantincluidos',
            'cantrealesincluidos',
            'cantimputados',
            'svariacion',
            'scantincluidos',
            'scantrealesincluidos',
            'scantimputados',
            'tvariacion',
            'tcantincluidos',
            'tcantrealesincluidos',
            'tcantimputados'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'calculo'
                                                    ,'producto'
                                                     ));
    }
}
?>