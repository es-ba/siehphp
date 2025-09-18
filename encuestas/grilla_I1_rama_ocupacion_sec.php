<?php
//UTF-8:SÍ
require_once 'lo_imprescindible.php';
require_once 'grilla_respuestas.php';
require_once 'grilla_TEM.php';

class Grilla_I1_rama_ocupacion_sec extends Grilla_respuestas_para_proc_ind{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
        $this->tabla->clausula_where_agregada_manual='  and pla_t12 is distinct from 1  and  pla_t12 is distinct from 2  ' ; 
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
            ,'pla_cond_activ'
        ), $this->filtrar_campos_del_operativo(array(
            's1_r0'
            ,'pla_categori_os'
            ,'pla_cptso37_cod'
            ,'pla_cptso37'
            ,'pla_t37sdo'
            ,'pla_tso38'
            ,'pla_tso39'
            ,'pla_tso41_cod2'
            ,'pla_tso40_1'
            ,'pla_tso40b'
            ,'pla_tso41'
            ,'pla_tso42'
            ,'pla_tso43'
            ,'pla_tuso9'
            ,'pla_tuso10_1'
        )));    
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }  
    
    function campos_a_listar($filtro_para_lectura){
        return array_merge(
                array('pla_enc', 'pla_hog','pla_mie'),
                $this->filtrar_campos_del_operativo(array('s1_r0')),
                array('s1_p_semana','s1_p_estado','s1_p_bolsa'),
                $this->filtrar_campos_del_operativo(array(
                    'pla_cond_activ', 'pla_categori_os',
                    'pla_rama1_sec', 'pla_rama2_sec','pla_cptso37_cod', 'pla_obsrama_sec', 
                    'pla_cptso37', 'pla_t37sdo', 'pla_tso38', 'pla_tso39',
                    'pla_ocu1_sec', 'pla_ocu2_sec', 'pla_ocu3_sec', 'pla_ocu4_sec', 'pla_ocu5_sec', 'pla_tso41_cod2', 'pla_obsocu_sec',                   
                    'pla_tso40_1', 'pla_tso40b','pla_tso41', 'pla_tso42', 'pla_tso43','pla_tuso9', 'pla_tuso10_1'
                )));
    }
    function permite_grilla_sin_filtro_manual(){
        return false;
    }
    function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        //$this->tabla_plana_i1=$this->contexto->nuevo_objeto('Tabla_plana_I1_');

        //$this->tabla->pla_t37_cod2=$this->tabla->pla_rama1.$this->tabla->pla_rama2;
        //$this->argumentos->campo['pla_t37_cod2']=$this->argumentos->campo['pla_rama1'].$this->argumentos->campo['pla_rama2'];
        //Loguear('2015-04-20','**********\n'.$otravar);  
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
