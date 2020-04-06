<?php
//UTF-8:SÍ
// tablas para la eah2013
require_once "tablas.php";

class Tabla_novedades extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('nov');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('nov_ope',    array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('nov_nov',     array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('nov_titulo',  array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('nov_tiponov',    array('tipo'=>'texto','hereda'=>'tipo_nov','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('nov_importancia',array('hereda'=>'importancia','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('nov_detalle', array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('nov_origen',  array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('nov_destino', array('tipo'=>'texto','hereda'=>'roles','campo_relacionado'=>'rol_rol','modo'=>'fk_optativa','def'=>'null','validart'=>'codigo'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_destino de tabla novedades" CHECK (comun.cadena_valida(nov_destino::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_detalle de tabla novedades" CHECK (comun.cadena_valida(nov_detalle::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_importancia de tabla novedades" CHECK (comun.cadena_valida(nov_importancia, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_nov de tabla novedades" CHECK (comun.cadena_valida(nov_nov::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_ope de tabla novedades" CHECK (comun.cadena_valida(nov_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_origen de tabla novedades" CHECK (comun.cadena_valida(nov_origen::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_tiponov de tabla novedades" CHECK (comun.cadena_valida(nov_tiponov::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE novedades
  ADD CONSTRAINT "texto invalido en nov_titulo de tabla novedades" CHECK (comun.cadena_valida(nov_titulo::text, 'codigo'::text));  
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }    
}
?>