<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_variables_controlar_consistencias extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('var_ope'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_ope'));
        $this->definir_campo('var_for'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_for'));
        $this->definir_campo('var_mat'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_mat'));
        $this->definir_campo('var_var'                    ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_var'));
        $this->definir_campo('var_tipovar'                ,array('agrupa'=>true,'tipo'=>'texto','origen'=>'var_tipovar'));
        $this->definir_campo('var_cant_valores',array('operacion'=>'cuenta_true','origen'=>"res_valor is not null"));
        $this->definir_campo('var_valores'     ,array('operacion'=>'concato_unico','origen'=>"res_valor"));
        $this->definir_campo('var_cant_nsnc'   ,array('operacion'=>'cuenta_true','origen'=>"res_valesp='//'"));
        $this->definir_campo('var_omitidas'    ,array('operacion'=>'cuenta_true','origen'=>"res_valesp='--'"));
        $this->definir_campo('var_ej_enc'      ,array('operacion'=>'min','origen'=>"case when res_valor is not null then res_enc else null end"));
    }
    function clausula_from(){
        return "variables inner join respuestas on res_ope=var_ope and res_for=var_for and res_mat=var_mat and res_var=var_var";
    }
    function clausula_where_agregada(){
        return " and var_for<>'TEM' ";
    }
}

?>