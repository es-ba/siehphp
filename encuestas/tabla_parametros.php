<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_parametros extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('par');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('par_unicoregistro',array('es_pk'=>true,'tipo'=>'logico', 'def'=>true,'not_null'=>true));
        $this->definir_campo('par_ope',array('hereda'=>'operativos','modo'=>'pk','not_null'=>true));
        $this->definir_campo('par_anio',array('tipo'=>'entero','not_null'=>true));
        $this->definir_campo('par_periodo_ipcba',array('tipo'=>'texto', 'largo'=>11));
        $this->definir_campo('par_anio_ipcba',array('tipo'=>'entero'));
        $this->definir_campo('par_mes_ipcba',array('tipo'=>'entero'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE parametros
  ADD CONSTRAINT "parametros_unicoregistro_check" CHECK (par_unicoregistro);
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>