<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_valvalatr extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'      ,array('hereda'=>'prodatr','modo'=>'pk' ));
        $this->definir_campo('atributo'      ,array('hereda'=>'prodatr','modo'=>'pk'));
        $this->definir_campo('valor'         ,array('tipo'=>'texto', 'largo'=>250, 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('validar'       ,array('tipo'=>'logico', 'not_null'=>true, 'def'=>true));
        $this->definir_campo('ponderadoratr' ,array('tipo'=>'real'));
    }
} 

?>