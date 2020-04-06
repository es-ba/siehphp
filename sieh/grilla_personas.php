<?php
//UTF-8:SÍ
 require_once "lo_imprescindible.php";
 // require_once "tablas_planas.php";
 require_once "grilla.php";

class Grilla_personas extends Grilla_tabla{    
    function puede_insertar(){
        return tiene_rol('rrhh') || tiene_rol('suprrhh');
    }
    function puede_eliminar(){
        return tiene_rol('suprrhh');
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('rrhh')|| tiene_rol('suprrhh')){
            return   parent::campos_editables($filtro_para_lectura);
        }
        return $editables;
    }
}
?>