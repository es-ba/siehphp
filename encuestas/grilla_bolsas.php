<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_bolsas extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="bolsas";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_bolsas");
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'bol_ope',
        );
        return $campos_solo_lectura;
    }
    function campos_editables($filtro_para_lectura){
        $editables=array('bol_bol','bol_cerrada','bol_rea','bol_activa');
        if(tiene_rol('procesamiento')){ // lo controla por su rol, su rol secundario, o roles delegados
            $editables=array('bol_revisada');
        }
        return $editables;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('bol_ope','bol_tlg');
    }
    function permite_grilla_sin_filtro(){
        if(tiene_rol('procesamiento')){
            return true;
        }else{
            return false;
        }
    }
    function puede_insertar(){
        if (tiene_rol('procesamiento')){
            return true;
        }
        return false;
    }
}
?>