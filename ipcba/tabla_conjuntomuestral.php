<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_conjuntomuestral extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('conjuntomuestral'   ,array('tipo'=>'serial', 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('panel'              ,array('tipo'=>'entero'));
        $this->definir_campo('encuestador'        ,array('tipo'=>'texto', 'largo'=>10));
        $this->definir_campo('tiponegociomuestra' ,array('tipo'=>'entero'));
    }
} 

?>