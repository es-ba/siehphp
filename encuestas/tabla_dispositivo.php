<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_dispositivo extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dis');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dis_dis',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('dis_descripcion',array('tipo'=>'texto','largo'=>50,'mostrar_al_elegir'=>true)); 
    }
}
?>