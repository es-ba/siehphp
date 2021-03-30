<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_S1 extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
    }
    function campos_editables($filtro_para_lectura){
        return array(
        'pla_telefono',
        'pla_movil',
        'pla_correo', 
        'pla_rmod',
        'pla_s1a1_obs',
        'pla_obs_grilla_s1'         
        );  
    }    
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){        
        return array_merge(array('pla_enc', 'pla_hog','tem_estado',
                     'tem_bolsa','tem_cod_anacon'),
          $this->filtrar_campos_del_operativo(array('pla_total_h','pla_telefono', 'pla_movil',  'pla_correo', 'pla_rmod','pla_s1a1_obs', 'pla_obs_grilla_s1' ))
        );
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    } 

}
?>