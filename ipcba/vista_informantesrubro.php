<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_informantesrubro extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('rubro'                        ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'rubro'));
        $this->definir_campo('nombrerubro'                  ,array('tipo'=>'texto', 'origen'=>'nombrerubro'));
        $this->definir_campo('cantactivos'                  ,array('tipo'=>'entero', 'origen'=>'cantactivos'));
        $this->definir_campo('cantaltas'                    ,array('tipo'=>'entero', 'origen'=>'cantaltas'));
        $this->definir_campo('cantbajas'                    ,array('tipo'=>'entero', 'origen'=>'cantbajas'));
    }
    function clausula_from(){
        return "informantesrubro";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'rubro',
            'nombrerubro',
            'cantactivos',
            'cantaltas',
            'cantbajas'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'rubro'  
                                                     ));
    }
}
?>