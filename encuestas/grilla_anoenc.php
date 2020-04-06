<?php
//UTF-8:SÍ 
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_anoenc extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="anoenc";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_anoenc");
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('anoenc_ope', 'anoenc_enc');
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
            'anoenc_anoenc',
            'anoenc_rol',
            'anoenc_per',
            'anoenc_usu',
            'anoenc_fecha',
            'anoenc_hora',
        );
        return $campos_solo_lectura;
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('ana_con') || tiene_rol('recepcionista') || tiene_rol('ingresador') || tiene_rol('ana_campo') || tiene_rol('dis_con');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('ana_con') || tiene_rol('recepcionista') || tiene_rol('ingresador');
    }
}
?>