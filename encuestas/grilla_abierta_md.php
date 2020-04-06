<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_abierta_md extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->tablas_lookup["
           (select p.pla_enc as s1p_enc, p.pla_hog as s1p_hog, p.pla_mie as s1p_mie, p.pla_exm as s1p_exm, p.pla_sexo as pla_sexo, p.pla_edad as pla_edad, 
                   p.pla_e2, p.pla_e6a, p.pla_e12a, p.pla_sn1b_1, p.pla_sn1b_7, p.pla_sn1b_2, p.pla_sn1b_3, p.pla_sn1b_4, p.pla_sn1b_5,
                   s1.pla_jht1, s1.pla_jht2, s1.pla_jht3                   
              from plana_s1_p p
              inner join plana_s1_ s1 on s1.pla_enc=p.pla_enc and s1.pla_hog=p.pla_hog) s1p
        "]="pla_enc=s1p_enc and pla_hog=s1p_hog and pla_mie=s1p_mie and pla_exm=s1p_exm";
        $this->tabla->campos_lookup['pla_sexo']=false;
        $this->tabla->campos_lookup['pla_edad']=false;
        $this->tabla->campos_lookup['pla_e2']=false;
        $this->tabla->campos_lookup['pla_e6a']=false;
        $this->tabla->campos_lookup['pla_e12a']=false;
        $this->tabla->campos_lookup['pla_sn1b_1']=false;
        $this->tabla->campos_lookup['pla_sn1b_7']=false;
        $this->tabla->campos_lookup['pla_sn1b_2']=false;
        $this->tabla->campos_lookup['pla_sn1b_3']=false;
        $this->tabla->campos_lookup['pla_sn1b_4']=false;
        $this->tabla->campos_lookup['pla_sn1b_5']=false;
        $this->tabla->campos_lookup['pla_jht1']=false;
        $this->tabla->campos_lookup['pla_jht2']=false;
        $this->tabla->campos_lookup['pla_jht3']=false;  
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='tem_bolsa';
        $heredados[]='tem_estado';
        $heredados[]='tem_cod_anacon';
        $heredados[]='pla_etapa_pro';
        $heredados[]='pla_sexo';
        $heredados[]='pla_edad';
        $heredados[]='pla_e2';
        $heredados[]='pla_e6a';
        $heredados[]='pla_e12a';
        $heredados[]='pla_sn1b_1';
        $heredados[]='pla_sn1b_7';
        $heredados[]='pla_sn1b_2';
        $heredados[]='pla_sn1b_3';
        $heredados[]='pla_sn1b_4';
        $heredados[]='pla_sn1b_5';
        $heredados[]='pla_jht1';
        $heredados[]='pla_jht2'; 
        $heredados[]='pla_jht3';   
        $heredados[]='pla_t1';
        $heredados[]='pla_t2';
        $heredados[]='pla_t3'; 
        $heredados[]='pla_t30';
        $heredados[]='pla_t31';
        $heredados[]='pla_sn15a1'; 
        $heredados[]='pla_sn15a2'; 
        $heredados[]='pla_sn15a3'; 
        $heredados[]='pla_sn15a4'; 
        $heredados[]='pla_sn15a5';
        $heredados[]='pla_sn15a6'; 
        $heredados[]='pla_sn15a7';
        $heredados[]='pla_sn15a8'; 
        $heredados[]='pla_sn15a9';
        $heredados[]='pla_sn15a10';
        $heredados[]='pla_sn15a11';
        $heredados[]='pla_sn15a12';
        $heredados[]='pla_sn15a13';
        $heredados[]='pla_sn15a14';
        $heredados[]='pla_sn15a15';
        $heredados[]='pla_sn15a16';
        $heredados[]='pla_sn15a17';
        $heredados[]='pla_sn15a33';
        $heredados[]='pla_sn15a18';
        $heredados[]='pla_sn15a29';
        $heredados[]='pla_sn15a30';
        $heredados[]='pla_sn15a19';
        $heredados[]='pla_sn15a20';
        $heredados[]='pla_sn15a21';
        $heredados[]='pla_sn15a22';
        $heredados[]='pla_sn15a23';
        $heredados[]='pla_sn15a25';
        $heredados[]='pla_sn15a26';
        $heredados[]='pla_sn15a27';
        $heredados[]='pla_sn15a31';
        $heredados[]='pla_sn15a28';
        $heredados[]='pla_md2';
        $heredados[]='pla_md11';
        $heredados[]='pla_ghq12_1';
        $heredados[]='pla_ghq12_2';
        $heredados[]='pla_ghq12_3';
        $heredados[]='pla_ghq12_4';
        $heredados[]='pla_ghq12_5';
        $heredados[]='pla_ghq12_6';
        $heredados[]='pla_ghq12_7';
        $heredados[]='pla_ghq12_8';
        $heredados[]='pla_ghq12_9';
        $heredados[]='pla_ghq12_10';
        $heredados[]='pla_ghq12_11';
        $heredados[]='pla_ghq12_12';
        $heredados[]='pla_sn19';
        $heredados[]='pla_sn20';
        $heredados[]='pla_sn21_1';
        $heredados[]='pla_sn21_2';
        $heredados[]='pla_sn21_3';
        $heredados[]='pla_sn21_4';
        $heredados[]='pla_sn23';
        $heredados[]='pla_sn24';
        $heredados[]='pla_sn25a';
        $heredados[]='pla_sn25b';
        $heredados[]='pla_sn25c';
        $heredados[]='pla_sn25d';
        $heredados[]='pla_sn25e';
        $heredados[]='pla_sn25f';
        
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog', 'pla_mie', 'tem_bolsa', 'tem_estado', 'tem_cod_anacon','pla_etapa_pro',
                     'pla_sexo', 'pla_edad', 'pla_e2', 'pla_e6a', 'pla_e12a', 'pla_sn1b_1', 'pla_sn1b_7', 'pla_sn1b_2',
                     'pla_sn1b_3', 'pla_sn1b_4', 'pla_sn1b_5', 'pla_jht1', 'pla_jht2', 'pla_jht3', 'pla_t1', 'pla_t2', 
                     'pla_t3', 'pla_t30', 'pla_t31', 'pla_sn15a1', 'pla_sn15a2', 'pla_sn15a3', 'pla_sn15a4', 'pla_sn15a5',
                     'pla_sn15a6', 'pla_sn15a7', 'pla_sn15a8', 'pla_sn15a9', 'pla_sn15a10', 'pla_sn15a11', 'pla_sn15a12',
                     'pla_sn15a13', 'pla_sn15a14', 'pla_sn15a15', 'pla_sn15a16', 'pla_sn15a17', 'pla_sn15a33', 'pla_sn15a18',
                     'pla_sn15a29', 'pla_sn15a30', 'pla_sn15a19', 'pla_sn15a20', 'pla_sn15a21', 'pla_sn15a22', 'pla_sn15a23',
                     'pla_sn15a25', 'pla_sn15a26', 'pla_sn15a27', 'pla_sn15a31', 'pla_sn15a28', 'pla_sn15a28_esp', 'pla_md2',
                     'pla_md11', 'pla_md11_esp', 'pla_ghq12_1', 'pla_ghq12_2', 'pla_ghq12_3', 'pla_ghq12_4', 'pla_ghq12_5',
                     'pla_ghq12_6', 'pla_ghq12_7', 'pla_ghq12_8', 'pla_ghq12_9', 'pla_ghq12_10', 'pla_ghq12_11','pla_ghq12_12', 
                     'pla_sn19', 'pla_sn20', 'pla_sn21_1', 'pla_sn21_2', 'pla_sn21_3', 'pla_sn21_4', 'pla_sn23', 'pla_sn24',
                     'pla_sn24_12', 'pla_sn25a', 'pla_sn25b', 'pla_sn25c', 'pla_sn25d', 'pla_sn25e', 'pla_sn25f',  
        );
    }   
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
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