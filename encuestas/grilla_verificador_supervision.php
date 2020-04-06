<?php
//UTF-8:SÍ 
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_verificador_supervision extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="verificador_supervision";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("vista_verificador_supervision");
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('vis_enc', 'varord_orden_total');
    }    
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
             'vis_enc',              
             'vis_variable',
             'vis_nombre_variable',
             'vis_valor_ingresado',
             'vis_valor_supervisado'
        );
        return $campos_solo_lectura;
    }
}
?>