<?php
set_include_path(get_include_path() . PATH_SEPARATOR . "../pp2012");
$no_ejecutar_aplicacion="voy a hacer un json_dump y no correr toda la aplicación";
include "../pp2012/pp2012.php";

file_put_contents("empezo.tmp","Este archivo esta para ver a que hora empezo el json_dump");
$jerarquia=array(
    'ua'=>'operativos',
    'con_opc'=>'operativos',
    'opciones'=>'con_opc',
    'formularios'=>'operativos',
    'matrices'=>'formularios',
    'bloques'=>'formularios',
    'filtros'=>'formularios',
    'preguntas'=>'formularios',
    'variables'=>'preguntas',
    'saltos'=>'variables',
//    'consistencias'=>'operativos',
//    'con_var'=>'consistencias',
//    'ano_con'=>'consistencias',    
);
file_put_contents("pp2012_dump.json",$guardare=json_dump('encu',array('relaciones','estados_ingreso','operativos'),$jerarquia));
/*
$json=json_decode($intermedio=json_arreglar($guardare),true);
$json_operativos=$json['tablas']['operativos'];
file_put_contents("pp2012_dump_via_json.sql",json_generar_insert('encu','operativos',$json_operativos,";\n",$json['jerarquia']));
// */
?>