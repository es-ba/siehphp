<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_result_sup extends Tabla{
    function definicion_estructura(){    
        $this->definir_prefijo('ressup');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ressup_ressup',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('ressup_descripcion',array('tipo'=>'entero'));
        $this->definir_campo('ressup_descripcion',array('tipo'=>'texto','largo'=>200));
    }
}
?>