<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_dispositivos extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dis');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dis_tipodis', array('hereda'=>'tipo_dispositivo','modo'=>'pk','campo_relacionado'=>'tds_tds','def'=>'ipad'));
        $this->definir_campo('dis_dis', array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('dis_ip', array('tipo'=>'texto'));
        $this->definir_campo('dis_os', array('tipo'=>'texto'));
        $this->definir_campo('dis_observaciones', array('tipo'=>'texto'));
        $this->definir_campo('dis_nro_serie', array('tipo'=>'texto'));
        $this->definir_campo('dis_ficha_estante', array('tipo'=>'texto'));
        $this->definir_campo('dis_imei', array('tipo'=>'texto'));
        $this->definir_campo('dis_tenencia_operativo', array('hereda'=>'tenencia_operativo','modo'=>'fk_optativa','campo_relacionado'=>'tenope_tenope'));
        $this->definir_campo('dis_responsable', array('tipo'=>'texto'));
        $this->definir_campo('dis_fecha_entrega', array('tipo'=>'timestamp'));
        $this->definir_campo('dis_fecha_devolucion', array('tipo'=>'timestamp'));
        $this->definir_campo('dis_chip', array('hereda'=>'chips','modo'=>'fk_optativa','campo_relacionado'=>'chip_chip'));
        $this->definir_campo('dis_fecha_chip_carga', array('tipo'=>'timestamp'));
        $this->definir_campo('dis_fecha_chip_descarga', array('tipo'=>'timestamp'));
    }
}    

class Grilla_dispositivos extends Grilla_tabla{
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