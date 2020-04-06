<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_est_var extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('estvar');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('estvar_ope',array('hereda'=>'operativos','modo'=>'pk'));        
        $this->definir_campo('estvar_var',array('hereda'=>'variables', 'modo'=>'pk'));
        $this->definir_campo('estvar_est',array('hereda'=>'estados', 'modo'=>'pk'));        
        $this->definir_campo('estvar_editable',array('tipo'=>'logico'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE est_var
  ADD CONSTRAINT "texto invalido en estvar_ope de tabla est_var" CHECK (comun.cadena_valida(estvar_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE est_var
  ADD CONSTRAINT "texto invalido en estvar_var de tabla est_var" CHECK (comun.cadena_valida(estvar_var::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>