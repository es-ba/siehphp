<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_planillas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('planilla');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('planilla_planilla',array('es_pk'=>true,'tipo'=>'texto','largo'=>20,'not_null'=>true));
        $this->definir_campo('planilla_nombre',array('tipo'=>'texto','largo'=>200));         
        $this->definir_tablas_hijas(array(
			'pla_var'=>true,
			'pla_est'=>true,
			'rol_pla'=>true,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE planillas
  ADD CONSTRAINT "texto invalido en planilla_nombre de tabla planillas" CHECK (comun.cadena_valida(planilla_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE planillas
  ADD CONSTRAINT "texto invalido en planilla_planilla de tabla planillas" CHECK (comun.cadena_valida(planilla_planilla::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }

}

?>