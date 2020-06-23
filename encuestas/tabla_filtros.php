<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_filtros extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('fil');
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('fil_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('fil_for',array('hereda'=>'formularios','modo'=>'pk'));
        $this->definir_campo('fil_mat',array('hereda'=>'matrices','modo'=>'fk_obligatoria','forzar_null_a_vacio'=>true));
        $this->definir_campo('fil_blo',array('hereda'=>'bloques','modo'=>'fk_obligatoria'));
        $this->definir_campo('fil_fil',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('fil_texto',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('fil_expresion',array('tipo'=>'texto','largo'=>500));        
        $this->definir_campo('fil_destino',array('tipo'=>'texto','largo'=>50,'not_null'=>true));
        $this->definir_campo('fil_orden',array('tipo'=>'entero'));
        $this->definir_campo('fil_aclaracion',array('tipo'=>'texto','largo'=>500));
        $this->definir_campos_orden('fil_orden');
    }
   function desplegar(){
        $this->id_dom="id_filtro".'_'.$this->datos->fil_fil;
        $this->contexto->salida->abrir_grupo_interno("encabezado_bloque",array('tipo'=>'TR'));
            $this->contexto->salida->abrir_grupo_interno("encabezado_bloque",array('tipo'=>'TD','colspan'=>3));
                $this->contexto->salida->enviar($this->datos->fil_fil,"blo_blo",array('id'=>$this->id_dom));
                $this->contexto->salida->enviar($this->datos->fil_texto,"blo_texto meta_reem");
                $this->contexto->salida->enviar($this->datos->fil_aclaracion,"blo_aclaracion");
                $this->contexto->salida->enviar(CARACTER_SALTO.' '.$this->datos->fil_destino,"opcion_salto",array('tipo'=>'span'/*,'onclick'=>"Saltar_de_a('".$this->id_dom."','".$id_salto."')"*/));
            $this->contexto->salida->cerrar_grupo_interno();
        $this->contexto->salida->cerrar_grupo_interno();
    }
    function definir_orden_por_otra($otra){
        $campos_orden=array();
        if($otra=='blo'){
            $campos_orden[]='(select blo_orden from bloques where blo_ope=fil_ope and blo_for=fil_for and blo_blo=fil_blo )';
        }
        $campos_orden[]='fil_orden';
        $this->definir_campos_orden($campos_orden);
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_aclaracion de tabla filtros" CHECK (comun.cadena_valida(fil_aclaracion::text, 'castellano'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_blo de tabla filtros" CHECK (comun.cadena_valida(fil_blo::text, 'extendido'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_destino de tabla filtros" CHECK (comun.cadena_valida(fil_destino::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_expresion de tabla filtros" CHECK (comun.cadena_valida(fil_expresion::text, 'formula'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_fil de tabla filtros" CHECK (comun.cadena_valida(fil_fil, 'codigo'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_for de tabla filtros" CHECK (comun.cadena_valida(fil_for::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_mat de tabla filtros" CHECK (comun.cadena_valida(fil_mat::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_ope de tabla filtros" CHECK (comun.cadena_valida(fil_ope::text, 'codigo'::text));
/*OTRA*/
ALTER TABLE filtros
  ADD CONSTRAINT "texto invalido en fil_texto de tabla filtros" CHECK (comun.cadena_valida(fil_texto::text, 'castellano y formula'::text));
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}

?>