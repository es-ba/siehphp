<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_modificaciones extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('mdf');
        $this->heredar_en_cascada=false;
        $this->con_campos_auditoria=false;
        $this->definir_esquema('his');
        $this->definir_campo('mdf_mdf',array('es_pk'=>true,'tipo'=>'serial'));
        $this->definir_campo('mdf_tabla',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('mdf_operacion',array('tipo'=>'enumerado','elementos'=>array('U','D'),'largo'=>1));
        $this->definir_campo('mdf_pk',array('tipo'=>'texto','largo'=>2000));
        $this->definir_campo('mdf_campo',array('tipo'=>'texto','largo'=>2000));
        $this->definir_campo('mdf_actual',array('tipo'=>'texto'));
        $this->definir_campo('mdf_anterior',array('tipo'=>'texto'));
        $this->definir_campo('mdf_tlg',array('tipo'=>'entero','bytes'=>8));
        $this->definir_tablas_hijas(array('sesiones'=>false));
    }
}

?>