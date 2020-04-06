<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_replica extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('rep');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('rep_rep',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('rep_dominio',array('tipo'=>'entero'));
    }
}
?>