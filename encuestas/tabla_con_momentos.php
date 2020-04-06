<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_con_momentos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('conmom');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('conmom_conmom',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('conmom_nivel',array('tipo'=>'entero')); 
    }
}
?>