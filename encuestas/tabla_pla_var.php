<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_pla_var extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('plavar');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('plavar_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('plavar_var',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('plavar_planilla',array('hereda'=>'planillas','modo'=>'pk'));                
        $this->definir_campo('plavar_editable',array('tipo'=>'logico','def'=>false, 'not_null'=>true));                
        $this->definir_campo('plavar_orden',array('tipo'=>'entero'));        
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE pla_var
  ADD CONSTRAINT "texto invalido en plavar_ope de tabla pla_var" CHECK (comun.cadena_valida(plavar_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE pla_var
  ADD CONSTRAINT "texto invalido en plavar_planilla de tabla pla_var" CHECK (comun.cadena_valida(plavar_planilla::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE pla_var
  ADD CONSTRAINT "texto invalido en plavar_var de tabla pla_var" CHECK (comun.cadena_valida(plavar_var::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }

}

?>