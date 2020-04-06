<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_variables_consistencias extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('varcon_ope' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'var_ope'));
        $this->definir_campo('varcon_con' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'varcon_con'));
        $this->definir_campo('varcon_var' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'vars[1]'));
        //$this->definir_campo('varcon_texto' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'varcon_texto'));
        $this->definir_campo('varcon_texto' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'var_texto'));
        $this->definir_campo('varcon_for' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'var_for'));
        $this->definir_campo('varcon_mat' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'var_mat'));
        $this->definir_campo('varcon_orden' ,array('agrupa'=>true, 'tipo'=>'texto','origen'=>'var_orden'));
        $this->definir_campo('varcon_nsnc_atipico' ,array('agrupa'=>true, 'tipo'=>'entero','origen'=>'var_nsnc_atipico'));
        $this->definir_campo('varcon_maximo' ,array('agrupa'=>true, 'tipo'=>'entero','origen'=>'var_maximo'));
        $this->definir_campo('varcon_minimo' ,array('agrupa'=>true, 'tipo'=>'entero','origen'=>'var_minimo'));
        $this->definir_campo('varcon_advertencia_sup' ,array('agrupa'=>true, 'tipo'=>'entero','origen'=>'var_advertencia_sup'));
        $this->definir_campo('varcon_advertencia_inf' ,array('agrupa'=>true, 'tipo'=>'entero','origen'=>'var_advertencia_inf'));
    }
    function clausula_from(){
        return "(SELECT DISTINCT consistencias.con_con AS varcon_con, regexp_matches(lower((COALESCE(consistencias.con_precondicion, ''::character varying)::text || ' '::text) || COALESCE(consistencias.con_postcondicion, ''::character varying)::text), '([A-Za-z][A-Za-z0-9_]*)(?![A-Za-z0-9_]|[.(])'::text, 'g'::text) AS vars FROM consistencias) x LEFT JOIN variables v ON x.vars[1] = v.var_var::text";
    }
    function clausula_where_agregada(){
        return " and x.vars[1] <> ALL (ARRAY['or'::text, 'and'::text])";
    }
    function puede_detallar(){
        return true;
    }
}

?>