<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_dictra extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="dictra";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_dictra");
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='dictra_des';
            $editables[]='dictra_ori';
            $editables[]='dictra_texto';
        }
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('tematica');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function cantidadColumnasFijas(){
        return 2;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('dictra_dic', 'dictra_ori', 'dictra_des', 'dictra_texto');
    }
}
?>