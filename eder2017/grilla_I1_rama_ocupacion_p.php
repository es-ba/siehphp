<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_rama_ocupacion_p extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='tem_estado';
        $heredados[]='tem_bolsa';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
       // $heredados[]='s1_p_sexo';
       // $heredados[]='s1_p_edad';
       // $heredados[]='pla_t37';
       // $heredados[]='pla_t37sd';
       // $heredados[]='pla_t38';
       // $heredados[]='pla_t39';
        $heredados[]='pla_apadre6';
        $heredados[]='pla_apadre7';
        $heredados[]='pla_apadre8';
        $heredados[]='pla_apadre9';
        $heredados[]='pla_t37_cod2p';
        $heredados[]='pla_t41_cod2p';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }  
    
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie',
                                'tem_estado', 'tem_bolsa'/*,
                                's1_p_sexo', 's1_p_edad'*/, ),
                $this->filtrar_campos_del_operativo(array(
                    //'pla_cond_activ', 'pla_categori',
                    'pla_apadre8',
                    'pla_rama1p', 'pla_rama2p','pla_t37_cod2p',
                    'pla_apadre9',
                    'pla_rama1p', 'pla_rama2p','pla_t37_cod2p', 'pla_obsramap',
                    'pla_ocu1p', 'pla_ocu2p', 'pla_ocu3p', 'pla_ocu4p', 'pla_ocu5p', 'pla_t41_cod2p', 'pla_obsocup',
                    'pla_apadre7','pla_apadre6',
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->argumentos->campo['pla_t37_cod2p']=$this->argumentos->campo['pla_rama1p'].$this->argumentos->campo['pla_rama2p'];
        //Loguear('2015-04-20',"**********\n".$otravar);  
        return $this->responder_grabar_campo_directo();
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