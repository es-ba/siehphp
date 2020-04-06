<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_control_ingreso extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_enc'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_enc'));
        $this->definir_campo('vis_bolsa'                  ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'pla_bolsa'));
        $this->definir_campo('vis_comuna'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'));
        $this->definir_campo('vis_rep'                    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_replica'));
        $this->definir_campo('vis_up'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up'));
        $this->definir_campo('vis_cnombre'                ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'pla_cnombre'));
        $this->definir_campo('vis_hn'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_hn'));
        $this->definir_campo('vis_hp'                     ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'pla_hp'));
    }
    function clausula_from(){
        return "plana_tem_";
    }
    function clausula_where_agregada(){
        return " and pla_comenzo_ingreso is not null ";        
    }
}

?>