<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_personal extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('persona' ,array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('labor'   ,array('tipo'=>'enumerado','elementos'=>array('E','S','R','I','A','C'),'largo'=>1));
        $this->definir_campo('nombre'  ,array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('apellido',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('username',array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('activo'  ,array('tipo'=>'enumerado','elementos'=>array('S','N'),'largo'=>1,'def'=>'S','not_null'=>true));
    }
}    

?>