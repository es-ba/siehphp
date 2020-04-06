<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";
require_once "grilla_TEM.php";

class Grilla_I1_sm extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_editables($filtro_para_lectura){
        return array(
            'pla_sm10a_esp',
            'pla_sm13_esp',        
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
        return array('pla_enc', 'pla_hog','pla_mie','s1_p_estado','s1_p_bolsa','s1_p_cod_anacon',
                     'pla_sm4', 'pla_sm5', 'pla_sm6', 'pla_sm6a', 'pla_sm7_anio', 'pla_sm7_mes', 
                     'pla_sm9', 'pla_sm10a_1', 'pla_sm10a_2', 'pla_sm10a_3', 'pla_sm10a_4', 'pla_sm10a_5',
                     'pla_sm10a_6','pla_sm10a_7','pla_sm10a_8','pla_sm10a_9','pla_sm10a_10',
                     'pla_sm10a_esp', 'pla_sm10b', 'pla_sm11', 'pla_sm13', 'pla_sm13_esp', 'pla_sm15', 'pla_sm17', 'pla_sm18'
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
