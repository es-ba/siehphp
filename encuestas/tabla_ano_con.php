<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_ano_con extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('anocon');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('anocon_ope',array('hereda'=>'operativos','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP'],'validart'=>'codigo'));
        $this->definir_campo('anocon_con',array('hereda'=>'consistencias','modo'=>'pk'));
        $this->definir_campo('anocon_num',array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('anocon_anotacion',array('tipo'=>'texto','largo'=>1000,'not_null'=>true,'validart'=>'castellano'));        
        $this->definir_campo('anocon_autor',array('tipo'=>'texto','largo'=>30,'not_null'=>true,'validart'=>'codigo'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE ano_con
  ADD CONSTRAINT "texto invalido en anocon_anotacion de tabla ano_con" CHECK (comun.cadena_valida(anocon_anotacion::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE ano_con
  ADD CONSTRAINT "texto invalido en anocon_autor de tabla ano_con" CHECK (comun.cadena_valida(anocon_autor::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE ano_con
  ADD CONSTRAINT "texto invalido en anocon_con de tabla ano_con" CHECK (comun.cadena_valida(anocon_con::text, 'formula'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>