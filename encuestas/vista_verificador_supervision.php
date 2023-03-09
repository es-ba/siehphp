<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_verificador_supervision extends Vistas{
    /*
    function __construct(){
        parent::__construct();
    }
    */
    function definicion_estructura(){
        $this->definir_campo('vis_enc'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'rs.res_enc'));
        $this->definir_campo('vis_variable'           ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'vs.var_var'));
        $this->definir_campo('vis_nombre_variable'    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'coalesce(vs.var_texto,pr.pre_texto)'));
        $this->definir_campo('vis_valor_ingresado'    ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'coalesce(ri.res_valor,ri.res_valesp,ri.res_valor_con_error)'));
        $this->definir_campo('vis_valor_supervisado'  ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'coalesce(rs.res_valor,rs.res_valesp,rs.res_valor_con_error)'));
        $this->definir_campo('vis_ok'                 ,array('agrupa'=>true,'tipo'=>'logico','origen'=>'case when vs.var_nombre_dr is null then null when coalesce(ri.res_valor,ri.res_valesp,ri.res_valor_con_error) is not distinct from coalesce(rs.res_valor,rs.res_valesp,rs.res_valor_con_error) then true else false end'));        
        $this->definir_campo('varord_orden_total'     ,array('agrupa'=>true,'tipo'=>'logico','origen'=>'varord_orden_total'));        
        $this->definir_campos_orden('varord_orden_total');
    }
    function clausula_from(){
        $var_considerar=substr($GLOBALS['NOMBRE_APP'],0,3)=='vcm'?"'cr_num_miembro'":"'respond'";
        return "respuestas rs 
               inner join variables vs on rs.res_var=vs.var_var and rs.res_ope=vs.var_ope and rs.res_for=vs.var_for
               inner join preguntas pr on vs.var_pre=pr.pre_pre and vs.var_ope=pr.pre_ope and vs.var_for=pr.pre_for               
               inner join var_orden vo on vo.varord_var=vs.var_var and vo.varord_ope=vs.var_ope
               left join variables vi on vi.var_ope=vs.var_ope and vi.var_var=vs.var_nombre_dr
               left join matrices on mat_ope=vi.var_ope and mat_for=vi.var_for and mat_mat=vi.var_mat
               left join respuestas rs1 on rs1.res_ope=rs.res_ope and rs1.res_for='S1' and rs1.res_mat='' 
                    and rs1.res_enc=rs.res_enc and rs1.res_hog=rs.res_hog and rs1.res_var={$var_considerar} and rs1.res_mie=0 and rs1.res_exm=0
               left join respuestas ri on rs.res_ope=ri.res_ope and vi.var_for=ri.res_for and vi.var_mat=ri.res_mat
                    and rs.res_enc=ri.res_enc and rs.res_hog=ri.res_hog 
                    and vs.var_nombre_dr=ri.res_var and case when mat_ua='mie' then rs1.res_valor::integer else 0 end=ri.res_mie ";
    }
    function clausula_where_agregada(){
        return " 
            and rs.res_ope='{$GLOBALS['nombre_app']}'
            and rs.res_for='SUP'
            and rs.res_mat='' ";        
    }
}

?>