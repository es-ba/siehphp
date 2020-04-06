<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_tipo_nov extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tiponov');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tiponov_tiponov', array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE tipo_nov
  ADD CONSTRAINT "texto invalido en tiponov_tiponov de tabla tipo_nov" CHECK (comun.cadena_valida(tiponov_tiponov::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>