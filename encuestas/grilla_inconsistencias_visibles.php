<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";
require_once "grilla_inconsistencias.php";

class Grilla_inconsistencias_visibles extends Grilla_inconsistencias{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar($nombre_del_objeto_base);
    }
    function campos_a_excluir($filtro_para_lectura){
        return array(
            'inc_ope',
            'inc_autor_justificacion',
            'inc_tlg',
            'inc_nivel',
            'inc_obs_consis',
        );  
    }
}

?>