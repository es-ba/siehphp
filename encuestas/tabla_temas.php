<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_temas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tem');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tem_ope',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true));
        $this->definir_campo('tem_tem',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true));
    }
}
?>