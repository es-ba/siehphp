<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_estados_ingreso extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('esting');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('esting_estado',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('esting_descripcion',array('tipo'=>'texto','largo'=>200));
        $this->definir_tablas_hijas(array(
            'respuestas'=>false,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE estados_ingreso
  ADD CONSTRAINT "texto invalido en esting_descripcion de tabla estados_ingreso" CHECK (comun.cadena_valida(esting_descripcion::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE estados_ingreso
  ADD CONSTRAINT "texto invalido en esting_estado de tabla estados_ingreso" CHECK (comun.cadena_valida(esting_estado, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>