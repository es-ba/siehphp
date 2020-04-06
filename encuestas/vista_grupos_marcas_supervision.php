<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_grupos_marcas_supervision extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_corrida'               ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'res_tlg'));
        $this->definir_campo('vis_comuna'                ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'));
        $this->definir_campo('vis_enc'                   ,array('detallar'=>true,'tipo'=>'entero','origen'=>'res_enc'));
        $this->definir_campo('vis_cant_considerados'     ,array('operacion'=>'cuenta','origen'=>'res_valor','title'=>'que fueron marcadas para supervisar o no supervisar'));
        $this->definir_campo('vis_cant_sup_campo'        ,array('operacion'=>'cuenta_true','origen'=>"res_valor='1'"));
        $this->definir_campo('vis_cant_sup_telef'        ,array('operacion'=>'cuenta_true','origen'=>"res_valor='2'"));
        $this->definir_campo('vis_cant_no_sup'           ,array('operacion'=>'cuenta_true','origen'=>"res_valor='0'"));
        $this->definir_campo('vis_momento'               ,array('operacion'=>'min','origen'=>"tlg_momento"));
    }
    function clausula_from(){
        global $implode_nombres_campos_claves;
        return "respuestas inner join tiempo_logico on tlg_tlg=res_tlg inner join plana_tem_ on {$implode_nombres_campos_claves('pla_@=res_@ and ','N')}true";
    }
    function clausula_where_agregada(){
        return " and res_ope='{$GLOBALS['NOMBRE_APP']}' and res_for='TEM' and res_mat='' and {$implode_nombres_campos_claves('res_@=0 and ','N~enc')} res_var='sup_campo' and res_valor is not null";
    }
    function puede_detallar(){
        return true;
    }
}

?>