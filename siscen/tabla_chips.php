<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_chips extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('chip');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('chip_chip', array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('chip_marca', array('es_pk'=>true,'tipo'=>'texto'));
        $this->definir_campo('chip_modelo', array('tipo'=>'texto'));
        $this->definir_campo('chip_telefono', array('tipo'=>'texto'));
        $this->definir_campo('chip_sim', array('tipo'=>'texto'));
        $this->definir_campo('chip_puk_act', array('tipo'=>'bentero'));
        $this->definir_campo('chip_tenencia_operativo', array('hereda'=>'tenencia_operativo','modo'=>'fk_optativa','campo_relacionado'=>'tenope_tenope'));
        $this->definir_campo('chip_responsable', array('tipo'=>'texto'));
        $this->definir_campo('chip_observaciones', array('tipo'=>'texto'));       
        $this->definir_campo('chip_fecha_entrega', array('tipo'=>'timestamp'));
        $this->definir_campo('chip_fecha_devolucion', array('tipo'=>'timestamp'));      
    }
}    

class Grilla_chips extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('mues_campo') || tiene_rol('programador') ){
                $editables=$this->campos_a_listar($filtro_para_lectura);
            };
        return $editables;
    }     
    function puede_insertar(){
        return tiene_rol('mues_campo') || tiene_rol('programador');
    }
    function puede_eliminar(){
        return tiene_rol('mues_campo');
    }
}

?>