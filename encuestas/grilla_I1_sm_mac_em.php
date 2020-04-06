<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_I1_sm_mac_em extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_editables($filtro_para_lectura){
        return array(
            'pla_sn4_esp',
            'pla_sn5_esp',
            'pla_sn7_esp',
            'pla_sn14_esp',
            'pla_mac1_esp',
            'pla_mac3_esp'
        );        
    }    
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        return $heredados;
    }    
    function campos_a_listar($filtro_para_lectura){        
        return array('pla_enc', 'pla_hog','pla_mie','s1_p_estado','s1_p_bolsa', 's1_p_cod_anacon',
                     'pla_sn4','pla_sn4_esp','pla_sn5','pla_sn5_esp',
                     'pla_sn6','pla_sn6_cant','pla_sn7',
                     'pla_sn7_esp','pla_sn13','pla_sn13_otro',
                     'pla_sn14','pla_sn14_esp','pla_mac1',
                     'pla_mac1_esp','pla_mac2','pla_mac3_rit',
                     'pla_mac3_pas','pla_mac3_ovu','pla_mac3_pre',
                     'pla_mac3_espi','pla_mac3_dia','pla_mac3_otro',
                     'pla_mac3_esp','pla_em1','pla_em2','pla_em3'
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