<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_verificado extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ver');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ver_ver',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('ver_descripcion',array('tipo'=>'texto','largo'=>200)); 
    }
}
?>