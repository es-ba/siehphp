<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_bitacora extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('bit');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('bit_ope',array('tipo'=>'texto')); // ANTES ,array('hereda'=>'operativos','modo'=>'pk'). Volver a poner si existe operativos. 
        $this->definir_campo('bit_bit',array('es_pk'=>true,'tipo'=>'serial'));
        $this->definir_campo('bit_proceso',array('tipo'=>'texto'));
        $this->definir_campo('bit_parametros',array('tipo'=>'texto'));
        $this->definir_campo('bit_resultado',array('tipo'=>'texto'));        
        $this->definir_campo('bit_inicio',array('tipo'=>'timestamp','def'=>array('funcion'=>'now()')));
        $this->definir_campo('bit_fin',array('tipo'=>'timestamp'));
        $this->definir_campo('bit_valor_respuesta',array('tipo'=>'logico'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE bitacora
  ADD CONSTRAINT "texto invalido en bit_ope de tabla bitacora" CHECK (comun.cadena_valida(bit_ope, 'codigo'::text));
/*OTRA*/
ALTER TABLE bitacora
  ADD CONSTRAINT "texto invalido en bit_parametros de tabla bitacora" CHECK (comun.cadena_valida(bit_parametros, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE bitacora
  ADD CONSTRAINT "texto invalido en bit_proceso de tabla bitacora" CHECK (comun.cadena_valida(bit_proceso, 'codigo'::text));
/*OTRA*/
ALTER TABLE bitacora
  ADD CONSTRAINT "texto invalido en bit_resultado de tabla bitacora" CHECK (comun.cadena_valida(bit_resultado, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>