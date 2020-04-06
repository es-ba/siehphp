<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_GH_proc extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct(); 
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('GH_');
        $this->tabla->campos_lookup["pla_rea"]=false;
        $this->tabla->campos_lookup["pla_dominio"]=false;
        $this->tabla->campos_lookup["pla_total_h"]=false;
        $this->tabla->campos_lookup["pla_gh_tot"]=false;
        $this->tabla->campos_lookup["pla_zona"]=false;
        $this->tabla->campos_lookup["pla_comuna"]=false;
        $this->tabla->campos_lookup["pla_semana"]=false;
        $this->tabla->campos_lookup["pla_fin_de_campo"]=false;
        $this->tabla->campos_lookup["pla_hog_pre"]=false;
        $this->tabla->campos_lookup["pla_h2"]=false;
        $this->tabla->campos_lookup["pla_h2_esp"]=false;
        $this->tabla->campos_lookup["pla_v2"]=false;
        $this->tabla->campos_lookup["pla_v2_esp"]=false;
        $this->tabla->campos_lookup["pla_v4"]=false;
        $this->tabla->campos_lookup["pla_h3"]=false;
        $this->tabla->campos_lookup["sem_mes_referencia"]=false;
        $this->tabla->campos_lookup["periodicidad"]=false;
         
        $this->tabla->tablas_lookup=array(            
            '(select t.pla_rea as pla_rea, t.pla_bolsa as tem_bolsa, t.pla_estado as tem_estado, t.pla_cod_anacon as tem_cod_anacon,t.pla_etapa_pro as pla_etapa_pro,
                     t.pla_dominio as pla_dominio, t.pla_zona as pla_zona, t.pla_comuna as pla_comuna, t.pla_semana::integer as pla_semana, t.pla_fin_de_campo as pla_fin_de_campo,
                     t.pla_gh_tot as pla_gh_tot, t.pla_hog_pre as pla_hog_pre,s.pla_enc as aa_enc, s.pla_hog as aa_hog, s.pla_total_h as pla_total_h,
                     a.pla_h2 as  pla_h2, a.pla_h2_esp as pla_h2_esp, a.pla_v2 as pla_v2, a.pla_v2_esp as pla_v2_esp, a.pla_v4 as pla_v4, a.pla_h3 as pla_h3,
                     se.sem_mes_referencia as sem_mes_referencia,dbo.periodicidad(t.pla_rotaci_n_etoi, t.pla_dominio ) as periodicidad  
                 from plana_s1_ s
                 inner join plana_a1_ a on a.pla_enc=s.pla_enc and a.pla_hog=s.pla_hog
                 inner join plana_tem_ t on t.pla_enc=s.pla_enc
                 inner join semanas se on se.sem_sem=t.pla_semana) aa'=>'pla_enc=aa_enc and pla_hog=aa_hog',
        );
        $this->tabla->clausula_where_agregada_manual="  and tem_estado=77  and pla_dominio=3 " ; 
    }
    function campos_editables($filtro_para_lectura){
        return array(
            'pla_obssd',
            'pla_corte_gh'
        );        
    }  
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_semana','pla_hog','tem_bolsa','tem_estado','tem_cod_anacon'/*,'pla_etapa_pro'*/,
                     'pla_rea','pla_dominio','pla_zona', 'pla_comuna',),
                $this->filtrar_campos_del_operativo(array(     
                     'pla_gh_tot', 'pla_fin_de_campo',
                     'pla_total_h','pla_hog_pre','pla_h2','pla_h2_esp','pla_v2','pla_v2_esp','pla_v4','pla_h3',
                     'pla_obssd','pla_sd1','pla_sd2','pla_sd3','pla_sd4','pla_sd5',
                     'pla_sd6','pla_sd7','pla_sd7_1','pla_sd7_2','pla_sd7_3','pla_sd7_4','pla_al1', 'pla_sd_valhor','pla_corte_gh',
                     'sem_mes_referencia', 'periodicidad'
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_gh=$this->contexto->nuevo_objeto("Tabla_plana_GH_");
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