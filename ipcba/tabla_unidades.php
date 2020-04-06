<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_unidades extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('unidad'              ,array('tipo'=>'texto', 'largo'=>20, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('magnitud'            ,array('hereda'=>'magnitudes','modo'=>'fk_obligatoria'));
        $this->definir_campo('factor'              ,array('tipo'=>'real'));
        $this->definir_campo('morfologia'          ,array('tipo'=>'texto', 'largo'=>20));
        $this->definir_campo('abreviaturaestandar' ,array('tipo'=>'texto', 'largo'=>20));
    }
} 

?>