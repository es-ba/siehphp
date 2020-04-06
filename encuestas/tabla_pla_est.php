<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_pla_est extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('plaest');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('plaest_planilla',array('hereda'=>'planillas', 'modo'=>'pk'));        
        $this->definir_campo('plaest_ope',array('hereda'=>'operativos','modo'=>'pk'));   
        $this->definir_campo('plaest_est',array('hereda'=>'estados', 'modo'=>'pk'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE pla_est
  ADD CONSTRAINT "texto invalido en plaest_ope de tabla pla_est" CHECK (comun.cadena_valida(plaest_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE pla_est
  ADD CONSTRAINT "texto invalido en plaest_planilla de tabla pla_est" CHECK (comun.cadena_valida(plaest_planilla::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>