<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_varcal_destinos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('varcaldes');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('varcaldes_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('varcaldes_destino',array('tipo'=>'texto','largo'=>'50','es_pk'=>true,'validart'=>'codigo'));
        $this->definir_campo('varcaldes_ua' ,array('hereda'=>'ua','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('varcaldes_for',array('hereda'=>'formularios','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('varcaldes_mat',array('hereda'=>'matrices','modo'=>'fk_optativa','validart'=>'codigo'));
        $this->definir_campo('varcaldes_orden',array('tipo'=>'entero'));        
    }

    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE varcal_destinos
  ADD CONSTRAINT "texto invalido en varcaldes_destino de tabla varcal_destinos" CHECK (comun.cadena_valida(varcaldes_destino, 'codigo'::text));
/*OTRA*/
ALTER TABLE varcal_destinos
  ADD CONSTRAINT "texto invalido en varcaldes_for de tabla varcal_destinos" CHECK (comun.cadena_valida(varcaldes_for::text, 'codigo'::text));
/*OTRA*/                                          
ALTER TABLE varcal_destinos                               
  ADD CONSTRAINT "texto invalido en varcaldes_mat de tabla varcal_destinos" CHECK (comun.cadena_valida(varcaldes_mat::text, 'codigo'::text));
/*OTRA*/                            
ALTER TABLE varcal_destinos                 
  ADD CONSTRAINT "texto invalido en varcaldes_ope de tabla varcal_destinos" CHECK (comun.cadena_valida(varcaldes_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE varcal_destinos
  ADD CONSTRAINT "texto invalido en varcaldes_ua de tabla varcal_destinos" CHECK (comun.cadena_valida(varcaldes_ua::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>