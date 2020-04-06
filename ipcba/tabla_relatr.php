<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relatr extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'              ,array('hereda'=>'periodos','modo'=>'pk'));
        $this->definir_campo('producto'             ,array('hereda'=>'productos','modo'=>'pk'));
        $this->definir_campo('observacion'          ,array('hereda'=>'relpre','modo'=>'pk'));
        $this->definir_campo('informante'           ,array('hereda'=>'informantes','modo'=>'pk'));
        $this->definir_campo('atributo'             ,array('hereda'=>'atributos','modo'=>'pk'));
        $this->definir_campo('valor'                ,array('tipo'=>'texto'));
        $this->definir_campo('visita'               ,array('hereda'=>'relvis','modo'=>'pk'));
        $this->definir_campo('validar_con_valvalatr',array('tipo'=>'logico'));
    }
} 

?>