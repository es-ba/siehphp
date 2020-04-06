<?php
//UTF-8:SÍ 
//require_once "tablas.php";
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
class vista_desvios extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'               ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'periodo'));
        $this->definir_campo('producto'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('nombreproducto'        ,array('tipo'=>'texto', 'origen'=>'nombreproducto'));
        $this->definir_campo('desvio'                ,array('tipo'=>'decimal', 'origen'=>'desvio'));
    }
    function clausula_from(){
        return "desvios";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
        'periodo', 
        'producto',
        'nombreproducto',
        'desvio'
        );
        return $campos_solo_lectura;
    }
    
     function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'producto'
                                                     ));
    }
}
?>