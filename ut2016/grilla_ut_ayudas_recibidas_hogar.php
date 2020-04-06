<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_ut_ayudas_recibidas_hogar extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='pla_etapa_pro';
        $heredados[]='tem_cod_anacon';        
        $heredados[]='pla_uh1';
        $heredados[]='pla_uh2';
        $heredados[]='pla_uh2_min';
        $heredados[]='pla_uh3';
        $heredados[]='pla_uh4';
        $heredados[]='pla_uh5';
        $heredados[]='pla_uh6';
        $heredados[]='pla_uh6_min';
        $heredados[]='pla_uh7';
        $heredados[]='pla_uh8';
        $heredados[]='pla_uh12';
        $heredados[]='pla_uh13';
        $heredados[]='pla_uh13_min';
        $heredados[]='pla_uh14';
        $heredados[]='pla_uh15';
        $heredados[]='pla_uh16';
        $heredados[]='pla_uh18';
        $heredados[]='pla_uh19';
        $heredados[]='pla_uh20';
        $heredados[]='pla_uh20_min';
        $heredados[]='pla_uh21';
        $heredados[]='pla_uh22';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array(
        'pla_enc',
        'pla_hog',
        'tem_bolsa',
        'tem_estado',
        'tem_cod_anacon',
        'pla_etapa_pro',
        'pla_uh1',
        'pla_uh2',
        'pla_uh2_min',
        'pla_uh3',
        'pla_uh3_esp',
        'pla_uh4',
        'pla_uh4_esp',
        'pla_uh5',
        'pla_uh6',
        'pla_uh6_min',
        'pla_uh7',
        'pla_uh7_esp',
        'pla_uh8',
        'pla_uh8_esp',
        'pla_uh12',
        'pla_uh13',
        'pla_uh13_min',
        'pla_uh14',
        'pla_uh14_esp',
        'pla_uh15',
        'pla_uh16',
        'pla_uh16_esp',
        'pla_uh18',
        'pla_uh19',
        'pla_uh20',
        'pla_uh20_min',
        'pla_uh21',
        'pla_uh21_esp',
        'pla_uh22',
        'pla_uh22_esp'
        );
    }   
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 2;
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