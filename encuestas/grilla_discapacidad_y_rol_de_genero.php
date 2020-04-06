<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_discapacidad_y_rol_de_genero extends Grilla_respuestas_para_proc_ind{
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
                     'pla_d2_1','pla_d2_2','pla_d2_3','pla_d2_4','pla_d2_5','pla_d2_6',
                     'pla_d2_7','pla_d2_otra', 'pla_rg11','pla_rg11_esp','pla_rg12','pla_rg12_esp');
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }    
}
?>