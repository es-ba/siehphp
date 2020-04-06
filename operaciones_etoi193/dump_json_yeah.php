<?php
set_include_path(get_include_path() . PATH_SEPARATOR . "../etoi193");

$nombre_app='etoi193';
$NOMBRE_APP='etoi193';

require_once "lo_imprescindible.php";

$parametros_db->user='tedede_php';
$parametros_db->pass='laclave';
$parametros_db->base_de_datos='etoi193_produc_db';
$parametros_db->port='5432';
$parametros_db->host='10.32.72.10';

require_once "pdo_con_excepciones.php";
require_once "json_dumper.php";

file_put_contents("empezo.tmp","Este archivo esta para ver a que hora empezo el json_dump");

$jerarquia=array(
'ua'=>'operativos',
'con_opc'=>'operativos',
'formularios'=>'operativos',
'matrices'=>'formularios',
'bloques'=>'matrices',
'filtros'=>'bloques',
'preguntas'=>'bloques',
'variables'=>'preguntas',
'opciones'=>'con_opc',
'saltos'=>'variables',
);

$que_tablas=array('operativos');

if("tambien poner otros metadatos importantes"){
    $que_tablas=array_merge(
        $que_tablas,
        array(
            'a_ingreso',
            'con_momentos',
            'diccionario',
            'dicvar',
            'dictra',
            'dispositivo',
            'dominio',
            'estados_ingreso',
            'importancia',
            'planillas',
            'replica',
            'result_sup',
            'roles', 
            'tabulados',
            'tipo_nov',
            'verificado',
            'volver_a_cargar'
        )
    );
    $jerarquia+=array(
        'baspro'=>'operativos',
        'baspro_var'=>'baspro',
        'consistencias'=>'operativos',
        'estados'=>'operativos',
        'est_rol'=>'estados', 
        'est_var'=>'estados', 
        'pla_est'=>'planillas',
        'pla_var'=>'planillas',
        'rol_pla'=>'roles',
        'rol_rol'=>'roles',
        'semanas'=>'operativos',
        'varcal'=>'operativos',
        'varcalopc'=>'varcal'
    );
}

file_put_contents("yeah_dump.json",json_dump('encu',$que_tablas,$jerarquia));
?>