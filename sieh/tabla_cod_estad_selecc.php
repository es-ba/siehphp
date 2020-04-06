<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_cod_estad_selecc extends Tabla{
    var $con_campos_auditoria=false;
    function definicion_estructura(){
        $this->definir_prefijo('');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('cod_estad_selecc', array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('descripcion', array('tipo'=>'texto','largo'=>50));
    }
}
?>