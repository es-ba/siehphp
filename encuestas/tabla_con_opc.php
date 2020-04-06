<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
require_once "tabla_opciones.php";

class Tabla_con_opc extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('conopc');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('conopc_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('conopc_conopc',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('conopc_texto',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('conopc_despliegue',array('tipo'=>'texto','largo'=>50,'def'=>'vertical','validart'=>'codigo'));
        $this->definir_tablas_hijas(array(
            'opciones'=>true,
            'saltos'=>true,
            'variables'=>false));
    }
  
  
  
  
  function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE con_opc
  ADD CONSTRAINT "texto invalido en conopc_conopc de tabla con_opc" CHECK (comun.cadena_valida(conopc_conopc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_opc
  ADD CONSTRAINT "texto invalido en conopc_despliegue de tabla con_opc" CHECK (comun.cadena_valida(conopc_despliegue::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_opc
  ADD CONSTRAINT "texto invalido en conopc_ope de tabla con_opc" CHECK (comun.cadena_valida(conopc_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_opc
  ADD CONSTRAINT "texto invalido en conopc_texto de tabla con_opc" CHECK (comun.cadena_valida(conopc_texto::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>