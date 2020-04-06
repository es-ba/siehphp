<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_estados extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('est');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('est_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('est_est',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('est_nombre',array('tipo'=>'texto','largo'=>200, 'validart'=>'castellano'));         
        $this->definir_campo('est_criterio',array('tipo'=>'texto','largo'=>700,'validart'=>'formula'));         
        $this->definir_campo('est_editar_encuesta',array('tipo'=>'texto','largo'=>200));        
        $this->definir_campo('est_editar_tem',array('tipo'=>'texto','largo'=>200));
        $this->definir_tablas_hijas(array(
        'pla_est'=>true,
        'est_var'=>true,
        'est_rol'=>true,
        ));                
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE estados
  ADD CONSTRAINT "texto invalido en est_criterio de tabla estados" CHECK (comun.cadena_valida(est_criterio::text, 'formula'::text));
/*OTRA*/
ALTER TABLE estados
  ADD CONSTRAINT "texto invalido en est_nombre de tabla estados" CHECK (comun.cadena_valida(est_nombre::text, 'cualquiera'::text));
/*OTRA*/
ALTER TABLE estados
  ADD CONSTRAINT "texto invalido en est_ope de tabla estados" CHECK (comun.cadena_valida(est_ope::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>