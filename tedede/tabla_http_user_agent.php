<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_http_user_agent extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('httpua');
        $this->heredar_en_cascada=true;
        $this->con_campos_auditoria=false;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('httpua_httpua',array('es_pk'=>true,'tipo'=>'serial'));
        $this->definir_campo('httpua_texto',array('tipo'=>'texto','not_null'=>true,'unico'=>true));
        $this->definir_tablas_hijas(array('sesiones'=>false));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE http_user_agent
  ADD CONSTRAINT "texto invalido en httpua_texto de tabla http_user_agent" CHECK (comun.cadena_valida(httpua_texto, 'cualquiera'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>