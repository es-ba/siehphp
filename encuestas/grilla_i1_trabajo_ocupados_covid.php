<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_i1_trabajo_ocupados_covid extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->tablas_lookup["
           (select pla_enc as t_enc, pla_participacion  from plana_tem_) t
        "]="pla_enc=t_enc";
        $this->tabla->campos_lookup['pla_participacion']=false;
        $vsent=" or pla_t35=1 or pla_t35=2 )" ; 
        $vcondicion=$GLOBALS['NOMBRE_APP']=='eah2025'|| ( substr($GLOBALS['NOMBRE_APP'],0,4)=='etoi' && (int)(substr($GLOBALS['NOMBRE_APP'],4))>252 )?true:false;
        $this->tabla->clausula_where_agregada_manual= $vcondicion ?"  and ( pla_t30_1>=1  ".$vsent:"  and (pla_t30>=1  ".$vsent ; 
       
    }
//"  and (  pla_t35=1 or pla_t35=2 or  ".
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados= array_merge($heredados, array(
            's1_p_bolsa'
            ,'s1_p_estado'
            ,'s1_p_cod_anacon'
            ,'s1_p_fin_anacon'
            ,'s1_p_etapa_pro'
            ,'s1_p_semana'
            //,'s1_p_area'
            //,'pla_participacion'
            ,'pla_enc'
            ,'pla_hog'
            ,'pla_mie'
            ,'pla_exm'      
            ,'s1_p_sexo'
            ,'s1_p_edad'
        ), $this->filtrar_campos_del_operativo(array(    
            's1_r0'
            ,'pla_t30'
            ,'pla_t30_1'
            ,'pla_t35_0'
            ,'pla_t44'
            ,'pla_t45'
            ,'pla_t47'
            ,'pla_t51'
            ,'pla_t37'
            ,'pla_t37sd'
            ,'pla_tsd7'
            ,'pla_t40bis_a'
            ,'pla_tu3'
            ,'pla_tu4'
            ,'pla_tu5'
            ,'pla_tu6'
            ,'pla_tu7'
            ,'pla_tu8'
            ,'pla_tu9'
            ,'pla_t40bis_a1'
            ,'pla_t40bis_a2'
            ,'pla_t40bis_b'
            ,'pla_t40bis_d'
            ,'pla_t40bis_f'
            ,'pla_t40bis_g6'
            ,'pla_t40bis_a3_1' 
            ,'pla_t40bis_a3_2'
            ,'pla_t40bis_a3_3'
            ,'pla_t40bis_a3_4'
            ,'pla_t40bis_a3_5'
            ,'pla_ts1'
            ,'pla_ts2'
            ,'pla_ts3'
            ,'pla_ta1'
            ,'pla_ta4'
            ,'pla_tu16_a'
            ,'pla_tu16_b'
            ,'pla_tu16_c'
            ,'pla_tu16_d' 
            ,'pla_tu16_e'
            ,'pla_tu17_a'
            ,'pla_tu17_b'
            ,'pla_tu17_c'
            ,'pla_tu17_d'
            ,'pla_tu17_e'
            ,'pla_i7_bis'
            ,'pla_i8'
            ,'pla_i9'
            ,'pla_tso44'
            ,'pla_tso45'
            ,'pla_tso47'
            ,'pla_tso48a'
            ,'pla_tso48b'
            ,'pla_tso51'
            ,'pla_cptso37'
            ,'pla_tso41'
            ,'pla_t37sdo'
            ,'pla_tso39'
            ,'pla_tuso3'
            ,'pla_tuso4'
            ,'pla_tuso5'
            ,'pla_tuso6'
            ,'pla_tuso7'
            ,'pla_tuso8'
            ,'pla_tuso9'
            ,'pla_obs'
        )));    
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('procesamiento')){
           $editables[]='pla_t41'; 
           $editables[]='pla_t39_barrio';
           $editables[]='pla_t39_partido';
           $editables[]='pla_t39_otro';
           $editables[]='pla_t40bis_a1_otro';
           $editables[]='pla_t40bis_a2_otro'; 
           $editables[]='pla_t40bis_b_barrio'; 
           $editables[]='pla_t40bis_b_partido'; 
           $editables[]='pla_t40bis_b_otro'; 
           $editables[]='pla_t40bis_g6_otro'; 
           $editables[]='pla_t40bis_a3_4_esp';
           $editables[]='pla_ta4_esp';
           $editables[]='pla_tu3a';
           $editables[]='pla_tu8a';
           $editables[]='pla_tso48b_esp';
           $editables[]='pla_tso39_barrio';
           $editables[]='pla_tso39_partido';
           $editables[]='pla_tso39_otro';
           $editables[]='pla_tuso3a';
           $editables[]='pla_tuso8a';
           $editables[]='pla_obs_grilla_ti_co1';
        }   
        return $editables;
    }  
   
    function campos_a_listar($filtro_para_lectura){
        $array2=(!in_array("{$GLOBALS['NOMBRE_APP']}",['eah2024','etoi244','etoi251','etoi252','eah2025']))? array('pla_t39','pla_t39_barrio','pla_t39_partido','pla_t39_otro'):array('pla_t39');
        return array_merge(array('s1_p_semana','pla_enc', 'pla_hog','pla_mie',
                                /*'pla_participacion',*/'s1_p_bolsa','s1_p_estado',
                                /*'s1_p_area',*/'s1_p_cod_anacon',
                                's1_p_sexo','s1_p_edad',),
                $this->filtrar_campos_del_operativo(array_merge( array('s1_r0',
                    'pla_t28', 'pla_t30', 'pla_t30_1', 'pla_t35_0','pla_t44','pla_t45','pla_t47','pla_t51','pla_t37','pla_t41','pla_t37sd', 'pla_tsd3_0','pla_tsd7','pla_t40bis_a'),
                    $array2,
                    array('pla_tu3','pla_tu3a', 'pla_tu4','pla_tu5','pla_tu6','pla_tu7','pla_tu8','pla_tu8a','pla_tu9',
                    'pla_t40bis_a1','pla_t40bis_a1_otro',
                    'pla_t40bis_a2','pla_t40bis_a2_otro',
                    'pla_t40bis_b','pla_t40bis_b_barrio','pla_t40bis_b_partido','pla_t40bis_b_otro','pla_t40bis_d',
                    'pla_t40bis_f','pla_t40bis_g6','pla_t40bis_g6_otro',
                    'pla_t40bis_a3_1','pla_t40bis_a3_2','pla_t40bis_a3_3','pla_t40bis_a3_5','pla_t40bis_a3_4','pla_t40bis_a3_4_esp',
                    'pla_ts1','pla_ts2','pla_ts3','pla_ta1','pla_ta4','pla_ta4_esp','pla_tu16_a', 'pla_tu16_b','pla_tu16_c','pla_tu16_d' ,'pla_tu16_e','pla_tu17_a','pla_tu17_b','pla_tu17_c','pla_tu17_d','pla_tu17_e',
                    'pla_i7_bis','pla_i8','pla_i9',
                    'pla_tso44','pla_tso45','pla_tso47','pla_tso48a','pla_tso48b','pla_tso48b_esp','pla_tso51','pla_cptso37',
                    'pla_tso41',
                    'pla_t37sdo','pla_tso39','pla_tso39_barrio','pla_tso39_partido','pla_tso39_otro','pla_tuso3',
                    'pla_tuso3a','pla_tuso4','pla_tuso5','pla_tuso6','pla_tuso7','pla_tuso8','pla_tuso8a','pla_tuso9',
                    'pla_obs','pla_obs_grilla_ti_co1'
                    
                   )
                  )                   
                ));
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