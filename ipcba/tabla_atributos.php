<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_atributos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('atributo'             ,array('tipo'=>'entero', 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('nombreatributo'       ,array('tipo'=>'texto', 'largo'=>250));
        $this->definir_campo('tipodato'             ,array('tipo'=>'texto', 'largo'=>12, 'not_null'=>true));
        $this->definir_campo('abratributo'          ,array('tipo'=>'texto', 'largo'=>250));
        $this->definir_campo('escantidad'           ,array('tipo'=>'texto', 'largo'=>1, 'def'=>'N'));
        $this->definir_campo('unidaddemedida'       ,array('hereda'=>'unidades','modo'=>'fk_optativa','campo_relacionado'=>'unidad'));
        $this->definir_campo('es_vigencia'          ,array('tipo'=>'logico'));
        $this->definir_campo('valorinicial'         ,array('tipo'=>'texto', 'largo'=>20));
    }
} 

?>