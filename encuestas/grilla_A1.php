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
        
        $esnuevoA1="{$GLOBALS['NOMBRE_APP']}"=='etoi211' ?'1':'0';  //en etoi211 cambian la ubicación de telefonos y correo al S1
        $varlook=$esnuevoA1=='1' ?' ,pla_telefono as pla_telefono, pla_movil as pla_movil, pla_correo as pla_correo ':'';
        $clook="(select pla_enc as s1_enc, pla_hog as s1_hog, pla_v1, pla_total_h as pla_total_h ".$varlook. " from plana_s1_) s1 ";
       /*
        $this->tabla->tablas_lookup["
          (select pla_enc as s1_enc, pla_hog as s1_hog, pla_v1, pla_total_h as pla_total_h  from plana_s1_) s1
        "]="pla_enc=s1_enc and pla_hog=s1_hog";
        */
        $this->tabla->tablas_lookup["
          {$clook}
        "]="pla_enc=s1_enc and pla_hog=s1_hog";
        
        if($esnuevoA1=='1' ){
          $this->tabla->campos_lookup['pla_telefono']=false;
          $this->tabla->campos_lookup['pla_movil']=false;
          $this->tabla->campos_lookup['pla_correo']=false;
        }
      
        $this->tabla->campos_lookup['pla_v1']=false;
        $this->tabla->campos_lookup['pla_total_h']=false;
    }
    function campos_solo_lectura(){
        $esnuevoA1="{$GLOBALS['NOMBRE_APP']}"=='etoi211' ?'1':'0'; 
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
        $heredados[]='pla_h2a'; 
        $heredados[]='pla_h3';  
        $heredados[]='pla_v1';  
        $heredados[]='pla_total_h';  
        $heredados[]='pla_v5_esp';  
        $heredados[]='pla_h20_esp';
        if($esnuevoA1=='1' ){
          $heredados[]='pla_telefono';
          $heredados[]='pla_movil';
          $heredados[]='pla_correo';
        }
        // $heredados[]='pla_obs_a1';
       // $heredados[]='pla_obs_pmd'; 
        $heredados[]='pla_h36_1';
        $heredados[]='pla_h36_2'; 
        $heredados[]='pla_h36_3';
        $heredados[]='pla_h36_4'; 
        $heredados[]='pla_h36_5';
        $heredados[]='pla_h36_6';
        return $heredados;
    }
    function remover_en_nombre_de_campo(){
        return  '_pmd'; 
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
         $camposa=($GLOBALS['anio_operativo']<2021  | "{$GLOBALS['NOMBRE_APP']}"=='etoi211'  )?array('pla_telefono','pla_movil','pla_correo','pla_v1','pla_total_h',
        'pla_obs_pmd','pla_obs_a1','pla_obs_grilla_a1' ):array('pla_v1','pla_total_h','pla_obs_pmd','pla_obs_a1','pla_obs_grilla_a1') ;
        return array_merge(array('pla_enc',
        'pla_hog', 
        'tem_bolsa',
        'tem_estado',
        'tem_cod_anacon',
        'pla_etapa_pro'), 
            $this->filtrar_campos_del_operativo( array_merge(array('pla_v2',
        'pla_v2_esp',
        'pla_v4',
        'pla_v5',
        'pla_v5_esp',
        'pla_v12',
        'pla_h2',
        'pla_h2_esp',
        'pla_h2a',
        'pla_h3',
        'pla_h36',
        'pla_h36_1', 'pla_h36_1x', 'pla_h36_2', 'pla_h36_2x','pla_h36_3', 'pla_h36_3x', 'pla_h36_4', 'pla_h36_4x','pla_h36_5', 'pla_h36_5x','pla_h36_6','pla_h36_6x','pla_h36_6_esp', 
        'pla_h20_14',
        'pla_h20_esp'), $camposa
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