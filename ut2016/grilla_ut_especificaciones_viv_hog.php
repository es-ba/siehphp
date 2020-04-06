<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_ut_especificaciones_viv_hog extends Grilla_respuestas_para_proc{
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
        $heredados[]='pla_v2';     
        $heredados[]='pla_h2';  
        $heredados[]='pla_h20a_1';  
        $heredados[]='pla_h20a_2';  
        $heredados[]='pla_h20a_5';  
        $heredados[]='pla_h20a_20';  
        $heredados[]='pla_h20a_21';  
        $heredados[]='pla_h20a_12';  
        $heredados[]='pla_h20a_11';  
        $heredados[]='pla_h20a_14';   
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
        'pla_v2',
        'pla_v2_esp',
        'pla_h2',
        'pla_h2_esp',
        'pla_h3', 
        'pla_h20a_1',
        'pla_h20a_2',
        'pla_h20a_5',
        'pla_h20a_20',
        'pla_h20a_21',
        'pla_h20a_12',
        'pla_h20a_11',
        'pla_h20a_14',
        'pla_h20a_14_esp'
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