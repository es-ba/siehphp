<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tabcon extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('tablero'               ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('control'               ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('orden'                 ,array('tipo'=>'entero'));
        $this->definir_campo('descripcion'           ,array('tipo'=>'texto'));
        $this->definir_campo('expresion'             ,array('tipo'=>'texto'));
        $this->definir_campo('esperado_desde_dia'    ,array('tipo'=>'entero'));
        $this->definir_campo('esperado_hasta_dia'    ,array('tipo'=>'entero'));
    }
} 

?>