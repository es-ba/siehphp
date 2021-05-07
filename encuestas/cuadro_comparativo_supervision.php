<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_comparativo_supervision extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->tabla->tablas_lookup["
           (select s1.pla_enc p_enc, s1.pla_hog p_hog, s1.pla_respond, pla_t30, pla_t31_bis1,pla_t35, pla_t40bis_a, pla_t12_bis, pla_t18_1,pla_t19_1,
                   pla_comuna, pla_dominio, pla_semana, pla_estado, pla_rea, pla_norea, pla_norea_sup, pla_result_sup, 
                   pla_cod_enc, pla_cod_recu, pla_cod_sup, pla_sup_aleat, pla_sup_dirigida
           from plana_s1_ s1
           inner join plana_tem_ t on t.pla_enc=s1.pla_enc
           left join plana_i1_ i1  on i1.pla_enc=s1.pla_enc and i1.pla_hog=s1.pla_hog and i1.pla_mie=s1.pla_respond
          -- left join plana_s1_p s1p on i1.pla_enc=s1p.pla_enc and i1.pla_hog=s1p.pla_hog and i1.pla_mie=s1p.pla_mie
                ) i1
        "]="pla_enc=p_enc and pla_hog=p_hog ";
         $this->tabla->campos_lookup['pla_comuna']=false;
         $this->tabla->campos_lookup['pla_dominio']=false;
         $this->tabla->campos_lookup['pla_semana']=false;
         $this->tabla->campos_lookup['pla_estado']=false;
         $this->tabla->campos_lookup['pla_rea']=false;
         $this->tabla->campos_lookup['pla_norea']=false;
         $this->tabla->campos_lookup['pla_norea_sup']=false;
         $this->tabla->campos_lookup['pla_result_sup']=false;
         $this->tabla->campos_lookup['pla_cod_enc']=false;
         $this->tabla->campos_lookup['pla_cod_recu']=false;
         $this->tabla->campos_lookup['pla_cod_sup']=false;
         $this->tabla->campos_lookup['pla_sup_aleat']=false; 
         $this->tabla->campos_lookup['pla_sup_dirigida']=false;
         $this->tabla->campos_lookup['pla_t30']=false; 
         $this->tabla->campos_lookup['pla_respond']=false; 
         $this->tabla->campos_lookup['pla_t31_bis1']=false; 
         $this->tabla->campos_lookup['pla_t35']=false; 
         $this->tabla->campos_lookup['pla_t40bis_a']=false; 
         $this->tabla->campos_lookup['pla_t12_bis']=false; 
         $this->tabla->campos_lookup['pla_t18_1']=false; 
         $this->tabla->campos_lookup['pla_t19_1']=false;
         $this->tabla->clausula_where_agregada_manual=" and pla_sp1=1 ";         
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_respond','pla_enc', 'pla_hog','pla_dominio', 'pla_comuna','pla_semana', 'pla_estado', 'pla_cod_enc', 'pla_cod_recu', 'pla_cod_sup', 'pla_sup_aleat', 'pla_sup_dirigida', 'pla_rea', 'pla_norea','pla_result_sup', 'pla_norea_sup'),
            $this->filtrar_campos_del_operativo(array(
                 'pla_sp1','pla_t30', 'pla_spc1', 'pla_t31_bis1', 'pla_spc2','pla_t35', 'pla_spc3', 'pla_t40bis_a','pla_spc4','pla_t12_bis', 'pla_spc5', 'pla_t18_1', 'pla_spc6', 'pla_t19_1',	'pla_spc6_1'
            )));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_comuna';
        $heredados[]='pla_dominio';
        $heredados[]='pla_semana';
        $heredados[]='pla_estado';
        $heredados[]='pla_rea';
        $heredados[]='pla_norea';
        $heredados[]='pla_norea_sup';
        $heredados[]='pla_result_sup';
        $heredados[]='pla_cod_enc'; 
        $heredados[]='pla_cod_recu'; 
        $heredados[]='pla_cod_sup';
        $heredados[]='pla_sup_aleat'; 
        $heredados[]='pla_sup_dirigida';
        $heredados[]='pla_t31_bis1'; 
        $heredados[]='pla_t35'; 
        $heredados[]='pla_t40bis_a'; 
        $heredados[]='pla_t12_bis'; 
        $heredados[]='pla_t18_1'; 
        $heredados[]='pla_t19_1'; 
        return $heredados;
    }
     function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_SUP_");
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