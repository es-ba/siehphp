<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_importancia extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('importancia');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('importancia_importancia', array('es_pk'=>true,'tipo'=>'texto'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE importancia
  ADD CONSTRAINT "texto invalido en importancia_importancia de tabla importancia" CHECK (comun.cadena_valida(importancia_importancia, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>