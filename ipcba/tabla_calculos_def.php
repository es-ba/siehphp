<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_calculos_def extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('calculo'          ,array('es_pk'=>true,'tipo'=>'entero'           ));
        $this->definir_campo('definicion'       ,array('tipo'=>'texto','largo'=>4000));
        $this->definir_campo('principal'        ,array('tipo'=>'logico' ));
        $this->definir_campo('agrupacionprincipal',array('tipo'=>'texto','largo'=>10,'not_null'=>true,'def'=>'A'));
/*
  basado_en_extraccion_calculo integer,
  basado_en_extraccion_muestra integer,
  para_rellenado_de_base boolean NOT NULL DEFAULT false,
  grupo_raiz character varying(9),
  rellenante_de integer,
  */
        }
    function campos_a_mostrar_en_lista_opciones(){
        return array('calculo');
    }
}    
?>