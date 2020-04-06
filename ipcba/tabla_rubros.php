<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_rubros extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('rubro'          ,array('tipo'=>'entero', 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('nombrerubro'    ,array('tipo'=>'texto', 'largo'=>50, 'not_null'=>true));
        $this->definir_campo('tipoinformante' ,array('hereda'=>'tipoinf','modo'=>'fk_obligatoria'));
        $this->definir_campo('despacho'       ,array('tipo'=>'texto', 'largo'=>1, 'not_null'=>true));
        $this->definir_campo('grupozonal'     ,array('tipo'=>'texto', 'largo'=>1));
    }
} 

?>