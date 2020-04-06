<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "esquemas.php";

class Esquema_his extends Esquema{
    function __construct(){
        $this->esquema_productivo=true;
        parent::__construct();
    }
}

?>