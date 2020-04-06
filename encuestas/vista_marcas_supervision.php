<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_marcas_supervision extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_corrida'               ,array('tipo'=>'entero','origen'=>'res_tlg'));
        $this->definir_campo('vis_comuna'                ,array('tipo'=>'entero','origen'=>'pla_comuna'));
        $this->definir_campo('vis_cant_considerados'     ,array('origen'=>'res_valor','title'=>'que fueron marcadas para supervisar o no supervisar'));
        $this->definir_campo('vis_cant_sup_campo'        ,array('origen'=>"res_valor='1'"));
        $this->definir_campo('vis_cant_sup_telef'        ,array('origen'=>"res_valor='2'"));
        $this->definir_campo('vis_cant_no_sup'           ,array('origen'=>"res_valor='0'"));
        $this->definir_campo('vis_momento'               ,array('origen'=>"tlg_momento"));
    }
    function clausula_from(){
        global $implode_nombres_campos_claves;
        return "respuestas inner join tiempo_logico on tlg_tlg=res_tlg inner join plana_tem_ on {$implode_nombres_campos_claves('pla_@=res_@ and ','N')} true";
    }
    function clausula_where_agregada(){
        global $implode_nombres_campos_claves;
        return " and res_ope='{$GLOBALS['NOMBRE_APP']}' and res_for='TEM' and res_mat='' {$implode_nombres_campos_claves(' and pla_@=0','N')} and res_var='sup_campo' and res_valor is not null";
    }
}

?>