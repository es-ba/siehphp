<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_his_inconsistencias extends Tabla{
    function definicion_estructura(){  
        $this->definir_prefijo('hisinc');
        $this->heredar_en_cascada=true;
        $this->definir_esquema('his');
        $this->definir_campo('hisinc_ope',array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('hisinc_con',array('tipo'=>'texto','es_pk'=>true));
        foreach(nombres_campos_claves('hisinc_','N') as $campo){
            $this->definir_campo($campo,array('es_pk'=>true,'tipo'=>'entero'));
        }
        $this->definir_campo('hisinc_variables_y_valores',array('tipo'=>'texto'));
        $this->definir_campo('hisinc_justificacion',array('tipo'=>'texto','largo'=>500));
        $this->definir_campo('hisinc_autor_justificacion',array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('hisinc_obs_consis',array('tipo'=>'texto', 'largo'=>500));
    }
}
    
?>