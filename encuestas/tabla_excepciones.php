<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_excepciones extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('exc');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('exc_ope',array('hereda'=>'operativos','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP'],'validart'=>'codigo'));
        $this->definir_campo('exc_enc',array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('exc_excepcion',array('tipo'=>'texto','validart'=>'castellano')); 
        $this->definir_campo('exc_obs', array('tipo'=>'texto', 'validart'=>'castellano'));
 
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE excepciones
  ADD CONSTRAINT "texto invalido en exc_excepcion de tabla excepciones" CHECK (comun.cadena_valida(exc_excepcion::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE excepciones
  ADD CONSTRAINT "texto invalido en exc_ope de tabla excepciones" CHECK (comun.cadena_valida(exc_ope::text, 'codigo'::text));
/*OTRA*/  
  ALTER TABLE excepciones
  ADD CONSTRAINT "texto invalido en exc_obs de tabla excepciones" CHECK (comun.cadena_valida(exc_obs::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }

}
/*
OTRA
  ALTER TABLE excepciones
      ADD CONSTRAINT tem_excepciones_enc_fk FOREIGN KEY (exc_enc)
      REFERENCES tem (tem_enc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
*/
?>