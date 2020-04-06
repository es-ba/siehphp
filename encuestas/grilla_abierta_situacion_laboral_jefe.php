<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_abierta_situacion_laboral_jefe extends Grilla_respuestas_para_proc{
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
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_jht1';
        $heredados[]='pla_jht2';
        $heredados[]='pla_jht3';
        $heredados[]='pla_jht4';
        $heredados[]='pla_jht5';  
        $heredados[]='pla_jht6';  
        $heredados[]='pla_jht9';  
        $heredados[]='pla_jht10';  
        $heredados[]='pla_jht11';  
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
        'pla_jht1',
        'pla_jht2',
        'pla_jht3',
        'pla_jht4',
        'pla_jht5',
        'pla_jht6',
        'pla_jht9',
        'pla_jht10',
        'pla_jht11',
        'pla_jht11_esp',
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