<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_ocupacion extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ocu');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ocu_ocu',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('ocu_descripcion',array('tipo'=>'texto','largo'=>200)); 
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE ocupacion
  ADD CONSTRAINT "texto de descripción de ocupación inválido" CHECK (comun.cadena_valida(ocu_descripcion::text, 'castellano'::text));
SQL;
  $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>