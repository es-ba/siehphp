<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_magnitudes extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('magnitud'                ,array('tipo'=>'texto', 'largo'=>12, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('nombremagnitud'          ,array('tipo'=>'texto', 'largo'=>40));
        $this->definir_campo('unidadprincipalsingular' ,array('tipo'=>'texto', 'largo'=>40));
        $this->definir_campo('unidadprincipalplural'   ,array('tipo'=>'texto', 'largo'=>40));
    }
} 

?>