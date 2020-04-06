<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_abierta_vivienda extends Grilla_respuestas_para_proc{
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
        $heredados[]='pla_v1';
        $heredados[]='pla_v2';     
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_v4';
        $heredados[]='pla_v5';
        $heredados[]='pla_v6';
        $heredados[]='pla_v7';
        $heredados[]='pla_v12';
        $heredados[]='pla_h2';  
        $heredados[]='pla_h3';  
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
        'pla_v1',
        'pla_v2',
        'pla_v2_esp',
        'pla_v4',
        'pla_v5',
        'pla_v5_esp',
        'pla_v6',
        'pla_v7',
        'pla_v12',
        'pla_h2',
        'pla_h2_esp',
        'pla_h3',        
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