<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tipoinf extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('tipoinformante'       ,array('tipo'=>'texto', 'largo'=>1, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('otrotipoinformante'   ,array('tipo'=>'texto', 'largo'=>1, 'not_null'=>true));
        $this->definir_campo('nombretipoinformante' ,array('tipo'=>'texto', 'largo'=>30));
    }
} 

?>