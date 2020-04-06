<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_temas extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="temas";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_temas");
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='tem_ope';
            $editables[]='tem_tem';
        }
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function campos_a_listar($filtro_para_lectura){
        return array('tem_ope',
                     'tem_tem'); 
    }
}
?>