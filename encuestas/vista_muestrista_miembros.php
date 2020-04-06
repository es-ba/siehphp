<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";

class Vista_muestrista_miembros extends Vistas{
    function definicion_estructura(){
    $this->definir_campo('vis_polifiscalias_zona'     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_polifiscalias_zona'));
    $this->definir_campo('vis_up'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_up'));$this->definir_campo('vis_comuna'                 ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_comuna'));
    $this->definir_campo('vis_frac_comun'             ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_frac_comun'));
    $this->definir_campo('vis_radio_comu'             ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_radio_comu'));
    $this->definir_campo('vis_mza_comuna'             ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'pla_mza_comuna'));
    $this->definir_campo('vis_bolsa'                  ,array('agrupa'=>true,'tipo'=>'texto', 'origen'=>'pla_bolsa'));
    foreach(nombres_campos_claves('', 'N') as $campo){
        $this->definir_campo("vis_$campo"             ,array('agrupa'=>true,'tipo'=>'entero','origen'=>($campo=='enc'?'t':'m').".pla_$campo"));
    }
    $this->definir_campo('vis_p2'                     ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'m.pla_p2'));
    $this->definir_campo('vis_p3_b'                   ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'m.pla_p3_b'));    
    $this->definir_campo('vis_seleccionado'           ,array('agrupa'=>true,'tipo'=>'entero','origen'=>'(case h.pla_respondente_num=m.pla_mie when true then 1 else 0 end)')); //queda:mie es el respondente
    }    
    function clausula_from(){
        return "plana_tem_ t inner join plana_ajh1_ h on t.pla_enc=h.pla_enc inner join plana_ajh1_m m on t.pla_enc=m.pla_enc and h.pla_hog=m.pla_hog ";
    }
    function puede_detallar(){
        return false;
    }
}
?>