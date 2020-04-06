<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tipo_req extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tiporeq');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tiporeq_tiporeq',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('tiporeq_nombre' ,array('tipo'=>'texto','largo'=>100,'not_null'=>true,'mostrar_al_elegir'=>true));
    }
}    
?>