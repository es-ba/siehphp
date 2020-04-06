<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_baspro extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="baspro";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_baspro");
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='baspro_ope';
            $editables[]='baspro_baspro';
            $editables[]='baspro_nombre';
            $editables[]='baspro_cambiar_especiales';
            $editables[]='baspro_cambiar_nsnc_por';
            $editables[]='baspro_cambiar_sindato_por';
            $editables[]='baspro_cambiar_null_por';
            $editables[]='baspro_sin_pk';
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
        return array(  'baspro_ope',
                       'baspro_baspro',
                       'baspro_nombre',
                       'baspro_cambiar_especiales',
                       'baspro_cambiar_nsnc_por',               
                       'baspro_cambiar_sindato_por',
                       'baspro_cambiar_null_por',
                       'baspro_sin_pk'); 
    }
}
?>