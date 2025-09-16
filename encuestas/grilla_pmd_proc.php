<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_PMD_proc extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('PMD_');
    }  
    
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_respon';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_ent_rea_pm';
        $heredados[]='pla_hpm4';
        $heredados[]='pla_pm3';
        $heredados[]='pla_pm6';
        $heredados[]='pla_pm9';
        $heredados[]='pla_pm15';
        $heredados[]='pla_pm21';
        $heredados[]='pla_pm24'; 
        $heredados[]='pla_pm27';
        $heredados[]='pla_pm30';
        $heredados[]='pla_pm33';
        $heredados[]='pla_pm36';
        $heredados[]='pla_pm39';
        $heredados[]='pla_pm42';
        $heredados[]='pla_pm45';
        $heredados[]='pla_pm48';
        $heredados[]='pla_pm51';
        $heredados[]='pla_pm54';
        $heredados[]='pla_pm57';
        $heredados[]='pla_pm60';
        $heredados[]='pla_pm63';
        $heredados[]='pla_pm66';
        $heredados[]='pla_pm69';
        $heredados[]='pla_pm72';
        $heredados[]='pla_pm75';
        $heredados[]='pla_pm78';
        $heredados[]='pla_pm81';
        $heredados[]='pla_pm84';
        $heredados[]='pla_pm87';
        $heredados[]='pla_pm90';
        $heredados[]='pla_obs_pm';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc',
        'pla_hog',
        'pla_respon',        
        'tem_bolsa',
        'tem_estado',
        'tem_cod_anacon',
        'pla_etapa_pro',
        'pla_ent_rea_pm'), 
            $this->filtrar_campos_del_operativo(array('pla_pm3', 'pla_pm3_esp', 'pla_hpm4','pla_pm6', 'pla_pm6_esp', 'pla_pm9', 'pla_pm9_esp', 'pla_pm15','pla_pm15_esp',
                                                      'pla_pm21','pla_pm21_esp','pla_pm24','pla_pm24_esp','pla_pm27','pla_pm27_esp','pla_pm30','pla_pm30_esp',
                                                      'pla_pm33','pla_pm33_esp','pla_pm36','pla_pm36_esp','pla_pm39','pla_pm39_esp','pla_pm42','pla_pm42_esp',
                                                      'pla_pm45','pla_pm45_esp','pla_pm48','pla_pm48_esp','pla_pm51','pla_pm51_esp','pla_pm54','pla_pm54_esp',
                                                      'pla_pm57','pla_pm57_esp','pla_pm60','pla_pm60_esp','pla_pm63','pla_pm63_esp','pla_pm66','pla_pm66_esp',
                                                      'pla_pm69','pla_pm69_esp','pla_pm72','pla_pm72_esp','pla_pm75','pla_pm75_esp','pla_pm78','pla_pm78_esp',
                                                      'pla_pm81','pla_pm81_esp','pla_pm84','pla_pm84_esp','pla_pm87','pla_pm87_esp','pla_pm90','pla_pm90_esp',
                                                      'pla_razon_pm','pla_razon_pm_esp','pla_obs_pm','pla_obs_grilla_pmd'
            )));
    }    
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_gh=$this->contexto->nuevo_objeto("Tabla_plana_PMD_");
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