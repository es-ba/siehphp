<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_baspro_var extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('basprovar');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('basprovar_ope',array('hereda'=>'baspro','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP']));
        $this->definir_campo('basprovar_baspro',array('hereda'=>'baspro','modo'=>'pk'));
        //$this->definir_campo('basprovar_baspro',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true)); 
        $this->definir_campo('basprovar_var',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true)); 
        $this->definir_campo('basprovar_alias',array('tipo'=>'texto','largo'=>50)); 
        $this->definir_campo('basprovar_cantdecimales',array('tipo'=>'entero')); 
        $this->definir_campo('basprovar_orden',array('tipo'=>'entero')); 
        $this->definir_campo('basprovar_exportar_en',array('tipo'=>'texto')); 
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
    ALTER TABLE encu.baspro_var
      ADD CONSTRAINT "El valor del campo exportar_en debe ser ambas, mie, exm o nulo" 
        CHECK (basprovar_exportar_en in ('ambas', 'mie', 'exm', 'exm_men'));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;    
    }
}
?>