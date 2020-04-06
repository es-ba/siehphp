<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_varmae extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('varmae_ope' ,array('tipo'=>'texto','origen'=>'a.varmae_ope'));
        $this->definir_campo('varmae_var' ,array('tipo'=>'texto','origen'=>'a.varmae_var'));
        $this->definir_campo('varmae_tabdef' ,array('tipo'=>'texto','origen'=>'a.varmae_tabdef'));
        $this->definir_campo('varmae_sufijodest' ,array('tipo'=>'texto','origen'=>'a.varmae_sufijodest'));
        $this->definir_campos_orden(array('a.varmae_ope','a.varmae_var'));
    }
    function clausula_from(){
        return <<<SQL
        (select var_ope varmae_ope, var_var varmae_var, 'variables' varmae_tabdef, var_for||'_'||var_mat  as varmae_sufijodest
            from encu.variables
         union select varcal_ope varmae_ope, varcal_varcal varmae_var, 'varcal' varmae_tabdef,
                case when varcal_destino='mie' then  'I1_' when varcal_destino='per' then 'S1_P' else  'S1_' end  varmae_sufijodest
            from encu.varcal
            where varcal_activa= true and varcal_valida=true) a
SQL;
    }
    function puede_detallar(){
        return false;
    }
}

?>