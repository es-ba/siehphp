<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_I1_tip extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_editables($filtro_para_lectura){
        return array(
            'pla_tip4_pcia',
            'pla_tip4_pais',  
            'pla_tip10_pcia',
            'pla_tip10_pais',  
            'pla_tip14_esp',            
        );
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){        
        return array('pla_enc', 'pla_hog','pla_mie','s1_p_estado',
                     's1_p_bolsa','s1_p_cod_anacon',
                     'pla_tip1','pla_tip2','pla_tip3','pla_tip3_9','pla_tip4','pla_tip4_pcia',
                     'pla_tip4_pais','pla_tip8','pla_tip8_esp','pla_tip10','pla_tip10_pcia',
                     'pla_tip10_pais','pla_tip14','pla_tip14_esp');
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }    
}
?>