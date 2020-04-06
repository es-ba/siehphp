<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_control_muestra extends Vistas{
    function definicion_estructura(){
        $condicion_rea="coalesce(pla_rea_recu,pla_rea_enc) in (1,3)";
        $condicion_no_rea="not ($condicion_rea)";
        $condicion_razon_enc_789 = "pla_razon_enc between 70 and 99";
        $condicion_razon_recu_789 = "pla_razon_recu between 70 and 99";
        $rea_ing ="((select max(plana_ajh1_.pla_rea) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc)=1)";
        $hogares_tem="(coalesce(plana_tem_.pla_nhogares,plana_tem_.pla_nhogares_recu::integer))";
        $hogares_ing_cant ="(select count(plana_ajh1_.pla_totalh) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc)";
        $hogares_ing_max  ="(select max(plana_ajh1_.pla_totalh)   from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc)";
        $hogares_ing_min  ="(select min(plana_ajh1_.pla_totalh)   from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc)";
        $miembros_tem     ="coalesce(plana_tem_.pla_nmiembros, plana_tem_.pla_nmiembros_recu::integer)";
        $miembros_ing_ult ="(select   max(plana_ajh1_m.pla_mie) from plana_ajh1_m where plana_ajh1_m.pla_enc = plana_tem_.pla_enc)"; // queda:mie info para consistencias
        $miembros_ing_cant="(select count(plana_ajh1_m.pla_mie) from plana_ajh1_m where plana_ajh1_m.pla_enc = plana_tem_.pla_enc)"; // queda:mie info para consistencias
        $vis_error_tem_hogares ="$condicion_rea and ( $hogares_ing_cant is distinct from $hogares_tem or $hogares_ing_min is distinct from $hogares_tem or $hogares_ing_max is distinct from $hogares_tem)";
        $vis_error_tem_miembros="$condicion_rea and ( $miembros_ing_ult is distinct from $miembros_tem or $miembros_ing_cant is distinct from $miembros_tem )";
        $this->definir_campo('vis_comuna'                       ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'));
        $this->definir_campo('vis_up'                           ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up_comuna'));
        $this->definir_campo('vis_lote'                         ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_lote'));
        $this->definir_campo('vis_total'                        ,array('operacion'=>'cuenta','origen'=>'pla_enc','title'=>'Cantidad de viviendas en el lote'));
        $this->definir_campo('vis_bolsa'                        ,array('detallar'=>true,'tipo'=>'entero','origen'=>'pla_bolsa'));
        $this->definir_campo('vis_enc'                          ,array('detallar'=>true,'tipo'=>'entero','origen'=>'pla_enc'));
        $this->definir_campo('vis_total_rea'                    ,array('operacion'=>'cuenta_true','origen'=>"$condicion_rea"));
        $this->definir_campo('vis_total_norea_789_no_confirmado',array('operacion'=>'cuenta_true','origen'=>"$condicion_no_rea and $condicion_razon_enc_789 and pla_razon_recu is null"));
        $this->definir_campo('vis_total_norea_789_confirmado'   ,array('operacion'=>'cuenta_true','origen'=>"$condicion_no_rea and $condicion_razon_recu_789"));
        $this->definir_campo('vis_total_10789'                  ,array('operacion'=>'cuenta_true','origen'=>"$condicion_rea or ($condicion_no_rea and $condicion_razon_enc_789 or $condicion_razon_recu_789)"));
        $this->definir_campo('vis_no_encuestadas'               ,array('operacion'=>'cuenta_true','origen'=>"$condicion_no_rea and pla_razon_enc between 1 and 69 or pla_razon_recu between 1 and 69"));
        $this->definir_campo('vis_error_tem_hogares'            ,array('operacion'=>'cuenta_true','origen'=>"$condicion_rea and ((select count(plana_ajh1_.pla_totalh) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc) is distinct from (coalesce(plana_tem_.pla_nhogares,plana_tem_.pla_nhogares_recu::integer))) or	((select min(plana_ajh1_.pla_totalh) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc) is distinct from (coalesce(plana_tem_.pla_nhogares,plana_tem_.pla_nhogares_recu::integer))) or ((select max(plana_ajh1_.pla_totalh) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc) is distinct from (coalesce(plana_tem_.pla_nhogares,plana_tem_.pla_nhogares_recu::integer)))"));
        $this->definir_campo('vis_error_tem_miembros'           ,array('operacion'=>'cuenta_true','origen'=>"$condicion_rea and ((select sum(plana_ajh1_.pla_enc) from plana_ajh1_ where plana_ajh1_.pla_enc = plana_tem_.pla_enc) is distinct from (coalesce(plana_tem_.pla_nmiembros, plana_tem_.pla_nmiembros_recu::integer)))"));
        $this->definir_campo('vis_error_tem_rea_vs_ing'         ,array('operacion'=>'cuenta_true','origen'=>"$condicion_rea is distinct from $rea_ing"));
        $this->definir_campo('vis_tiene_error'                  ,array('detallar'=>true,'tipo'=>'entero','origen'=>"case when $vis_error_tem_hogares or $vis_error_tem_miembros or ($condicion_rea is distinct from $rea_ing) then 1 else 0 end",'tipo'=>'entero'));
        $this->definir_campo('vis_hogares_ing_cant'             ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$hogares_ing_cant" ,'tipo'=>'entero'));
        $this->definir_campo('vis_hogares_ing_max'              ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$hogares_ing_max"  ,'tipo'=>'entero'));
        $this->definir_campo('vis_hogares_ing_min'              ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$hogares_ing_min"  ,'tipo'=>'entero'));
        $this->definir_campo('vis_miembros_tem'                 ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$miembros_tem"     ,'tipo'=>'entero'));
        $this->definir_campo('vis_miembros_ing_ult'             ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$miembros_ing_ult" ,'tipo'=>'entero'));
        $this->definir_campo('vis_miembros_ing_cant'            ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$miembros_ing_cant",'tipo'=>'entero'));
        $this->definir_campo('vis_rea_ing'                      ,array('detallar'=>true,'tipo'=>'entero','origen'=>"$rea_ing"));
    }                                                                                                               
    function clausula_from(){
        return "plana_tem_";
    }
    function puede_detallar(){
        return true;
    }
}

?>