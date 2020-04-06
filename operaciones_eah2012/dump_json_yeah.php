<?php
set_include_path("." . PATH_SEPARATOR . "../eah2012". PATH_SEPARATOR . get_include_path() );
$HTTP_USER_AGENT_LOCAL='local';

$nombre_app='eah2012';
$NOMBRE_APP='EAH2012';

$archivo_configuracion_local="./configuracion_local.php";

include "lo_imprescindible.php";
require_once("../tedede/pdo_con_excepciones.php");
require_once("../tedede/json_dumper.php");

global $db;

$tablas=array("operativos");

$jerarquia=array(
    'con_opc'=>'operativos',
    'formularios'=>'operativos',
    'bloques'=>'formularios',
    'matrices'=>'formularios',
    'filtros'=>'bloques',
    'preguntas'=>'bloques',
    'variables'=>'preguntas', 
    'saltos'=>'variables',
    'opciones'=>'con_opc',
);

file_put_contents("empezo.tmp","Este archivo esta para ver a que hora empezo el json_dump");
file_put_contents("yeah_dump.json",json_dump('eah2012',$tablas,$jerarquia,array(),0,array('tlg'=>true)));
?>