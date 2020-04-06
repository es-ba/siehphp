<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_funciones_automaticas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('fun');
        //$this->heredar_en_cascada=true;
        $this->definir_esquema('dbx');
        $this->definir_campo('fun_fun',array('es_pk'=>true,'tipo'=>'texto','largo'=>500));
        $this->definir_campo('fun_abreviado',array('tipo'=>'texto','largo'=>63));
        $this->definir_campo('fun_codigo',array('tipo'=>'texto'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE dbx.funciones_automaticas
  ADD CONSTRAINT "funciones_automaticas_fun_abreviado_key" UNIQUE (fun_abreviado);
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>