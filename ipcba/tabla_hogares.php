<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_hogares extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('hogar'       ,array('tipo'=>'texto', 'largo'=>9, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('nombrehogar' ,array('tipo'=>'texto', 'largo'=>300, 'not_null'=>true));
    }
} 

?>