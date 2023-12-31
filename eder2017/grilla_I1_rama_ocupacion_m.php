<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_rama_ocupacion_m extends Grilla_respuestas_para_proc{
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
        $heredados[]='pla_amadre6';
        $heredados[]='pla_amadre7';
        $heredados[]='pla_amadre8';
        $heredados[]='pla_amadre9';
        $heredados[]='pla_t37_cod2m';
        $heredados[]='pla_t41_cod2m';
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
                    'pla_amadre8',
                    'pla_rama1m', 'pla_rama2m','pla_t37_cod2m',
                    'pla_amadre9',
                    'pla_rama1m', 'pla_rama2m','pla_t37_cod2m', 'pla_obsramam',
                    'pla_ocu1m', 'pla_ocu2m', 'pla_ocu3m', 'pla_ocu4m', 'pla_ocu5m', 'pla_t41_cod2m', 'pla_obsocum',
                    'pla_amadre7','pla_amadre6',
                    //'pla_obsrama', 
                    //'pla_t37', 'pla_t37sd', 'pla_t38', 'pla_t39',
                    //'pla_ocu1', 'pla_ocu2', 'pla_ocu3', 'pla_ocu4', 'pla_ocu5', 'pla_t41_cod2', 'pla_obsocu',                   
                    //'pla_t40a', 'pla_t40b','pla_t41', 'pla_t42', 'pla_t43',
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        //$this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_I1_");

        //$this->tabla->pla_t37_cod2=$this->tabla->pla_rama1.$this->tabla->pla_rama2;
        $this->argumentos->campo['pla_t37_cod2m']=$this->argumentos->campo['pla_rama1m'].$this->argumentos->campo['pla_rama2m'];
        //$this->argumentos->campo['pla_t41_cod2m']=$this->argumentos->campo['pla_ocu1m'].$this->argumentos->campo['pla_ocu2m'].$this->argumentos->campo['pla_ocu3m'].$this->argumentos->campo['pla_ocu4m'].$this->argumentos->campo['pla_ocu5m'];
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