<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_trac extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('trac');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('trac_trac' ,array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('trac_servidor',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('trac_db',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('trac_usuario',array('tipo'=>'texto','largo'=>30,'not_null'=>true));
        $this->definir_campo('trac_clave',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('trac_esquema',array('tipo'=>'texto','largo'=>30));
    }
}    
?>