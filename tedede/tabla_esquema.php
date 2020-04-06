<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_esquema extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('esq');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('esq_esq',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true));
    }
}
?>