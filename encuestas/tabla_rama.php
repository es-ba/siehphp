<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_rama extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ram');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ram_ram',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('ram_descripcion',array('tipo'=>'texto','largo'=>200)); 
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE rama
  ADD CONSTRAINT "texto de descripción de rama inválido" CHECK (comun.cadena_valida(ram_descripcion::text, 'castellano'::text));
SQL;
  $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>