<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_abierta_sn extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';        
        $heredados[]='pla_sn19';
        $heredados[]='pla_sn20';
        $heredados[]='pla_sn21_1';
        $heredados[]='pla_sn21_2';
        $heredados[]='pla_sn21_3';
        $heredados[]='pla_sn21_4';
        $heredados[]='pla_sn22';
        $heredados[]='pla_sn23';  
        $heredados[]='pla_sn24';  
        $heredados[]='pla_sn24_12';  
        $heredados[]='pla_sn15a28';  
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
        'pla_sn19',
        'pla_sn20',
        'pla_sn21_1',
        'pla_sn21_2',
        'pla_sn21_3',
        'pla_sn21_4',
        'pla_sn22',
        'pla_sn22_esp',
        'pla_sn23',
        'pla_sn24',
        'pla_sn24_12',
        'pla_sn15a28',
        'pla_sn15a28_esp',        
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