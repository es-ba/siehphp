<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";


class Grilla_respuestas_para_proc_ind_empa extends Grilla_respuestas{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
        $this->tabla->campos_lookup=array(
            "t_bolsa"     =>true,
            "t_estado"    =>false,
            "t_cod_anacon"=>false,
            "t_fin_anacon"=>false,
            "t_etapa_pro" =>false,
          // "s1_p_sexo"=>false,
          // "s1_p_edad"=>false,
          //  "s1_p_f_nac_o"=>false, --esta variable no existe en EMPA
            "t_etapa_pro"=>false,
            "pla_v1"      =>false,            
            "pla_total_h" =>false,
            "pla_b_s"     =>false,
            "pla_mza"     =>false,
            "pla_lado"    =>false,
            "pla_rel_ue"  =>false,
            "pla_s1a1_obs" =>false,
            "pla_manzana_estatuto" =>false,
        );
        $this->tabla->tablas_lookup=array(            
          "(select t.pla_bolsa as t_bolsa, t.pla_estado as t_estado, t.pla_cod_anacon as t_cod_anacon,
                t.pla_fin_anacon as t_fin_anacon, t.pla_etapa_pro as t_etapa_pro, s1.pla_enc s1_enc,
                s1.pla_hog s1_hog, s1.pla_v1, s1.pla_total_h,
                pla_b_s, pla_mza, pla_lado, pla_rel_ue, pla_s1a1_obs, pla_manzana_estatuto
                from plana_tem_ t inner join plana_s1_ s1 on s1.pla_enc=t.pla_enc 
           ) s1"=>"pla_enc=s1_enc and pla_hog=s1_hog ",
        );
    }
}

class Grilla_empa_s1_p extends Grilla_respuestas_para_proc_ind_empa{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_P');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='t_estado';
        $heredados[]='pla_manzana_estatuto';
        $heredados[]='pla_b_s';
        $heredados[]='pla_mza';
        $heredados[]='pla_lado';
        $heredados[]='pla_rel_ue';
        $heredados[]='pla_s1a1_obs';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc',
            'pla_hog',
            'pla_mie',            
            't_estado'), 
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto',
                'pla_b_s',
                'pla_mza',
                'pla_lado',
                'pla_nombre',
                'pla_apellido',
                'pla_p4',
                'pla_sexo',
                'pla_edad',
                'pla_doc1',
                'pla_doc2',
                'pla_doc3',
                'pla_doc3_esp',
                'pla_doc4',
                'pla_s1a1_obs', 
                'pla_rel_ue',
                //'pla_obs_grilla_pi_s1p'
            ))
        );
    }
/* Segun la planilla:
enc	estado	b_s	mza	lado	nombre	apellido	p4	sexo	edad	doc1	doc2	doc3	doc3_esp	doc4	s1a1_obs	obs_grilla_pi
*/
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    /*
    function permite_grilla_sin_filtro(){
        return false;
    }
    */
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        //fijarse si puede grabar s1a1_obs
        $this->tabla_plana_s1_p=$this->contexto->nuevo_objeto("Tabla_plana_S1_P"); // para que esta esta sentencia, parece no usarse
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

class Grilla_documento extends Grilla_empa_s1_p{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_P');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
                'pla_nombre', 'pla_apellido','pla_p4', 'pla_sexo', 'pla_edad',
                'pla_doc1', 'pla_doc2', 'pla_doc3', 
                'pla_doc3_esp', 'pla_doc4', 'pla_s1a1_obs',
                'pla_obs_grilla_pi_s1p'
            );
        };
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(
            array('pla_enc','pla_hog', 'pla_mie', 't_estado'),
            $this->filtrar_campos_del_operativo(array(
                'pla_manzana_estatuto','pla_b_s','pla_mza', 'pla_lado',
                'pla_nombre', 'pla_apellido','pla_p4', 'pla_sexo', 'pla_edad',
                'pla_doc1', 'pla_doc2', 'pla_doc3', 
                'pla_doc3_esp', 'pla_doc4', 'pla_s1a1_obs',
                //'pla_rel_ue',
                'pla_obs_grilla_pi_s1p',
            )));   
    }
}

class Grilla_personas extends Grilla_empa_s1_p{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('S1_P');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $campos_solo_lectura_rol=array();
        if(!tiene_rol('programador') && !tiene_rol('procesamiento')){
            $campos_solo_lectura_rol=array(
                'pla_nombre', 'pla_apellido',
                'pla_p4',
                'pla_sexo',
                'pla_edad',
                'pla_p6_a',
                'pla_p6_b',
                'pla_s32',
                'pla_r2',
                'pla_r3',
                'pla_r4',
                'pla_r5',
                'pla_r6',
                'pla_r7',
                'pla_s1a1_obs',
                'pla_obs_grilla_pi_s1p',
            );
        };
        return array_merge($heredados,$campos_solo_lectura_rol);
    }
    function campos_a_listar($filtro_para_lectura){
        //enc	estado	b_s	mza	lado	p4	sexo	edad	p4	p6a	p6b	s32	r1	r2	r3	r4	r5	r6	r7	s1a1_obs	obs_grilla_pi
        return array_merge(array('pla_enc',
            'pla_hog',
            'pla_mie',
            't_estado'),
            $this->filtrar_campos_del_operativo(array('pla_manzana_estatuto','pla_b_s',
                'pla_mza',
                'pla_lado',
                'pla_nombre', 'pla_apellido',
                'pla_p4',
                'pla_sexo',
                'pla_edad',
                'pla_p6_a',
                'pla_p6_b',
                'pla_s32',
                'pla_r2',
                'pla_r3',
                'pla_r4',
                'pla_r5',
                'pla_r6',
                'pla_r7',
                'pla_s1a1_obs',
                'pla_obs_grilla_pi_s1p', /// tiene que ser un campo propio de s1p 
            ))
        );
    }
}

?>