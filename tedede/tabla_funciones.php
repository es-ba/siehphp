<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_funciones extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('fun');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('fun_fun',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true)); 
        $this->definir_campo('fun_esq',array('hereda'=>'esquema','modo'=>'pk'));
        $this->definir_campo('fun_para_text',array('tipo'=>'texto','largo'=>50,'not_null'=>true)); 
        $this->definir_campo('fun_publica',array('tipo'=>'logico')); 
        $this->definir_campo('fun_tipo_devuelto',array('tipo'=>'texto')); 
        $this->definir_campo('fun_cuerpo',array('tipo'=>'texto')); 
        $this->definir_campo('fun_nombre',array('tipo'=>'texto')); 
        $this->definir_campo('fun_descripcion',array('tipo'=>'texto')); 
        $this->definir_campo('fun_version_js',array('tipo'=>'texto')); 
        $this->definir_campo('fun_instalado_db',array('tipo'=>'fecha')); 
    }
}
?>