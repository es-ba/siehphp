<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_rama_ocupacion extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->clausula_where_agregada_manual="  and pla_t12 is distinct from 1  and  pla_t12 is distinct from 2  " ; 
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados= array_merge($heredados, array(
            's1_p_estado'
            ,'s1_p_bolsa'
            ,'pla_enc'
            ,'pla_hog'
            ,'pla_mie'
            ,'pla_exm'
            ,'s1_p_semana'
            // ,'s1_p_sexo'
            // ,'s1_p_edad'
        ), $this->filtrar_campos_del_operativo(array(
            's1_r0'
            ,'pla_t37'
            ,'pla_t37sd'
            ,'pla_t38'
            ,'pla_t39'
            ,'pla_t40a' 
            ,'pla_t40b'
            ,'pla_t41'
            ,'pla_t42'
            ,'pla_t37_cod2'
            ,'pla_t41_cod2'
            ,'pla_t43'
            ,'pla_tu10_1'
        )));    
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }  
    
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog','pla_mie',
                                's1_p_semana','s1_p_estado', 's1_p_bolsa'/*,
                                's1_p_sexo', 's1_p_edad'*/, ),
                $this->filtrar_campos_del_operativo(array(
                    's1_r0','pla_cond_activ', 'pla_categori',
                    'pla_rama1', 'pla_rama2','pla_t37_cod2', 'pla_obsrama', 
                    'pla_t37', 'pla_t37sd', 'pla_t38', 'pla_t39',
                    'pla_ocu1', 'pla_ocu2', 'pla_ocu3', 'pla_ocu4', 'pla_ocu5', 'pla_t41_cod2', 'pla_obsocu',                   
                    'pla_t40a', 'pla_t40b','pla_t41', 'pla_t42', 'pla_t43','pla_tu10_1'
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        //$this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_I1_");

        //$this->tabla->pla_t37_cod2=$this->tabla->pla_rama1.$this->tabla->pla_rama2;
        //$this->argumentos->campo['pla_t37_cod2']=$this->argumentos->campo['pla_rama1'].$this->argumentos->campo['pla_rama2'];
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