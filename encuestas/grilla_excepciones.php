<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_excepciones extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        return array('exc_enc','exc_excepcion','exc_obs');
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('exc_ope','exc_enc','exc_excepcion');
    }
    function puede_insertar(){
        return true;
    }
    function puede_eliminar(){
        return tiene_rol('procesamiento');
    }   
}
?>