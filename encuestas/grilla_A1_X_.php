<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_A1_X_abiertas extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('A1_X');
        $this->tabla->campos_lookup["a1_x5"]=false;
        $this->tabla->campos_lookup["a1_x5_tot"]=false;
        $this->tabla->tablas_lookup=array(            
            '(select t.pla_bolsa as tem_bolsa, t.pla_cod_anacon as tem_cod_anacon, t.pla_etapa_pro as pla_etapa_pro, t.pla_estado as tem_estado, a.pla_enc as a1_enc, a.pla_hog as a1_hog, a.pla_mie as 
            a1_mie, a.pla_exm as a1_exm,  pla_x5 as a1_x5, pla_x5_tot as a1_x5_tot
                 from plana_a1_ a
                 inner join plana_tem_ t on t.pla_enc=a.pla_enc) a1'=>'pla_enc=a1_enc and pla_hog=a1_hog and pla_mie=a1_mie',
        );
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='pla_sexo_ex';
        $heredados[]='pla_pais_nac';
        $heredados[]='pla_edad_ex';
        $heredados[]='pla_niv_educ';
        $heredados[]='pla_anio';    
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_lugar';
        $heredados[]='a1_x5';
        $heredados[]='a1_x5_tot';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array(
        'pla_enc',
        'pla_hog',
        'pla_mie',
        'pla_exm',
        'tem_bolsa',
        'tem_estado',
        'a1_x5',
        'a1_x5_tot',
        'pla_sexo_ex',
        'pla_pais_nac',
        'pla_edad_ex',
        'pla_niv_educ',
        'pla_anio',
        'pla_lugar',
        'pla_lugar_esp1',
        'pla_lugar_esp2',
        'pla_lugar_esp3',        
        );
    }   
    function permite_grilla_sin_filtro_manual(){
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
?>