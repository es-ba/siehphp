<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_norea_ope extends  Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
       $this->tabla->tablas_lookup["
           (select t.pla_enc t_enc, t.pla_bolsa as t_bolsa, t.pla_estado as t_estado, t.pla_cod_anacon as t_cod_anacon,
                t.pla_fin_anacon as t_fin_anacon, t.pla_etapa_pro as t_etapa_pro,
                t.pla_comuna t_comuna,t.pla_norea_enc t_norea_enc, t.pla_norea_recu t_norea_recu,
                t.pla_cnombre t_cnombre,t.pla_hn t_hn,t.pla_hp t_hp,t.pla_hd t_hd,t.pla_hab t_hab,
                t.pla_rea t_rea, t.pla_result_sup t_result_sup,
                t.pla_norea_sup t_norea_sup, t.pla_semana t_semana
                from plana_tem_ t
           ) t
        "]="pla_enc=t_enc";
        $this->tabla->campos_lookup['t_bolsa']=false;
        $this->tabla->campos_lookup['t_estado']=false;
        $this->tabla->campos_lookup['t_cod_anacon']=false;
        $this->tabla->campos_lookup['t_fin_anacon']=false;
        $this->tabla->campos_lookup['t_etapa_pro']=false;
        $this->tabla->campos_lookup['t_semana']=false;
        $this->tabla->campos_lookup['t_comuna']=false;
        $this->tabla->campos_lookup['t_norea_enc']=false;
        $this->tabla->campos_lookup['t_norea_recu']=false;
        $this->tabla->campos_lookup['t_cnombre']=false;
        $this->tabla->campos_lookup['t_hn']=false;
        $this->tabla->campos_lookup['t_hp']=false;
        $this->tabla->campos_lookup['t_hd']=false;
        $this->tabla->campos_lookup['t_hab']=false;
        $this->tabla->campos_lookup['t_rea']=false;
        $this->tabla->campos_lookup['t_result_sup']=false;
        $this->tabla->campos_lookup['t_norea_sup']=false;
        $this->tabla->campos_lookup['t_enc']=false;
        $this->tabla->campos_lookup['t_semana']=false;
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='t_semana';
        $heredados[]='t_comuna';
        $heredados[]='t_norea_enc';
        $heredados[]='t_norea_recu';
        $heredados[]='t_cnombre';
        $heredados[]='t_hn';
        $heredados[]='t_hp';
        $heredados[]='t_hd';
        $heredados[]='t_hab'; 
        $heredados[]='t_rea';
        $heredados[]='t_estado';
        $heredados[]='t_result_sup';
        $heredados[]='t_norea_sup';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        return $heredados;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie','t_semana',
            't_comuna','t_norea_enc', 't_norea_recu',
            't_cnombre','t_hn','t_hp','t_hd','t_hab',
            't_rea','t_estado','t_result_sup','t_norea_sup'
            )
        );
    }
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
    function permite_grilla_sin_filtro(){
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
class Grilla_norea_etoi_eah extends Grilla_norea_ope{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento') && !tiene_rol('subcoor_campo')){
            $campos_solo_lectura_rol=array(
                'pla_razon1', 'pla_razon2_1', 'pla_razon2_2', 'pla_razon2_3', 'pla_razon2_4', 'pla_razon2_5', 'pla_razon2_6', 'pla_razon2_7'
                 , 'pla_razon2_8', 'pla_razon2_9','pla_razon3','pla_s1a1_obs', 
                 'pla_obs_grilla_no','pla_verificado_norea'
            );
        }       
        return array_merge($heredados,$campos_solo_lectura_rol);
    }

    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','t_semana',
            't_comuna','t_norea_enc', 't_norea_recu','t_cnombre','t_hn','t_hp','t_hd','t_hab', 't_rea', 'pla_razon1',
            'pla_razon2_1', 'pla_razon2_2', 'pla_razon2_3', 'pla_razon2_4', 'pla_razon2_5', 'pla_razon2_6', 'pla_razon2_7', 
            'pla_razon2_8','pla_razon2_9','pla_razon3','t_estado','t_result_sup','t_norea_sup',
            'pla_verificado_norea','pla_s1a1_obs', 'pla_obs_grilla_no')
        );
    }

    function responder_grabar_campo(){
        $this->tabla_plana_s1=$this->contexto->nuevo_objeto("Tabla_plana_S1_");
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