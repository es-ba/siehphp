<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_A1 extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('A1_');
        $this->tabla->tablas_lookup["
           (select pla_enc as s1_enc, pla_hog as s1_hog, pla_v1, pla_total_h as pla_total_h from plana_s1_) s1
        "]="pla_enc=s1_enc and pla_hog=s1_hog";
        $this->tabla->campos_lookup['pla_v1']=false;
        $this->tabla->campos_lookup['pla_total_h']=false;
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_v2';
        $heredados[]='pla_v5';
        $heredados[]='pla_h2';  
        $heredados[]='pla_h3';  
        $heredados[]='pla_v1';  
        $heredados[]='pla_total_h';  
        $heredados[]='pla_v5_esp';  
        $heredados[]='pla_h20_esp';  
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc',
        'pla_hog',        
        'tem_bolsa',
        'tem_estado',
        'tem_cod_anacon',
        'pla_etapa_pro'), 
            $this->filtrar_campos_del_operativo(array('pla_v2',
        'pla_v2_esp',
        'pla_v4',
        'pla_v5',
        'pla_v5_esp',
        'pla_v12',
        'pla_h2',
        'pla_h2_esp',
        'pla_h3',
        'pla_h20_14',
        'pla_h20_esp',
        'pla_telefono',
        'pla_movil',
        'pla_v1',
        'pla_total_h',
        'pla_obs_grilla_a1',
            )));
    }
    /*
    function campos_a_listar($filtro_para_lectura){
        return array(
        'pla_enc',
        'pla_hog',        
        'tem_bolsa',
        'tem_estado',
        'tem_cod_anacon',
        'pla_etapa_pro',
        'pla_v2',
        'pla_v2_esp',
        'pla_v4',
        'pla_v5',
        'pla_v5_esp',
        'pla_v12',
        'pla_h2',
        'pla_h2_esp',
        'pla_h3',
        'pla_h20_14',
        'pla_h20_esp',
        'pla_telefono',
        'pla_movil',
        'pla_v1',
        'pla_total_h',        
        );        
    } 
    */    
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 2;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_gh=$this->contexto->nuevo_objeto("Tabla_plana_A1_");
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