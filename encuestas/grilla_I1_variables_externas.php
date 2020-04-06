<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_I1_variables_externas extends Grilla_respuestas_para_proc{
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('I1_');
    }   
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        $campos_a_listar=array('pla_enc', 'pla_hog','pla_mie');
        $tabla_varcal=$this->contexto->nuevo_objeto('Tabla_varcal');
        $tabla_varcal->definir_orden_por_otra('varcal_orden');
        $tabla_varcal->leer_varios(array('varcal_ope'=>$GLOBALS['NOMBRE_APP'],'varcal_destino'=>'mie','varcal_activa'=>'true','varcal_tipo'=>'externo'));
        while($tabla_varcal->obtener_leido()){
            $campos_a_listar[]='pla_'.$tabla_varcal->datos->varcal_varcal;
        }
        return $campos_a_listar;
    } 
    function responder_grabar_campo(){
        return $this->responder_grabar_campo_directo();
    }
}

?>