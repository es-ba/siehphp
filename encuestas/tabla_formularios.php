<?php
//UTF-8:SÍ
require_once "tablas.php";
require_once "tabla_bloques.php";
require_once "tabla_preguntas.php";
require_once "tabla_variables.php";

class Tabla_formularios extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('for');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('for_ope',array('hereda'=>'operativos','modo'=>'pk','validart'=>'codigo'));
        $this->definir_campo('for_for',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('for_nombre',array('tipo'=>'texto','largo'=>50,'not_null'=>true,'validart'=>'castellano'));
        $this->definir_campo('for_es_principal',array('tipo'=>'solo_true','def'=>null));
        $this->definir_campo('for_orden',array('tipo'=>'entero','def'=>null));
        $this->definir_campo('for_tarea',array('tipo'=>'texto','largo'=>50,'def'=>null));
        $this->definir_campo('for_es_especial',array('tipo'=>'logico','def'=>false));
        // alter table encu.formularios add column for_tarea varchar(50);
        $this->definir_tablas_hijas(array(
            'bloques'=>true,
            'matrices'=>true,
            'preguntas'=>false,
            'variables'=>false,
            'claves'=>false,
            'respuestas'=>false,
            'filtros'=>true,
            'con_var'=>true,
        ));
        $this->definir_campos_orden(array('for_orden','for_for'));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE formularios
  ADD CONSTRAINT "texto invalido en for_for de tabla formularios" CHECK (comun.cadena_valida(for_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE formularios
  ADD CONSTRAINT "texto invalido en for_nombre de tabla formularios" CHECK (comun.cadena_valida(for_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE formularios
  ADD CONSTRAINT "texto invalido en for_ope de tabla formularios" CHECK (comun.cadena_valida(for_ope::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>