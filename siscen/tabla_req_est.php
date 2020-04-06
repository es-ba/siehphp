<?php
//UTF-8:SÍ
// require_once "tabla_formularios.php";
require_once "tablas.php";

class Tabla_req_est extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('reqest');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('reqest_reqest',array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('reqest_nombre',array('tipo'=>'texto','largo'=>50));
        $this->definir_campo('reqest_lado',  array('tipo'=>'enumerado','elementos'=>array('usuario','desarrollo','nadie')));
    }
}
?>