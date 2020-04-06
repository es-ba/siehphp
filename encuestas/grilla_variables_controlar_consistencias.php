<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_variables_controlar_consistencias extends Grilla_vistas{
    function iniciar($base){
        return parent::iniciar('variables_controlar_consistencias');
    }
}
?>