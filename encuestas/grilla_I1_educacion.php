<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_I1_educacion extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }
    function campos_editables($filtro_para_lectura){
        return array(
            'pla_e8d_esp',
            'pla_e10e_cuales',
            'pla_e10e_cuales',
            'pla_e10e_esp',
            'pla_e10g_esp', 
            'pla_e11_esp',
            'pla_e14c_cual', 
            'pla_e14c_esp', 
            'pla_e15b_esp',        
            'pla_e14c_cual',
            'pla_e11_cuales',  
            'pla_e10g_cual',            
        );        
    }    
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){        
        return array('pla_enc', 'pla_hog','pla_mie','s1_p_estado',
                     's1_p_bolsa','s1_p_cod_anacon',
                     's1_p_edad','s1_p_f_nac_o',
                     'pla_e8d_1','pla_e8d_2','pla_e8d_3','pla_e8d_4','pla_e8d_5','pla_e8d_6',
                     'pla_e8d_7','pla_e8d_8','pla_e8d_9','pla_e8d_10','pla_e8d_1a',  
                     'pla_e10c', 'pla_e10d_edad', 'pla_e10d_anios', 'pla_e10e2',
                     'pla_e10e_1','pla_e10e_18','pla_e10e_19','pla_e10e_20','pla_e10e_16',
                     'pla_e10e_17','pla_e10e_cuales','pla_e10e_4','pla_e10e_5','pla_e10e_6',
                     'pla_e10e_7','pla_e10e_8','pla_e10e_10','pla_e10e_11','pla_e10e_12',
                     'pla_e10e_13','pla_e10e_14','pla_e10e_15','pla_e10e_esp',
                     'pla_e10g_cual', 'pla_e10g_esp', 'pla_e8d_esp', 'pla_e9_edad', 'pla_e9_anio', 'pla_e12', 'pla_e14',
                     'pla_e11_1','pla_e11_18','pla_e11_19','pla_e11_20','pla_e11_16','pla_e11_17',
                     'pla_e11_cuales','pla_e11_4','pla_e11_5','pla_e11_6','pla_e11_7','pla_e11_8',
                     'pla_e11_10','pla_e11_11','pla_e11_12','pla_e11_13','pla_e11_14','pla_e11_15',
                     'pla_e11_esp','pla_e11a','pla_e14c_cual', 'pla_e14c_esp', 
                     'pla_e14c_1','pla_e14c_2','pla_e14c_3','pla_e14c_4','pla_e14c_6',
                     'pla_e14c_5','pla_e15b_1','pla_e15b_9','pla_e15b_2','pla_e15b_3',
                     'pla_e15b_4','pla_e15b_7', 'pla_e15b_8','pla_e15b_5','pla_e15b_esp');
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }    
}
?>