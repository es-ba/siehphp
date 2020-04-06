<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_diccionario extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('dic');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('dic_dic', array('es_pk'=>true, 'tipo' => 'texto'));
        $this->definir_campo('dic_completo', array('tipo' => 'logico','def'=>false));
        $this->definir_tablas_hijas(array(
            'dictra'=>true,
            'dicvar'=>true
        ));
    }
}
?>