<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_ocupacion extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('procesamiento')){
            $editables[]='ocu_ocu';
            $editables[]='ocu_descripcion';
        };
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }   
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('ocu_ocu'));
    }
    function puede_insertar(){
        return tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('procesamiento');
    }
}
?>