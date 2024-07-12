<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_i1_trabajo_desocupados_covid extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->tablas_lookup["
           (select pla_enc as t_enc, pla_participacion  from plana_tem_) t
        "]="pla_enc=t_enc";
        $this->tabla->campos_lookup['pla_participacion']=false;
        $this->tabla->clausula_where_agregada_manual="  and (pla_t12=1  or pla_t12=2) " ; 
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='s1_p_bolsa';
        $heredados[]='s1_p_estado';
        $heredados[]='s1_p_cod_anacon';
        $heredados[]='s1_p_fin_anacon';
        $heredados[]='s1_p_etapa_pro';
        $heredados[]='s1_p_semana';
        //$heredados[]='s1_p_area';
       // $heredados[]='pla_participacion';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';  
        if ("{$GLOBALS['NOMBRE_APP']}"=='eah2024') {
           $heredados[]='s1_r0';
        }        
        $heredados[]='s1_p_sexo';
        $heredados[]='s1_p_edad';
        $heredados[]= 'pla_t12';
        $heredados[]= 'pla_t13_0';
        $heredados[]= 'pla_t15';
        $heredados[]= 'pla_t18';
        $heredados[]= 'pla_t18_0';
        $heredados[]= 'pla_t19';
        $heredados[]= 'pla_t19_1';
        $heredados[]= 'pla_t20_1';
        $heredados[]= 'pla_t48a_d';
        $heredados[]= 'pla_t48b_d';
        $heredados[]= 'pla_t48c_d';
        $heredados[]= 'pla_t51_d';
        $heredados[]= 'pla_t51_e';
        $heredados[]='pla_obs' ;
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }

    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('s1_p_semana','pla_enc', 'pla_hog','pla_mie',
                                /*'pla_participacion',*/'s1_p_bolsa','s1_p_estado',
                                /*'s1_p_area',*/'s1_p_cod_anacon',
                                's1_p_sexo','s1_p_edad',),
                $this->filtrar_campos_del_operativo(array(
                    's1_r0','pla_t12','pla_t13_0', 'pla_t13_0_esp','pla_t15','pla_t18','pla_t18_0','pla_t19','pla_t19_1','pla_t20_1','pla_t48a_d','pla_t48b_d','pla_t48b_d_esp',
                    'pla_t48c_d','pla_t48c_d_esp','pla_t51_d','pla_t51_e','pla_t51_e_esp',
                    'pla_obs','pla_obs_grilla_ti_co2'
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