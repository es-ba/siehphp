<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_S1_variables_externas extends Grilla_tabla /*Grilla_respuestas_para_proc*/{
    function __construct(){
        parent::__construct();
    }
    /*
    function iniciar($nombre_del_objeto_base){
        parent::iniciar((substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015)?'pla_ext_hog':'S1_');
    } 
*/
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="tabla_plana_".$nombre_del_objeto_base;
        $vtabla='Tabla_plana_S1_';
        $vcondicion='';
        if (substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015) {
            $vtabla='Tabla_pla_ext_hog';
            $vmodo=($_SESSION['modo_encuesta']=='ETOI')?$_SESSION['modo_encuesta']:$GLOBALS['NOMBRE_APP'];
            $vcondicion=" and pla_modo='{$vmodo}'";
        }
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto($vtabla);
        list($this->tra_for,$this->tra_mat)=explode('_','S1_');
        $this->tabla->clausula_where_agregada_manual=$vcondicion;    
    }    
    function permite_grilla_sin_filtro(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        $campos_a_listar=array('pla_enc', 'pla_hog');
        $tabla_varcal=$this->contexto->nuevo_objeto('Tabla_varcal');
        $tabla_varcal->definir_orden_por_otra('varcal_orden');
        $tabla_varcal->leer_varios(array('varcal_ope'=>$GLOBALS['NOMBRE_APP'],'varcal_destino'=>'hog','varcal_activa'=>'true','varcal_tipo'=>'externo'));
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
