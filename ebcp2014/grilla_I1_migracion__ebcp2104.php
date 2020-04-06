<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_migracion__ebcp2014 extends Grilla_I1_migracion{
    function campos_solo_lectura(){
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
        $heredados[]='pla_m1b'; 
        $heredados[]='pla_m3';
        return $heredados;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog','pla_mie',
        's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon','s1_p_fin_anacon','s1_p_etapa_pro',
        's1_p_sexo', 's1_p_edad','pla_m1','pla_m1_esp2', 'pla_m1_esp3','pla_m1_esp4','pla_m1b','pla_m1a','pla_m1a_2_esp','pla_m1a_3_esp','pla_m1a_4_esp','pla_m3','pla_m4','pla_m4_esp1', 'pla_m4_esp2','pla_m4_esp3');
    }
}
?>