<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_TEM.php";
// require_once "grilla_up.php";

class Grilla_viviendas_para_el_muestrista extends Grilla_TEM{
    function __construct(){
        parent::__construct();
    }
    
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('TEM_');
    }
    function permite_grilla_sin_filtro(){
        return true;    
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array(
            'pla_comuna', 
            'pla_replica', 
            'pla_up', 
            'pla_enc', 
            'pla_estado',
            'pla_rea', 
            'pla_norea', 
            'pla_hog_pre', 
            'pla_hog_tot', 
            'pla_pob_pre', 
            'pla_pob_tot'
        ), $this->filtrar_campos_del_operativo(array( 
            'pla_pob_res'
        )), array( 
            'pla_cnombre', 
            'pla_hn', 
            'pla_hp', 
            'pla_hd'
        ), $this->filtrar_campos_del_operativo(array(   
            'pla_h2_6'
        )),array(     
            'pla_obs'
        ));  
    }
    function campos_editables($filtro_para_lectura){        
        return array();
    }
}
?>