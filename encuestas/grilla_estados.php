<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_estados extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }   
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('est_est'));
    }
}
?>