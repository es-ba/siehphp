<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_a_ingreso extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ing');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ing_ing',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('ing_descripcion',array('tipo'=>'texto','largo'=>50)); 
    }
}
?>