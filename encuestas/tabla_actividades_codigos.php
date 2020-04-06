<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_actividades_codigos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('act_cod');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('codigo',array('es_pk'=>true, 'tipo'=>'entero','not_null'=>true));
        $this->definir_campo('nombre_variable',array('tipo'=>'texto'));
        $this->definir_campo('texto',array('tipo'=>'texto'));
        $this->definir_campo('abr',array('tipo'=>'texto'));
        $this->definir_campo('detalle',array('tipo'=>'texto'));
        $this->definir_campo('imagen',array('tipo'=>'texto'));
        $this->definir_campo('exclusividad',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('grupo',array('tipo'=>'texto','largo'=>1));
        $this->definir_campo('obligatoriedad',array('tipo'=>'logico','def'=>false));         
        $this->definir_campo('opcion_d12',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('opcion_d13',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('opcion_d22',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('opcion_d23',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('icono',array('tipo'=>'texto'));
        $this->definir_campo('color',array('tipo'=>'texto'));
        $this->definir_campo('rescatable',array('tipo'=>'logico','def'=>false));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE actividades_codigos
  ADD CONSTRAINT "Grupos considerados" CHECK (grupo::text in ('D','F','M'));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }  
}
?>