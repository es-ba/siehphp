<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_ua extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ua');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ua_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('ua_ua',array('es_pk'=>true,'tipo'=>'texto','largo'=>30,'validart'=>'codigo'));
        $this->definir_campo('ua_prefijo_respuestas',array('tipo'=>'texto','largo'=>30,'validart'=>'codigo'));
        $this->definir_campo('ua_sufijo_tablas',array('tipo'=>'texto','largo'=>30,'validart'=>'codigo'));
        $this->definir_campo('ua_pk',array('tipo'=>'texto','largo'=>300,'validart'=>'json'));
        $this->definir_tablas_hijas(array(
            'matrices'=>false,
        ));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE ua
  ADD CONSTRAINT "texto invalido en ua_ope de tabla ua" CHECK (comun.cadena_valida(ua_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE ua
  ADD CONSTRAINT "texto invalido en ua_pk de tabla ua" CHECK (comun.cadena_valida(ua_pk::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE ua
  ADD CONSTRAINT "texto invalido en ua_prefijo_respuestas de tabla ua" CHECK (comun.cadena_valida(ua_prefijo_respuestas::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE ua
  ADD CONSTRAINT "texto invalido en ua_sufijo_tablas de tabla ua" CHECK (comun.cadena_valida(ua_sufijo_tablas::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE ua
  ADD CONSTRAINT "texto invalido en ua_ua de tabla ua" CHECK (comun.cadena_valida(ua_ua::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>