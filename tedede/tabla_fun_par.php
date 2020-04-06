<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_fun_par extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('funpar');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('funpar_fun',array('hereda'=>'funciones','modo'=>'pk')); 
        $this->definir_campo('funpar_par',array('es_pk'=>true,'tipo'=>'texto','not_null'=>true));
        $this->definir_campo('funpar_tipo',array('tipo'=>'texto')); 
        $this->definir_campo('funpar_predeterminado',array('tipo'=>'texto')); 
    }
}
?>