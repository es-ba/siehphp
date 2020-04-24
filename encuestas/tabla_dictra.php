<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_dictra extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dictra');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dictra_dic', array('es_pk'=>true, 'tipo' => 'texto'));
        $this->definir_campo('dictra_ori', array('es_pk'=>true, 'tipo' => 'texto'));
        $this->definir_campo('dictra_des', array('tipo' => 'entero'));
        // deprecated: $this->definir_campo('dictra_texto', array('tipo' => 'texto','largo'=>100));
    }
    function restricciones_especificas(){
/* deprecated
ALTER TABLE dictra
  ADD CONSTRAINT "texto de diccionario inválido" CHECK (comun.cadena_valida(dictra_texto::text, 'castellano'::text));
/*OTRA*/
*/
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE dictra  
  ADD CONSTRAINT "texto invalido en dictra_ori de tabla dictra" CHECK (comun.cadena_valida(dictra_ori, 'castellano'::text));  
SQL;
  $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>