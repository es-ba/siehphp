<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_inconsistencias extends Vistas{
    function definicion_estructura(){
        foreach(nombres_campos_claves('', 'N') as $campo){
            $this->definir_campo("vis_$campo"             ,array('agrupa'=>true,'tipo'=>'entero','origen'=>"inc_$campo"));
        }
        $this->definir_campo('vis_comuna'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'));
        $this->definir_campo('vis_bolsa'                  ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'pla_bolsa'));
        $this->definir_campo('vis_con'                    ,array('detallar'=>true,'tipo'=>'entero','origen'=>'inc_con'));
        $this->definir_campo('vis_cant_errores'           ,array('operacion'=>'cuenta_true','origen'=>"con_gravedad='error'",'title'=>'cantidad inconsistencias con gravedad error'));
        $this->definir_campo('vis_cant_adv_sin_justificar',array('operacion'=>'cuenta_true','origen'=>"con_gravedad<>'error' and (inc_justificacion is null or trim(inc_justificacion)='')"));
        $this->definir_campo('vis_cant_adv_justificadas'  ,array('operacion'=>'cuenta_true','origen'=>"con_gravedad<>'error' and trim(inc_justificacion)<>''"));
        $this->definir_campo('vis_justificacion'          ,array('detallar'=>true,'tipo'=>'entero','origen'=>'inc_justificacion'));
    }
    function clausula_from(){
        global $implode_nombres_campos_claves;
        $ands=str_replace(' and pla_enc=0','',$implode_nombres_campos_claves(' and pla_@=0','N'));
        return "inconsistencias inner join consistencias on con_ope=inc_ope and con_con=inc_con inner join plana_tem_ on pla_enc=inc_enc {$ands} ";
    }
    /*
    function clausula_where_agregada(){
        return " and con_momento='Procesamiento' ";
    }
    */
    function puede_detallar(){
        return true;
    }   
}

?>