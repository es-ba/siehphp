<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_relaciones extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('rel');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('rel_rel',array('tipo'=>'texto','es_pk'=>true,'largo'=>3,'validart'=>'formula'));
        $this->definir_campo('rel_nombre',array('tipo'=>'texto','largo'=>20,'not_null'=>true,'validart'=>'castellano'));
        $this->definir_tablas_hijas(array(
            'consistencias'=>true,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE relaciones
  ADD CONSTRAINT "texto invalido en rel_nombre de tabla relaciones" CHECK (comun.cadena_valida(rel_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE relaciones
  ADD CONSTRAINT "texto invalido en rel_rel de tabla relaciones" CHECK (comun.cadena_valida(rel_rel::text, 'formula'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
  
}

?>