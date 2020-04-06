<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tipopre extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('tipoprecio'      ,array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('nombretipoprecio',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('espositivo'      ,array('tipo'=>'sino_dom','def'=>'N','not_null'=>true));
        $this->definir_campo('visibleparaencuestador',array('tipo'=>'sino_dom','def'=>'S','not_null'=>true));
        $this->definir_campo('registrablanqueo',array('tipo'=>'logico','def'=>false,'not_null'=>true));
    }
}    

?>