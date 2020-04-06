<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_dicvar extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dicvar');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dicvar_dic', array('es_pk'=>true, 'tipo' => 'texto'));
        $this->definir_campo('dicvar_var', array('es_pk'=>true, 'tipo' => 'texto'));
    }
}
?>