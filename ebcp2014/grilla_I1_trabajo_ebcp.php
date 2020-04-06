<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_trabajo_ebcp extends Grilla_respuestas_para_proc_ind{
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
        $heredados[]='pla_t8';
        $heredados[]='pla_t11';
        $heredados[]='pla_t14b';
        $heredados[]='pla_t15a';
        $heredados[]='pla_t19_anio';
        $heredados[]='pla_t36_1';
        $heredados[]='pla_t36_2';
        $heredados[]='pla_t36_3';
        $heredados[]='pla_t36_4';
        $heredados[]='pla_t36_5';
        $heredados[]='pla_t36_6';
        $heredados[]='pla_t36_7';
        $heredados[]='pla_t36_8';
        $heredados[]='pla_t36a';
        $heredados[]='pla_t37sd';
        $heredados[]='pla_t38';
        $heredados[]='pla_t38b';
        $heredados[]='pla_t39'; 
        $heredados[]='pla_t40'; 
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog','pla_mie',
        's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon','s1_p_fin_anacon','s1_p_etapa_pro',
        's1_p_sexo', 's1_p_edad',
        'pla_t8', 'pla_t8_otro','pla_t11', 'pla_t11_otro', 'pla_t14b', 'pla_t14b_esp', 'pla_t15a', 'pla_t15a_otro','pla_t19_anio','pla_t23', 'pla_t24', 
        'pla_t25', 'pla_t26', 'pla_t36_1', 'pla_t36_2', 'pla_t36_3', 'pla_t36_4', 'pla_t36_5', 'pla_t36_6', 'pla_t36_7', 'pla_t36_7_esp', 'pla_t36_8', 'pla_t36_8_esp', 'pla_t36a',
        'pla_t37', 'pla_t37sd', 'pla_t38', 'pla_t38b', 'pla_t38b_esp','pla_t39', 'pla_t39_otro', 
        'pla_t40', 'pla_t41' ,'pla_t42', 'pla_t43','pla_t48b_esp');
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