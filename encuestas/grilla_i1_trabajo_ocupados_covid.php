<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_i1_trabajo_ocupados_covid extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->tablas_lookup["
           (select pla_enc as t_enc, pla_participacion  from plana_tem_) t
        "]="pla_enc=t_enc";
        $this->tabla->campos_lookup['pla_participacion']=false;
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='s1_p_bolsa';
        $heredados[]='s1_p_estado';
        $heredados[]='s1_p_cod_anacon';
        $heredados[]='s1_p_fin_anacon';
        $heredados[]='s1_p_etapa_pro';
        $heredados[]='s1_p_semana';
        $heredados[]='s1_p_area';
        $heredados[]='pla_participacion';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';      
        $heredados[]='s1_p_sexo';
        $heredados[]='s1_p_edad';
        $heredados[]='pla_t30';
        $heredados[]='pla_t44';
        $heredados[]='pla_t45';
        $heredados[]='pla_t47';
        $heredados[]='pla_t51';
        $heredados[]='pla_t37sd';
        $heredados[]='pla_t40bis_a';
        $heredados[]='pla_t39';
        $heredados[]='pla_t40bis_a2';
        $heredados[]='pla_t40bis_b';
        $heredados[]='pla_t40bis_d';
        $heredados[]='pla_t40bis_a3_1'; 
        $heredados[]='pla_t40bis_a3_2';
        $heredados[]='pla_t40bis_a3_3';
        $heredados[]='pla_t40bis_a3_4';
        $heredados[]='pla_i4';
        $heredados[]='pla_i7a';
        $heredados[]='pla_i7_bis';
        $heredados[]='pla_i8';
        $heredados[]='pla_i9';
        $heredados[]='pla_obs' ;
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }

    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('s1_p_semana','pla_enc', 'pla_hog','pla_mie',
                                'pla_participacion','s1_p_bolsa','s1_p_estado',
                                's1_p_area','s1_p_cod_anacon',
                                's1_p_sexo','s1_p_edad',),
                $this->filtrar_campos_del_operativo(array(
                    'pla_t30','pla_t44','pla_t45','pla_t47','pla_t51','pla_t41','pla_t37sd','pla_t40bis_a',
                    'pla_t39','pla_t39_barrio','pla_t39_partido','pla_t39_otro','pla_t40bis_a2','pla_t40bis_a2_otro',
                    'pla_t40bis_b','pla_t40bis_b_barrio','pla_t40bis_b_partido','pla_t40bis_b_otro','pla_t40bis_d',
                    'pla_t40bis_a3_1', 'pla_t40bis_a3_2','pla_t40bis_a3_3','pla_t40bis_a3_4','pla_t40bis_a3_4_esp','pla_i4','pla_i7a','pla_i7_bis','pla_i8','pla_i9',
                    'pla_obs','pla_obs_grilla_ti_co1'
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