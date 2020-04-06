<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_I1_vida_cotidiana extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_solo_lectura(){
        return $this->campos_a_listar(array());
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){        
        return array('pla_enc', 'pla_hog','pla_mie','s1_p_estado',
                     's1_p_bolsa','s1_p_cod_anacon',
                     'pla_vc1_1','pla_vc1_2','pla_vc1_3','pla_vc1_4','pla_vc1_5','pla_vc1_6','pla_vc1_7',
                     'pla_vc2_1','pla_vc2_2','pla_vc3_1','pla_vc3_2','pla_vc4_1','pla_vc4_2','pla_vc5_1',
                     'pla_vc5_2','pla_vc6_1','pla_vc6_2','pla_vc7_1','pla_vc7_2','pla_vc7_3','pla_vc7_4',
                     'pla_vc7_5','pla_vc8_1','pla_vc8_2','pla_vc9_1','pla_vc9_2','pla_vc10_1','pla_vc10_2',
                     'pla_vc11','pla_vc12_1','pla_vc12_2','pla_vc13','pla_vc14_1','pla_vc14_2','pla_vc15',
                     'pla_vc16_2','pla_vc16_1'
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