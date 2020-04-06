<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_proy_usu extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('proyusu');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('proyusu_usu' ,array('hereda'=>'usuarios','modo'=>'pk','campo_relacionado'=>'usu_usu'));
        $this->definir_campo('proyusu_proy' ,array('hereda'=>'proyectos','modo'=>'pk','campo_relacionado'=>'proy_proy'));
        $this->definir_campo('proyusu_puede_escribir', array('tipo'=>'logico'));
        $this->definir_campo('proyusu_ver_todo', array('tipo'=>'logico'));
        $this->definir_campo('proyusu_puede_confirmar', array('tipo'=>'logico','def'=>false));
    }
}    
?>