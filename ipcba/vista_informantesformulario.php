<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class Vista_informantesformulario extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'                      ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('formulario'                   ,array('tipo'=>'entero', 'es_pk'=>true, 'origen'=>'formulario'));
        $this->definir_campo('nombreformulario'             ,array('tipo'=>'texto', 'origen'=>'nombreformulario'));
        $this->definir_campo('cantactivos'                  ,array('tipo'=>'entero', 'origen'=>'cantactivos'));
        $this->definir_campo('cantaltas'                    ,array('tipo'=>'entero', 'origen'=>'cantaltas'));
        $this->definir_campo('cantbajas'                    ,array('tipo'=>'entero', 'origen'=>'cantbajas'));
    }
    function clausula_from(){
        return "informantesformulario";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'periodo',
            'formulario',
            'nombreformulario',
            'cantactivos',
            'cantaltas',
            'cantbajas'
             );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'formulario'
                                                     ));
    }
}
?>