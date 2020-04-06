<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_SelProd extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
       // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto', array('es_pk'=>true, 'tipo' => 'texto' , 'largo'=>8));
        $this->definir_campo('sel_nro', array('es_pk'=>true, 'tipo' => 'entero' ));
        $this->definir_campo('descripcion', array('tipo' => 'texto', 'largo'=>500 ));
        $this->definir_tablas_hijas(array(
        'selprodatr'=>true,
        ));
    }
}
?>