<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
require_once "valores_especiales.php";

class Tabla_personal extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('per');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('per_ope',array('hereda'=>'operativos','modo'=>'pk','campo_relacionado'=>'ope_ope','validart'=>'codigo'));
        $this->definir_campo('per_per',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('per_apellido',array('tipo'=>'texto','largo'=>500,'es_nombre'=>true,'validart'=>'castellano'));
        $this->definir_campo('per_nombre',array('tipo'=>'texto','largo'=>500,'es_nombre'=>true,'validart'=>'castellano'));
        $this->definir_campo('per_cuit', array('tipo'=>'texto'));  
        $this->definir_campo('per_rol',array('hereda'=>'roles','modo'=>'fk_obligatoria','campo_relacionado'=>'rol_rol', 'def'=>'encuestador','validart'=>'codigo'));
        $this->definir_campo('per_dominio',array('tipo'=>'entero','mostrar_al_elegir'=>true));
        $this->definir_campo('per_comuna',array('tipo'=>'entero','mostrar_al_elegir'=>true));  
        $this->definir_campo('per_usu',array('hereda'=>'usuarios','modo'=>'fk_optativa','controlar_definir_hijas_en_el_padre'=>false,'validart'=>'codigo'));       
        $this->definir_campo('per_activo',array('tipo'=>'logico','def'=>true,'not_null'=>true));  
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE personal
  ADD CONSTRAINT "texto invalido en per_apellido de tabla personal" CHECK (comun.cadena_valida(per_apellido::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE personal
  ADD CONSTRAINT "texto invalido en per_nombre de tabla personal" CHECK (comun.cadena_valida(per_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE personal
  ADD CONSTRAINT "texto invalido en per_ope de tabla personal" CHECK (comun.cadena_valida(per_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE personal
  ADD CONSTRAINT "texto invalido en per_rol de tabla personal" CHECK (comun.cadena_valida(per_rol::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE personal
  ADD CONSTRAINT "texto invalido en per_usu de tabla personal" CHECK (comun.cadena_valida(per_usu::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>