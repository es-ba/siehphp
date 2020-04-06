<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_forprod extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('formulario'  ,array('hereda'=>'formularios','modo'=>'pk'));
        $this->definir_campo('producto'    ,array('hereda'=>'productos','modo'=>'pk'));
    }
} 
?>