<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_totales_por_estado extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('vis_estado'                 ,array('agrupa'=>true,'tipo'=>'entero', 'origen'=>'est_est'));
        $this->definir_campo('vis_nombre'                 ,array('agrupa'=>true,'tipo'=>'texto', 'origen'=>'est_nombre'));
        $this->definir_campo('vis_cantidad'               ,array('tipo'=>'entero','operacion'=>'cuenta','origen'=>'pla_enc','title'=>'Cantidad de encuestas'));
    }
    function clausula_from(){
        return "  encu.estados left join encu.plana_tem_  on est_est=pla_estado";
    }
}

?>