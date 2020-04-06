<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
// require_once "valores_especiales.php";

class Tabla_rol_rol extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('rolrol');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('rolrol_principal',array('hereda'=>'roles','modo'=>'pk','campo_relacionado'=>'rol_rol','validart'=>'codigo'));
        $this->definir_campo('rolrol_delegado' ,array('hereda'=>'roles','modo'=>'pk','campo_relacionado'=>'rol_rol','validart'=>'codigo'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE rol_rol
  ADD CONSTRAINT "texto invalido en rolrol_delegado de tabla rol_rol" CHECK (comun.cadena_valida(rolrol_delegado::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE rol_rol
  ADD CONSTRAINT "texto invalido en rolrol_principal de tabla rol_rol" CHECK (comun.cadena_valida(rolrol_principal::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>