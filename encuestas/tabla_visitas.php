<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_visitas extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('vis');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        //$this->definir_campo('vis_ope',array('hereda'=>'operativos','modo'=>'pk'));
        $this->definir_campo('vis_enc',array('es_pk'=>true, 'tipo'=>'entero'));
        $this->definir_campo('vis_nro',array('tipo'=>'entero'));
        $this->definir_campo('vis_hora',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('vis_fecha',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('vis_obs',array('tipo'=>'texto','largo'=>1000));
        $this->definir_campos_orden('vis_enc');
    }
}

?>