<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_salud__ebcp2014 extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_solo_lectura(){
        //$heredados=parent::campos_solo_lectura();
        $heredados[]='s1_p_bolsa';
        $heredados[]='s1_p_estado';
        $heredados[]='s1_p_cod_anacon';
        $heredados[]='s1_p_fin_anacon';
        $heredados[]='s1_p_etapa_pro';
        $heredados[]='s1_p_sexo';
        $heredados[]='s1_p_edad';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='pla_sn1_1';
        $heredados[]='pla_sn1_7';
        $heredados[]='pla_sn1_2';
        $heredados[]='pla_sn1_3';
        $heredados[]='pla_sn1_4';
        $heredados[]='pla_sn1_5';
        $heredados[]='pla_sn1_6';
        $heredados[]='pla_sn2';
        $heredados[]='pla_sn2_cant';
        $heredados[]='pla_sn3';
        $heredados[]='pla_sn4';
        $heredados[]='pla_sn5';
        $heredados[]='pla_sn11';
        $heredados[]='pla_sn13';
        $heredados[]='pla_sn14';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog','pla_mie',
        's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon','s1_p_fin_anacon','s1_p_etapa_pro',
        's1_p_sexo', 's1_p_edad', 'pla_sn1_1', 'pla_sn1_7', 'pla_sn1_2', 'pla_sn1_3', 'pla_sn1_4',  
        'pla_sn1_5','pla_sn1_6', 'pla_sn2', 'pla_sn2_cant', 'pla_sn3', 'pla_sn4', 'pla_sn4_esp', 
        'pla_sn5', 'pla_sn5_esp', 'pla_sn11', 'pla_sn13', 'pla_sn13_otro', 'pla_sn14', 'pla_sn14_esp' 
        );
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