<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tenencia_operativo extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tenope');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tenope_tenope', array('es_pk'=>true,'tipo'=>'texto','largo'=>100));
    }
}
?>
