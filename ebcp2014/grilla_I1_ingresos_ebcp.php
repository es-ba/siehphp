<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_ingresos_ebcp extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='s1_p_bolsa';
        $heredados[]='s1_p_estado';
        $heredados[]='s1_p_cod_anacon';
        $heredados[]='s1_p_fin_anacon';
        $heredados[]='s1_p_etapa_pro';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='s1_p_sexo';
        $heredados[]='s1_p_edad';
        $heredados[]='pla_t53_ing';
        $heredados[]='pla_t53_bis1';
        $heredados[]='pla_t53_bis1_sem';
        $heredados[]='pla_t53_bis1_mes';
        $heredados[]='pla_t53_bis2';
        $heredados[]='pla_t53c_anios';
        $heredados[]='pla_t53c_meses';
        $heredados[]='pla_t53c_98';
        $heredados[]='pla_i1';
        $heredados[]='pla_i2_totx';
        $heredados[]='pla_i2_ticx';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog','pla_mie',
        's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon','s1_p_fin_anacon','s1_p_etapa_pro',
        's1_p_sexo', 's1_p_edad',
        'pla_t53_ing', 'pla_t53_bis1', 'pla_t53_bis1_sem', 'pla_t53_bis1_mes', 'pla_t53_bis2', 'pla_t53c_anios','pla_t53c_meses','pla_t53c_98',
        'pla_i1', 'pla_i2_totx', 'pla_i2_ticx', 'pla_i3_1', 'pla_i3_1x', 'pla_i3_2', 'pla_i3_2x','pla_i3_3', 'pla_i3_3x', 'pla_i3_4', 'pla_i3_4x', 'pla_i3_5', 'pla_i3_5x', 
        'pla_i3_18', 'pla_i3_18x', 'pla_i3_7', 'pla_i3_7x', 'pla_i3_8', 'pla_i3_8x','pla_i3_11', 'pla_i3_11x', 'pla_i3_20', 'pla_i3_20x', 'pla_i3_6', 'pla_i3_6x', 
        'pla_i3_26', 'pla_i3_26x', 'pla_i3_13', 'pla_i3_13x', 'pla_i3_14', 'pla_i3_14x','pla_i3_40', 'pla_i3_40x', 'pla_i3_15', 'pla_i3_15x', 'pla_i3_24', 'pla_i3_24x',  
        'pla_i3_25', 'pla_i3_25x', 'pla_i3_17', 'pla_i3_17x', 'pla_i3_21', 'pla_i3_21x','pla_i3_22', 'pla_i3_22x', 'pla_i3_23', 'pla_i3_23x', 'pla_i3_16', 'pla_i3_16x',
        'pla_i3_27', 'pla_i3_27x', 'pla_i3_28', 'pla_i3_28x', 'pla_i3_10', 'pla_i3_10_otro', 'pla_i3_10x','pla_i3_tot', 'pla_i3_99');
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ir',
            'title'=>'abrir encuesta',
            'proceso'=>'ingresar_encuesta',
            'campos_parametros'=>array('tra_enc'=>null,'tra_hn'=>array('forzar_valor'=>-951)),
            'y_luego'=>'boton_ingresar_encuesta',
        );
    }
}
?>