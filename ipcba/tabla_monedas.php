<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_monedas extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('moneda'        ,array('tipo'=>'texto', 'largo'=>10, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('nombre_moneda' ,array('tipo'=>'texto', 'largo'=>100));
        $this->definir_campo('esnacional'    ,array('tipo'=>'logico'));
    }
} 

?>