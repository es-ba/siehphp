<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_variables extends Grilla_tabla{
    function campos_editables($filtro_para_lectura){
        global $revisando_metadatos;
        if(!$revisando_metadatos){
            return array();
        }
        return true;
        //return array(/*'var_texto','var_aclaracion',*/'var_maximo','var_minimo','var_advertencia_sup','var_advertencia_inf','var_nombre_dr');
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
        if($fila['var_desp_nombre']===''){
            $atributos_fila['var_desp_nombre']['clase']='valor_empty_string'; 
        }
    }
    function responder_detallar(){
        return false;
    }   
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('var_var'));
    }
    function puede_insertar(){
        return tiene_rol('dis_con') || tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('dis_con') || tiene_rol('procesamiento');
    }
}
?>