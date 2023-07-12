<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_vcm_I1_preguntas_abiertas extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        
       $this->tabla->tablas_lookup["
           (select t.pla_enc t_enc, t.pla_bolsa as t_bolsa, t.pla_estado as t_estado, t.pla_cod_anacon as t_cod_anacon,
                t.pla_fin_anacon as t_fin_anacon, t.pla_etapa_pro as t_etapa_pro,
                t.pla_comuna t_comuna,t.pla_semana t_semana,
                s.pla_hog t_hog, p.pla_mie t_mie, p.pla_sexo t_sexo, p.pla_edad t_edad
                from plana_tem_ t 
                inner join plana_s1_ s on t.pla_enc=s.pla_enc
                inner join plana_s1_p p on s.pla_enc=p.pla_enc and s.pla_hog=p.pla_hog 
           ) t 
        "]="pla_enc=t_enc and pla_hog=t_hog and pla_mie=t_mie";
        $this->tabla->campos_lookup['t_bolsa']=false;
        $this->tabla->campos_lookup['t_estado']=false;
        $this->tabla->campos_lookup['t_cod_anacon']=false;
        $this->tabla->campos_lookup['t_fin_anacon']=false;
        $this->tabla->campos_lookup['t_etapa_pro']=false;
        $this->tabla->campos_lookup['t_comuna']=false;
        $this->tabla->campos_lookup['t_semana']=false;
        $this->tabla->campos_lookup['t_enc']=false;
        $this->tabla->campos_lookup['t_hog']=false; 
        $this->tabla->campos_lookup['t_mie']=false; 
        $this->tabla->campos_lookup['t_sexo']=false; 
        $this->tabla->campos_lookup['t_edad']=false; 
        
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='t_bolsa';
        $heredados[]='t_estado';
        $heredados[]='t_cod_anacon';
        $heredados[]='t_fin_anacon';
        $heredados[]='t_etapa_pro';
        $heredados[]='t_comuna';
        $heredados[]='t_semana';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='t_sexo';
        $heredados[]='t_edad';
        $heredados[]='pla_a1';
        $heredados[]='pla_a2';
        $heredados[]='pla_a3';
        $heredados[]='pla_a4';
        $heredados[]='pla_a5_1';
        $heredados[]='pla_a5_2';
        $heredados[]='pla_a5_3';
        $heredados[]='pla_a5_4';
        $heredados[]='pla_a5_5';
        $heredados[]='pla_a5_6';
        $heredados[]='pla_a5_7';
        $heredados[]='pla_a5_8';
        $heredados[]='pla_a5_9';
        $heredados[]='pla_a5_10';
        $heredados[]='pla_a5_11';
        $heredados[]='pla_a5_12';
        $heredados[]='pla_f7';
        $heredados[]='pla_f8_15';
        $heredados[]='pla_f9_edad';
        $heredados[]='pla_f14g';
        $heredados[]='pla_g2';
        $heredados[]='pla_g4o';
        $heredados[]='pla_g5_g';
        $heredados[]='pla_g6_14';
        $heredados[]='pla_g7';
        $heredados[]='pla_g8_7';
        $heredados[]='pla_g9_17';
        $heredados[]='pla_observ';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie',
                                't_bolsa','t_estado', 't_cod_anacon','t_fin_anacon','t_etapa_pro',
                                't_semana',
                                't_sexo', 't_edad'),
                $this->filtrar_campos_del_operativo(array(
                    'pla_a1','pla_a1_esp','pla_a2','pla_a3','pla_a4','pla_a5_1','pla_a5_2','pla_a5_3','pla_a5_4',                  
                    'pla_a5_5','pla_a5_6','pla_a5_7','pla_a5_8','pla_a5_9','pla_a5_10','pla_a5_11','pla_a5_12',    
                    'pla_f7','pla_f8_15','pla_f8_especificar','pla_f9_edad','pla_f14g','pla_f14g_espe','pla_g2',  
                    'pla_g3_13esp','pla_g4o','pla_g4o_esp','pla_g5_g','pla_g5_g_esp','pla_g6_14','pla_g6_esp',    
                    'pla_g7','pla_g8_7','pla_g8_7_esp','pla_g9_17','pla_g9_17esp','pla_observ','pla_obs_grilla_ti'
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