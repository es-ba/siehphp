<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_trabajo_ingresos extends Grilla_respuestas_para_proc_ind{
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
        $heredados[]='s1_p_semana';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='s1_p_sexo';
        $heredados[]='s1_p_edad';
        $heredados[]='pla_t7';
        $heredados[]='pla_t8';
        $heredados[]='pla_t11';
        $heredados[]='pla_t37sd';
        $heredados[]='pla_t38';
        $heredados[]='pla_t39'; 
        $heredados[]='pla_t40a'; 
        $heredados[]='pla_t48b';
        $heredados[]='pla_t44';
        $heredados[]='pla_t45';
        $heredados[]='pla_t46';
        $heredados[]='pla_t47';
        $heredados[]='pla_t48';
        $heredados[]='pla_t48a';
        $heredados[]='pla_i1';
        $heredados[]='pla_i4';
        $heredados[]='pla_i6_2';
        $heredados[]='pla_i6_3';
        $heredados[]='pla_i6_4';
        $heredados[]='pla_i6_5';
        $heredados[]='pla_i6_6';
        $heredados[]='pla_i6_7';
        $heredados[]='pla_i6_8';
        $heredados[]='pla_i6_9';
        $heredados[]='pla_i6_10';
        $heredados[]='pla_i3_1';
        $heredados[]='pla_i3_1x';
        $heredados[]='pla_i3_2';
        $heredados[]='pla_i3_2x';
        $heredados[]='pla_i3_3';
        $heredados[]='pla_i3_3x';
        $heredados[]='pla_i3_4';
        $heredados[]='pla_i3_4x';
        $heredados[]='pla_i3_5';
        $heredados[]='pla_i3_5x';
        $heredados[]='pla_i3_6';
        $heredados[]='pla_i3_6x';
        $heredados[]='pla_i3_7';
        $heredados[]='pla_i3_7x';
        $heredados[]='pla_i3_13';
        $heredados[]='pla_i3_13x';
        $heredados[]='pla_i3_81';
        $heredados[]='pla_i3_81x';
        $heredados[]='pla_i3_82';
        $heredados[]='pla_i3_82x';
        $heredados[]='pla_i3_11';
        $heredados[]='pla_i3_11x';
        $heredados[]='pla_i3_31';
        $heredados[]='pla_i3_31x';
        $heredados[]='pla_i3_12';
        $heredados[]='pla_i3_12x';
        $heredados[]='pla_i3_10';
        $heredados[]='pla_i3_10x';
        $heredados[]='pla_obs';        
        $heredados[]='pla_t23';
        $heredados[]='pla_t39_bis2_esp';
        $heredados[]='pla_t24'; 
        $heredados[]='pla_t25'; 
        $heredados[]='pla_t26';
        $heredados[]='pla_i3_32';
        $heredados[]='pla_i3_32x';
        $heredados[]='pla_i3_13a';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie','s1_p_semana',
                                's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon','s1_p_fin_anacon','s1_p_etapa_pro',
                                's1_p_sexo', 's1_p_edad'),
                $this->filtrar_campos_del_operativo(array(
                    'pla_t7', 'pla_t8', 'pla_t8_otro','pla_t11', 'pla_t11_otro', 
                    'pla_t18', 'pla_t23', 'pla_t24', 'pla_t25', 'pla_t26',
                    'pla_t37', 'pla_t37sd', 'pla_t38', 'pla_t39', 'pla_t39_barrio', 'pla_t39_partido','pla_t39_otro', 
                    'pla_t39_bis2', 'pla_t39_bis2_esp', 
                    //'pla_t40a',
                    'pla_t41' ,'pla_t42',
                    'pla_t44','pla_t45','pla_t46','pla_t47','pla_t48','pla_t48a',
                    'pla_t48b','pla_t48b_esp',
                    'pla_i1',
                    'pla_i3_10', 'pla_i3_10x', 'pla_i3_10_otro', 
                    'pla_i4', 'pla_i6_2','pla_i6_3','pla_i6_4','pla_i6_5','pla_i6_6','pla_i6_7','pla_i6_8','pla_i6_9','pla_i6_10','pla_i6_10_esp',
                    'pla_i3_1','pla_i3_1x','pla_i3_2','pla_i3_2x','pla_i3_3','pla_i3_3x','pla_i3_4','pla_i3_4x','pla_i3_5','pla_i3_5x','pla_i3_6','pla_i3_6x','pla_i3_7','pla_i3_7x','pla_i3_13','pla_i3_13x','pla_i3_81','pla_i3_81x','pla_i3_82','pla_i3_82x','pla_i3_11','pla_i3_11x','pla_i3_31','pla_i3_31x','pla_i3_12','pla_i3_12x','pla_i3_10','pla_i3_10x','pla_i3_10_otro',
                    'pla_i3_13a','pla_i3_32','pla_i3_32x', 
                    'pla_obs','pla_check_pro_ti','pla_obs_grilla_ti'
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 4;
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
    function responder_grabar_campo(){
        $this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_I1_");
        $tabla_variables=$this->contexto->nuevo_objeto("Tabla_variables");                
                $variable=quitar_prefijo($this->argumentos->campo,'pla_');
                $tabla_variables->leer_uno_si_hay(array(
                    'var_ope'=>$GLOBALS['NOMBRE_APP'],
                    'var_var'=>$variable,                    
                )); 
        if($tabla_variables->obtener_leido()){
            return parent::responder_grabar_campo();               
       }else{
            return $this->responder_grabar_campo_directo();
       }
    }
}
?>