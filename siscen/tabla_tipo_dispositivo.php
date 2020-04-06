<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tipo_dispositivo extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tds');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tds_tds', array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
    }
}
?>
