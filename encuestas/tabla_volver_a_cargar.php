<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_volver_a_cargar extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('vol');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('vol_vol',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('vol_descripcion',array('tipo'=>'texto','largo'=>50)); 
    }
}
?>