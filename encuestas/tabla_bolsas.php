<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_bolsas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('bol');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('bol_ope',array('hereda'=>'operativos','modo'=>'pk','def'=>$GLOBALS['NOMBRE_APP'],'validart'=>'codigo'));
        $this->definir_campo('bol_bol',array('es_pk'=>true,'tipo'=>'entero','not_null'=>true));
        $this->definir_campo('bol_cerrada',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('bol_rea',array('tipo'=>'logico',));
        $this->definir_campo('bol_activa',array('tipo'=>'logico','def'=>true));
        $this->definir_campo('bol_revisada',array('tipo'=>'logico'));
        $this->definir_campo('bol_dispositivo',array('tipo'=>'entero','def'=>2));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE bolsas
  ADD CONSTRAINT "texto invalido en bol_ope de tabla bolsas" CHECK (comun.cadena_valida(bol_ope::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>