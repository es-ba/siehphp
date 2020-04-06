<?php
//UTF-8:SÍ
// require_once "tabla_formularios.php";
require_once "tablas.php";

class Tabla_saltos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('sal');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('sal_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('sal_var',array('hereda'=>'variables','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('sal_conopc',array('hereda'=>'con_opc','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('sal_opc',array('hereda'=>'opciones','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('sal_destino',array('tipo'=>'texto','largo'=>50,'not_null'=>true,'validart'=>'codigo'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE saltos
  ADD CONSTRAINT "texto invalido en sal_conopc de tabla saltos" CHECK (comun.cadena_valida(sal_conopc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE saltos
  ADD CONSTRAINT "texto invalido en sal_destino de tabla saltos" CHECK (comun.cadena_valida(sal_destino::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE saltos
  ADD CONSTRAINT "texto invalido en sal_opc de tabla saltos" CHECK (comun.cadena_valida(sal_opc::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE saltos
  ADD CONSTRAINT "texto invalido en sal_ope de tabla saltos" CHECK (comun.cadena_valida(sal_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE saltos
  ADD CONSTRAINT "texto invalido en sal_var de tabla saltos" CHECK (comun.cadena_valida(sal_var::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>