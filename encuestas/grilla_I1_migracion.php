<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_migracion extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }    
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados=array_merge( $heredados, array(
            's1_p_bolsa'
            ,'s1_p_estado'
            ,'s1_p_cod_anacon'
            //,'s1_p_fin_anacon'
            ,'s1_p_etapa_pro'
            ,'s1_p_semana'
            ,'pla_enc'
            ,'pla_hog'
            ,'pla_mie'
            ,'pla_exm'
        ), $this->filtrar_campos_del_operativo(array(
            's1_r0'
            ,'s1_p_sexo'
            ,'s1_p_edad'
            ,'pla_m1'
            ,'pla_m4'
            ,'pla_m1_anio'
            ,'pla_m3'
            ,'pla_m3_anio'
            ,'pla_aj_m1'
            ,'pla_aj_m3'
        )));
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie','s1_p_semana',
            's1_p_bolsa','s1_p_estado', 's1_p_cod_anacon', /*'s1_p_fin_anacon',*/'s1_p_etapa_pro','s1_p_sexo', 's1_p_edad'),
            $this->filtrar_campos_del_operativo(array('s1_r0', 'pla_m1', 'pla_m1_anio', 'pla_m1_esp2', 'pla_m1_esp3','pla_m1_esp4', 
            'pla_m3', 'pla_m3_anio', 'pla_m4', 'pla_m4_esp1', 'pla_m4_esp2','pla_m4_esp3', 
            'pla_aj_m1','pla_aj_m1_anio', 'pla_aj_m1_esp2', 'pla_aj_m1_esp3','pla_aj_m1_esp4', 'pla_aj_m3','pla_aj_m3_anio','pla_obs_grilla_mi'))
        );
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
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