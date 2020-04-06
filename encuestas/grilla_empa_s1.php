<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_empa_S1 extends  Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
       $this->tabla->tablas_lookup["
           (select pla_enc as t_enc,  pla_barrio, pla_relevb, pla_sectorb, pla_manzanab, pla_ladob, pla_hojab, pla_filab, pla_manzana_estatuto
              from plana_tem_) t
        "]="pla_enc=t_enc";
        $this->tabla->campos_lookup['pla_barrio']=false;
        $this->tabla->campos_lookup['pla_relevb']=false;
        $this->tabla->campos_lookup['pla_sectorb']=false;
        $this->tabla->campos_lookup['pla_manzanab']=false;
        $this->tabla->campos_lookup['pla_ladob']=false;
        $this->tabla->campos_lookup['pla_hojab']=false;
        $this->tabla->campos_lookup['pla_filab']=false;
        $this->tabla->campos_lookup['pla_manzana_estatuto']=false;
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='tem_estado';
        $heredados[]='pla_barrio';
        $heredados[]='pla_relevb';
        $heredados[]='pla_sectorb';  
        $heredados[]='pla_manzanab';  
        $heredados[]='pla_manzana_estatuto';  
        $heredados[]='pla_ladob';  
        $heredados[]='pla_hojab';  
        $heredados[]='pla_filab';   
        return $heredados;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc','pla_hog',
        'tem_estado',), 
            $this->filtrar_campos_del_operativo(array('pla_barrio',
        'pla_relevb',
        'pla_sectorb',
        'pla_manzanab',
        'pla_manzana_estatuto',
        'pla_ladob',
        'pla_hojab',
        'pla_filab',
        'pla_orden',
        'pla_orden2',
        'pla_barriorel', 
        'pla_b_s', 
        'pla_mza', 
        'pla_lado',
        'pla_cas', 
        'pla_piso', 
        'pla_d_p', 
        'pla_n_h', 
        'pla_obs_geo', 
        'pla_entrea', 
        'pla_rel_ue',
        'pla_v1', 
        'pla_total_h', 
        'pla_h2', 
        'pla_h2_esp',
        'pla_hu1', 
        'pla_hu1a', 
        'pla_hu2',
        'pla_itfr', 
        'pla_s1a1_obs', 
         )));
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

class Grilla_ubi_geo extends Grilla_empa_S1{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
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
    function campos_a_listar($filtro_para_lectura){
        return array_merge( /*parent::campos_a_listar($filtro_para_lectura),*/
            array('pla_enc', 'pla_hog','tem_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_relevb','pla_sectorb','pla_manzanab','pla_manzana_estatuto','pla_ladob','pla_hojab','pla_filab',
                'pla_orden','pla_orden2', 'pla_barriorel', 'pla_b_s', 'pla_mza', 'pla_lado',
                'pla_cas', 'pla_piso', 'pla_d_p', 'pla_n_h', 'pla_tot_mie',
                'pla_obs_geo', 
                'pla_obs_grilla_pi',
            )));   
    }

}

class Grilla_hogar extends Grilla_empa_S1{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_b_s';
        $heredados[]='pla_mza';
        $heredados[]='pla_lado';  
        $heredados[]='pla_cas';  
        $heredados[]='pla_piso';  
        $heredados[]='pla_d_p';  
        $heredados[]='pla_entrea';
        $heredados[]='pla_razon1';
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
            'pla_b_s','pla_mza', 'pla_lado', 'pla_cas', 'pla_piso','pla_d_p', 'pla_n_h',
                'pla_entrea', 'pla_razon1','pla_rel_ue', 'pla_obs_geo', 'pla_v1', 
                'pla_total_h', 'pla_h2', 'pla_h2_esp','pla_hu1', 'pla_hu1a', 'pla_hu2','pla_itfr', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi'
            );
        };
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(/*parent::campos_a_listar($filtro_para_lectura),*/
            array('pla_enc','pla_hog','tem_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto','pla_b_s','pla_mza', 'pla_lado', 'pla_cas', 'pla_piso','pla_d_p', 'pla_n_h',
                'pla_entrea', 'pla_razon1','pla_rel_ue', 'pla_obs_geo', 'pla_v1', 
                'pla_total_h', 'pla_h2', 'pla_h2_esp','pla_hu1', 'pla_hu1a', 'pla_hu2','pla_itfr', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi',
            )));   
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

class Grilla_rea_norea extends Grilla_empa_S1{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_b_s';
        $heredados[]='pla_mza';
        $heredados[]='pla_lado';
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
                'pla_n_h', 'pla_entrea','pla_razon1', 'pla_v1',
                'pla_h2', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi'
            );
        }
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(/*parent::campos_a_listar($filtro_para_lectura),*/
            array('pla_enc','pla_hog','tem_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto','pla_b_s','pla_mza', 'pla_lado', 'pla_n_h', 'pla_entrea','pla_razon1', 'pla_v1',
                'pla_h2', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi',
            )));   
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
class Grilla_uni_eco extends Grilla_empa_S1{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
   // $this->tabla->clausula_where_agregada_manual="  or pla_ue_1 is distinct from null ";                  
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_b_s';
        $heredados[]='pla_mza';
        $heredados[]='pla_lado';  
        $heredados[]='pla_cas';  
        $heredados[]='pla_piso';  
        $heredados[]='pla_d_p';
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
                'pla_n_h','pla_entrea','pla_razon1', 'pla_rel_ue', 'pla_ue_1', 'pla_ue_1_esp',
                'pla_ue_2', 'pla_ue_2_esp','pla_ue_3','pla_ue_4', 'pla_ue_6', 'pla_ue_s1a1_obs', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi'
            );
        }
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(
            array('pla_enc','pla_hog','tem_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto','pla_b_s','pla_mza', 'pla_lado', 'pla_cas', 'pla_piso','pla_d_p', 'pla_n_h',
                'pla_entrea','pla_razon1', 'pla_rel_ue', 'pla_ue_1', 'pla_ue_1_esp',
                'pla_ue_2', 'pla_ue_2_esp','pla_ue_3','pla_ue_4', 'pla_ue_6', 'pla_ue_s1a1_obs', 'pla_s1a1_obs', 
                'pla_obs_grilla_pi',
            )));   
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
class Grilla_uni_eco_docu extends Grilla_empa_S1{ 
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_');
   // $this->tabla->clausula_where_agregada_manual="  or pla_ue_1 is distinct from null ";                  
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_b_s';
        $heredados[]='pla_mza';
        $heredados[]='pla_lado';  
        $heredados[]='pla_entrea';
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
                'pla_n_h',
                'pla_entrea', 'pla_ue_5', 'pla_ue_6', 'pla_ue_doc1', 'pla_ue_doc2',
                'pla_ue_doc3','pla_ue_doc3_esp','pla_ue_doc4', 'pla_s1a1_obs',
                'pla_obs_grilla_pi'
            );
        }        
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(
            array('pla_enc','pla_hog','tem_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto','pla_b_s','pla_mza', 'pla_lado', 'pla_n_h',
                'pla_entrea', 'pla_ue_5', 'pla_ue_6', 'pla_ue_doc1', 'pla_ue_doc2',
                'pla_ue_doc3','pla_ue_doc3_esp','pla_ue_doc4', 'pla_s1a1_obs',
                'pla_obs_grilla_pi',
            )));   
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