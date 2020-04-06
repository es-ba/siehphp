<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_nov_adjuntos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('novadj');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('novadj_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('novadj_nov',array('hereda'=>'novedades','modo'=>'pk'));
        $this->definir_campo('novadj_adj',array('es_pk'=>true,'tipo'=>'serial'));
        $this->definir_campo('novadj_nombre_archivo',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('novadj_descripcion',   array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('novadj_tipo',          array('tipo'=>'texto','largo'=>50));
    }
}
?>