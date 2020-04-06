<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "proceso_login_base.php";
require_once "proceso_login.php";

class Proceso_login_dual extends Proceso_login{
    function correr(){
        parent::correr();
        $this->salida->enviar_script('clave_a_enviar_para_login_dual=true;');
    }
}

?>