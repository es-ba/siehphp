<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_dominio extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dom');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dom_dom',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('dom_descripcion',array('tipo'=>'texto','largo'=>200)); 
        $this->definir_campo('dom_marco',array('tipo'=>'entero'));
        $this->definir_campo('dom_dias_para_fin_campo',array('tipo'=>'entero'));
        $this->definir_campo('dom_dias_para_fin_norea',array('tipo'=>'entero','def'=>2));
    }
}
?>