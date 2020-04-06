<?php
//UTF-8:SÍ
// require_once "tabla_formularios.php";
require_once "tablas.php";

class Tabla_req_est_flu extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('reqestflu');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('reqestflu_origen', array('hereda'=>'req_est','modo'=>'pk','campo_relacionado'=>'reqest_reqest'));
        $this->definir_campo('reqestflu_accion', array('es_pk'=>true,'tipo'=>'texto','largo'=>50));
        $this->definir_campo('reqestflu_destino',array('hereda'=>'req_est','modo'=>'pk','campo_relacionado'=>'reqest_reqest'));
        $this->definir_campo('reqestflu_comentario_obligatorio',array('tipo'=>'logico','def'=>false));
    }
}
?>