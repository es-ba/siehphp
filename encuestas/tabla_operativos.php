<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";
require_once "esquema_encu.php";
require_once "tabla_formularios.php";
require_once "tabla_con_opc.php";
require_once "tabla_claves.php";
require_once "armador_de_salida.php";

class Tabla_operativos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('ope');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('ope_ope',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('ope_nombre',array('tipo'=>'texto','largo'=>500,'validart'=>'castellano'));
        $this->definir_campo('ope_ope_anterior',array('tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('ope_en_campo',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('ope_rev_metadatos',array('tipo'=>'logico','def'=>false));
        $this->definir_campo('ope_dispositivo_unico',array('tipo'=>'entero'));
        $this->definir_tablas_hijas(array(
            'formularios'=>true,
            'bloques'=>true,
            'ua'=>true,
            'matrices'=>true,
            'preguntas'=>true,
            'con_opc'=>true,
            'variables'=>true,
            'opciones'=>true,
            'saltos'=>true,
            'estados'=>true,
            'claves'=>true,
            'respuestas'=>true,
            // 'estados_ingreso'=>true,
            'filtros'=>true,
            'roles'=>true,
            'rol_rol'=>true,
            //'tipo_nov'=>true,
            //'importancia'=>true,
            //'usuarios'=>true,            
            'novedades'=>true,            
            'personal'=>true,
            //'tem'=>true,
            'consistencias'=>true,
            'inconsistencias'=>true,
            'relaciones'=>true,
            'con_var'=>true,
            'bolsas'=>true,
            'ano_con'=>true,
            'excepciones'=>true,
            'bitacora'=>true,
            'anoenc'=>true,
            'varcal'=>true,
            'varcal_destinos'=>true,
            'baspro'=>true,
            'semanas'=>true,
            'registro_claves'=>true,
        ));
    }
    function desplegar_formulario_principal(){
        /*
        $tabla_formularios=$this->fabrica->crear_tabla('formularios');
        $tabla_formularios->leer(array('for_es_principal'=>true, 'for_ope'=>$this->datos->ope_ope));
        $tabla_formularios->desplegar();
        */
    }
    function desplegar_subtablas(){
        if(!isset($this->despliegue)){
            $this->despliegue=new StdClass();
        }
        $this->despliegue->tabla_formularios=$tabla_formularios=$this->definicion_tabla('formularios');
        $tabla_formularios->leer_varios(array(
            'for_ope'=>$this->datos->ope_ope,
        ));
        while($tabla_formularios->obtener_leido()){
            $tabla_formularios->desplegar();
        }
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE operativos
  ADD CONSTRAINT "texto invalido en ope_nombre de tabla operativos" CHECK (comun.cadena_valida(ope_nombre::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE operativos
  ADD CONSTRAINT "texto invalido en ope_ope de tabla operativos" CHECK (comun.cadena_valida(ope_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE operativos
  ADD CONSTRAINT "texto invalido en ope_ope_anterior de tabla operativos" CHECK (comun.cadena_valida(ope_ope_anterior::text, 'codigo'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>