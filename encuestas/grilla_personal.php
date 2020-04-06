<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_personal extends Grilla_tabla{
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='per_ope';
        $heredados[]='per_per';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function responder_detallar(){
        return false;
    }   
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('per_per'));
    }
    function puede_eliminar(){
        return tiene_rol('programador')||tiene_rol('subcoor_campo')||tiene_rol('ana_campo');
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador')||tiene_rol('subcoor_campo')||tiene_rol('ana_campo')){
            $editables[]='per_apellido';
            $editables[]='per_nombre';
            $editables[]='per_cuit';
            $editables[]='per_rol';
            $editables[]='per_dominio';
            $editables[]='per_comuna';
            $editables[]='per_activo';
            $editables[]='per_usu';
        };
        if(tiene_rol('procesamiento')){
            $editables[]='per_activo';
            $editables[]='per_usu';
        };
        return $editables;
    }
}
?>