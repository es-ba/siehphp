<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_his_inconsistencias extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="his_inconsistencias";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_his_inconsistencias");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function campos_a_excluir($filtro_para_lectura){
        return array(
            'hisinc_ope',
            'hisinc_tlg',
        );
    }
    function permite_grilla_con_este_filtro($o_con_este_filtro){
        unset($o_con_este_filtro['hisinc_ope']);
        if(count($o_con_este_filtro)==0){
            return false;
        }
        return parent::permite_grilla_con_este_filtro($o_con_este_filtro);
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function responder_detallar(){
        return false;
    }
    function puede_detallar(){
        return false;
    }
}
?>