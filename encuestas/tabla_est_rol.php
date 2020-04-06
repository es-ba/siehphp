<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_est_rol extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('estrol');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('estrol_rol',array('hereda'=>'roles', 'modo'=>'pk'));
        $this->definir_campo('estrol_ope',array('hereda'=>'operativos','modo'=>'pk')); 
        $this->definir_campo('estrol_est',array('hereda'=>'estados', 'modo'=>'pk'));        
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE est_rol
  ADD CONSTRAINT "texto invalido en estrol_ope de tabla est_rol" CHECK (comun.cadena_valida(estrol_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE est_rol
  ADD CONSTRAINT "texto invalido en estrol_rol de tabla est_rol" CHECK (comun.cadena_valida(estrol_rol::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>