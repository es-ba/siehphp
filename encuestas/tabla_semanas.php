<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_semanas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('sem');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('sem_ope',array('hereda'=>'operativos','modo'=>'pk','not_null'=>true));
        $this->definir_campo('sem_sem',array('es_pk'=>true,'tipo'=>'entero','not_null'=>true));
        $this->definir_campo('sem_semana_referencia_desde',array('tipo'=>'fecha'));
        $this->definir_campo('sem_semana_referencia_hasta',array('tipo'=>'fecha'));
        $this->definir_campo('sem_30dias_referencia_desde',array('tipo'=>'fecha'));
        $this->definir_campo('sem_30dias_referencia_hasta',array('tipo'=>'fecha'));
        $this->definir_campo('sem_mes_referencia',array('tipo'=>'fecha')); //falta agregar restricción que el día tiene que ser 1
        $this->definir_campo('sem_carga_enc_desde',array('tipo'=>'fecha'));
        $this->definir_campo('sem_carga_enc_hasta',array('tipo'=>'fecha'));
        $this->definir_campo('sem_carga_recu_desde',array('tipo'=>'fecha'));
        $this->definir_campo('sem_carga_recu_hasta',array('tipo'=>'fecha'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE semanas
  ADD CONSTRAINT "El día de sem_mes_referencia debe ser 1"  CHECK (comun.es_dia_1(sem_mes_referencia));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>