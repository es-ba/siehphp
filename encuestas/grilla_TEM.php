<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
//require_once "vista_varmae.php";

// require_once "grilla_up.php";

class Grilla_TEM extends Grilla_respuestas{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('TEM_');
        $this->tabla->campos_lookup=array(
                    "pla_periodicidad"=>false,
                );
        $this->tabla->tablas_lookup=array(            
                    '(select pla_enc as tem_enc, dbo.periodicidad(pla_rotaci_n_etoi,pla_dominio) as pla_periodicidad from plana_tem_) tem'=>'pla_enc=tem_enc',
                );        
    }
    function campos_a_excluir($filtro_para_lectura){
        $excluir_claves=nombres_campos_claves("pla_","N");
        array_shift($excluir_claves);
        return array_merge($excluir_claves,array(
        'pla_id_marco',
        'pla_frac_comun',
        'pla_radio_comu',
        'pla_mza_comuna',
        'pla_clado',
        'pla_h1',
        'pla_usp',
        'pla_ccodigo',
        'pla_idcuerpo',
        'pla_nomb_inst',
        'pla_tot_hab',
        'pla_pzas',
        'pla_idprocedencia',
        'pla_procedencia',
        'pla_yearfuente',
        'pla_tbldomicilios_zona',
        'pla_tbldomicilios_fiscalias',
        'pla_polifiscalias_fiscalias',
        ));  
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_comuna';
        $heredados[]='pla_replica';
        $heredados[]='pla_up';
        $heredados[]='pla_lote';
        if(!tiene_rol('subcoor_campo')){
            $heredados[]='pla_cnombre';
            $heredados[]='pla_hn';           
        }
        $heredados[]='pla_hp';
        $heredados[]='pla_hd';
        $heredados[]='pla_hab';
        $heredados[]='pla_h4';
        $heredados[]='pla_barrio';
        $heredados[]='pla_ident_edif';
        //$heredados[]='pla_obs';
        $heredados[]='pla_dominio';
        $heredados[]='pla_marco';
        $heredados[]='pla_zona';
        $heredados[]='pla_estado';
        $heredados[]='pla_fecha_carga_enc';
        $heredados[]='pla_fecha_primcarga_enc';
        $heredados[]='pla_fecha_descarga_enc';
        $heredados[]='pla_comenzo_ingreso';
        $heredados[]='pla_sup_campo';
        $heredados[]='pla_comenzo_consistencias';
        $heredados[]='pla_cantidad_inconsistencias';
        return $heredados;
    }
    function responder_grabar_campo(){
        $this->tabla_tem=$this->contexto->nuevo_objeto("Tabla_tem");
        if($this->tabla_tem->existe_campo(cambiar_prefijo($this->argumentos->campo,'pla_','tem_'))){
            return $this->responder_grabar_campo_directo();
        }else{
            return parent::responder_grabar_campo();
        }
        // Grilla_tabla::responder_grabar_campo();
    }
    function obtener_otros_atributos_y_completar_fila(&$fila,&$atributos_fila){
        parent::obtener_otros_atributos_y_completar_fila($fila,$atributos_fila);
        if($fila['pla_estado']){
            // $atributos_fila['pla_estado']['style']='background-color:#'.$fila['pla_estado'].'F'; 
            $color_proc=$fila['pla_estado']>=70?255:200;
            $atributos_fila['pla_estado']['style']='background-color:rgb('.(255-$color_proc).','.($color_proc).','.(255-$fila['pla_estado']*2).')'; 
        }else{
            $atributos_fila['pla_estado']['clase']='columna_estado';
        }
    }
    function cantidadColumnasFijas(){
        return 1;
    }
}

class Grilla_respuestas_para_proc extends Grilla_respuestas{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
        $this->tabla->campos_lookup=array(
            "tem_bolsa"=>true,
            "tem_estado"=>false,
            "tem_cod_anacon"=>false,
            "pla_etapa_pro"=>false,
        );
        $this->tabla->tablas_lookup=array(            
            '(select pla_enc as tem_enc, pla_bolsa as tem_bolsa, pla_estado as tem_estado, pla_cod_anacon as tem_cod_anacon, pla_etapa_pro as pla_etapa_pro from plana_tem_) tem'=>'pla_enc=tem_enc',
        );
    }
    function responder_grabar_campo(){
        $this->tabla_este_for=$this->tabla;
        if(FALSE/*SI NO ESTÁ EN LA TABLA VARIABLES*/){
            return $this->responder_grabar_campo_directo(); // directo a la plana
        }else{
            return parent::responder_grabar_campo(); // a través de la tabla respuestas
        }
    }
}

class Grilla_respuestas_para_proc_ind extends Grilla_respuestas{
    // OJO HAY QUE HACERLA HEREDAR DE Grilla_respuestas_para_proc
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
        $this->tabla->campos_lookup=array(
            "s1_p_bolsa"=>true,
            "s1_p_estado"=>false,
            "s1_p_cod_anacon"=>false,
            "s1_p_fin_anacon"=>false,
            "s1_p_etapa_pro"=>false,
            "s1_p_semana"=>false,
            "s1_p_area"=>false, 
            "s1_p_cod_enc"=>false, 
            "s1_p_cod_recu"=>false, 
            "s1_p_recepcionista"=>false,            
            "s1_p_sexo"=>false,
            "s1_p_edad"=>false,
            "s1_p_f_nac_o"=>false,
            "s1_p_etapa_pro"=>false,
            "s1_v1"=>false,            
            "s1_total_h"=>false,
        );
        $this->tabla->tablas_lookup=array(            
          "(select t.pla_bolsa as s1_p_bolsa, t.pla_estado as s1_p_estado, t.pla_cod_anacon as s1_p_cod_anacon, t.pla_fin_anacon as s1_p_fin_anacon, t.pla_etapa_pro as s1_p_etapa_pro, 
           t.pla_semana as s1_p_semana, t.pla_area as s1_p_area, t.pla_cod_enc as s1_p_cod_enc, t.pla_cod_recu as s1_p_cod_recu, t.pla_recepcionista as s1_p_recepcionista,
           p.pla_enc as s1_p_enc, p.pla_hog as s1_p_hog, p.pla_mie as s1_p_mie, p.pla_exm as s1_p_exm ,pla_sexo as s1_p_sexo, pla_edad as s1_p_edad, {$GLOBALS['PLA_F_NAC_O']} as s1_p_f_nac_o
           , s1.pla_v1 as s1_v1, s1.pla_total_h as s1_total_h
                 from plana_s1_p p
                 inner join plana_tem_ t on t.pla_enc=p.pla_enc 
                 inner join plana_s1_ s1 on s1.pla_enc=p.pla_enc and s1.pla_hog=p.pla_hog
           ) s1_p"=>"pla_enc=s1_p_enc and pla_hog=s1_p_hog and pla_mie=s1_p_mie and pla_exm=s1_p_exm",
        );
    }
}

class Grilla_S1_  extends Grilla_respuestas_para_proc{}
class Grilla_S1_P extends Grilla_respuestas_para_proc{}
class Grilla_I1_  extends Grilla_respuestas_para_proc{}
class Grilla_A1_  extends Grilla_respuestas_para_proc{}
class Grilla_A1_X extends Grilla_respuestas_para_proc{}
class Grilla_GH_  extends Grilla_respuestas_para_proc{}
//class Grilla_PMD_ extends Grilla_respuestas_para_proc{}
?>