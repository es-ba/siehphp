<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_rol_pla extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('rolpla');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('rolpla_rol',array('hereda'=>'roles', 'modo'=>'pk'));
        $this->definir_campo('rolpla_planilla',array('hereda'=>'planillas', 'modo'=>'pk'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE rol_pla
  ADD CONSTRAINT "texto invalido en rolpla_planilla de tabla rol_pla" CHECK (comun.cadena_valida(rolpla_planilla::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE rol_pla
  ADD CONSTRAINT "texto invalido en rolpla_rol de tabla rol_pla" CHECK (comun.cadena_valida(rolpla_rol::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>