<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_S1 extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
        $this->tabla->tablas_lookup["
           (select pla_enc tem_enc, pla_rea , pla_comuna, pla_participacion, dbo.periodicidad(pla_rotaci_n_etoi ,pla_dominio) vperiodicidad
           from plana_tem_ ) t
        "]="pla_enc=t.tem_enc ";
         $this->tabla->campos_lookup['pla_rea']=false;
         $this->tabla->campos_lookup['pla_comuna']=false;
         $this->tabla->campos_lookup['pla_participacion']=false;
         $this->tabla->campos_lookup['vperiodicidad']=false;
    }
    function campos_editables($filtro_para_lectura){
        return array_merge(array(
        'pla_telefono',
        'pla_movil',
        'pla_correo', 
        //'pla_rmod',
        'pla_s1a1_obs',
        'pla_obs_grilla_s1'         
        ),$this->filtrar_campos_del_operativo(array('pla_rmod', 'pla_rmod_e', 'pla_tel_1','pla_tel_3' ))
        );  
    }    
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){        
        return array_merge(array('pla_enc', 'pla_rea', 'pla_hog', 'vperiodicidad', 'pla_participacion', 'tem_semana', 'pla_comuna', 'tem_estado',
                     'tem_bolsa', 'tem_cod_anacon'),
          $this->filtrar_campos_del_operativo(array('pla_total_h','pla_total_m','pla_total_r','pla_telefono', 'pla_movil',  'pla_correo', 'pla_rmod', 'pla_rmod_e','pla_tel_1', 'pla_tel_3','pla_s1a1_obs', 'pla_obs_grilla_s1' ))
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