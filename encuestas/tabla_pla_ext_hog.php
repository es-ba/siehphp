<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_pla_ext_hog extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('pla');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('pla_ope',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('pla_enc',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('pla_hog',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('pla_modo',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'validart'=>'codigo'));
        $this->definir_campo('pla_fexp',array('tipo'=>'entero'));
        $this->definir_campo('pla_qipcf_2',array('tipo'=>'entero'));
        $this->definir_campo('pla_dipcf_2',array('tipo'=>'entero'));
        $this->definir_campo('pla_qitf_2',array('tipo'=>'entero'));
        $this->definir_campo('pla_ditf_2',array('tipo'=>'entero'));         
        $this->definir_campo('pla_qipcf',array('tipo'=>'entero'));
        $this->definir_campo('pla_dipcf',array('tipo'=>'entero'));
        $this->definir_campo('pla_qitf',array('tipo'=>'entero'));
        $this->definir_campo('pla_ditf',array('tipo'=>'entero'));
    }
}

?>