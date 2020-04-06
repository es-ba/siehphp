<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_modificaciones extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_tabla'                    ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_tabla'));
        $this->definir_campo('vis_operacion'                  ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_operacion'));
        $this->definir_campo('vis_pk'                 ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_pk'));
        $this->definir_campo('vis_campo'                    ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_campo'));
        $this->definir_campo('vis_actual'                     ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_actual'));
        $this->definir_campo('vis_anterior'                ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'mdf_anterior'));
        $this->definir_campo('vis_fecha'                     ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'tlg_momento'));
        $this->definir_campo('vis_usuario'                     ,array('agrupa'=>false,'tipo'=>'texto','origen'=>'ses_usu'));
        $this->definir_campos_orden(array('tlg_momento'));
    }   
    function clausula_from(){
        return "his.modificaciones join rrhh.tiempo_logico on tlg_tlg = mdf_tlg join rrhh.sesiones on tlg_ses=ses_ses";
    }
    // function clausula_where_agregada(){
        // return " and tlg_momento>=current_timestamp-interval '1 month' ";        
    // }
}

?>