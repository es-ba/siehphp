<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_con_var extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('convar');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('convar_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('convar_con',array('hereda'=>'consistencias','modo'=>'pk'));
        $this->definir_campo('convar_var',array('tipo'=>'texto','largo'=>'50','es_pk'=>true,'validart'=>'codigo'));
        $this->definir_campo('convar_texto',array('tipo'=>'texto','largo'=>800,'validart'=>'castellano'));        
        $this->definir_campo('convar_for',array('hereda'=>'formularios','modo'=>'fk_obligatoria','validart'=>'codigo'));
        $this->definir_campo('convar_mat',array('hereda'=>'matrices','modo'=>'fk_optativa','validart'=>'codigo'));
        $this->definir_campo('convar_orden',array('tipo'=>'entero'));        
    }
  
  
  
  
  
  
      function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_con de tabla con_var" CHECK (comun.cadena_valida(convar_con, 'formula'::text));
/*OTRA*/
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_for de tabla con_var" CHECK (comun.cadena_valida(convar_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_mat de tabla con_var" CHECK (comun.cadena_valida(convar_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_ope de tabla con_var" CHECK (comun.cadena_valida(convar_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_texto de tabla con_var" CHECK (comun.cadena_valida(convar_texto::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE con_var
  ADD CONSTRAINT "texto invalido en convar_var de tabla con_var" CHECK (comun.cadena_valida(convar_var::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>