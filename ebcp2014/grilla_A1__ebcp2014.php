<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_A1__ebcp2014 extends Grilla_A1{
    function campos_solo_lectura(){
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_v2';
        $heredados[]='pla_v5';
        $heredados[]='pla_h2b'; 
        $heredados[]='pla_h20_14';
        return $heredados;
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
        'pla_v5',
        'pla_v5_esp',
        'pla_h2b', 
        'pla_h2d', 
        'pla_h2e', 
        'pla_h2c', 
        'pla_h2b_esp',
        'pla_h20_14',
        'pla_h20_esp');
    }   
}
?>