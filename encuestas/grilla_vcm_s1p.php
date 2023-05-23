<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";


class Grilla_respuestas_para_proc_s1 extends Grilla_respuestas{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
        $this->tabla->campos_lookup=array(
            "t_bolsa"     =>true,
            "t_estado"    =>false,
            "t_cod_anacon"=>false,
            "t_fin_anacon"=>false,
            "t_etapa_pro" =>false,
            "s_total_h" =>false,
            "s_s1a1_obs" =>false,
        );
        $this->tabla->tablas_lookup=array(            
          "(select t.pla_bolsa as t_bolsa, t.pla_estado as t_estado, t.pla_cod_anacon as t_cod_anacon,
                t.pla_fin_anacon as t_fin_anacon, t.pla_etapa_pro as t_etapa_pro,
                t.pla_comuna t_comuna,t.pla_norea_enc t_norea_enc, t.pla_norea_recu t_norea_recu,
                t.pla_cnombre t_cnombre,t.pla_hn t_hn,t.pla_hp t_hp,t.pla_hd t_hd,t.pla_hab t_hab,
                t.pla_rea t_rea, t.pla_result_sup t_result_sup,
                t.pla_norea_sup t_norea_sup, s1.pla_enc s1_enc,s1.pla_hog s1_hog,  s1.pla_total_h s_total_h, pla_s1a1_obs s_s1a1_obs
                from plana_tem_ t inner join plana_s1_ s1 on s1.pla_enc=t.pla_enc 
           ) s1"=>"pla_enc=s1_enc and pla_hog=s1_hog ",
        );
    }
}

class Grilla_vcm_migracion extends Grilla_respuestas_para_proc_s1{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_P');
    }    
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='t_bolsa';
        $heredados[]='t_estado';
        $heredados[]='t_cod_anacon';
        $heredados[]='t_fin_anacon';
        $heredados[]='t_etapa_pro';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='pla_sexo';
        $heredados[]='pla_edad';
        $heredados[]='pla_m1';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie',
            't_bolsa','t_estado', 't_cod_anacon','t_fin_anacon','t_etapa_pro','pla_sexo', 'pla_edad','pla_lp','pla_l0'),
            $this->filtrar_campos_del_operativo(array('pla_m1', 'pla_m1_esp2', 'pla_m1_esp3','pla_m1_esp4', 
             'pla_obs_grilla_mi_s1p'))
        );
    }
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_s1_p=$this->contexto->nuevo_objeto("Tabla_plana_S1_P");
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