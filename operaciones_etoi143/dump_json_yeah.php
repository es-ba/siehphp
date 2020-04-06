<?php
set_include_path(get_include_path() . PATH_SEPARATOR . "../etoi143");

$nombre_app='etoi143';
$NOMBRE_APP='etoi143';

require_once "lo_imprescindible.php";
require_once "pdo_con_excepciones.php";
require_once "json_dumper.php";

/*
$cursor=$db->ejecutar("SELECT tab_tab as tabla FROM tablas WHERE tab_raiz_json ORDER BY tab_orden,tab_tab");
$tablas=array();
while($fila=$cursor->fetchObject()){
	$tablas[]=$fila->tabla;
}
*/

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

file_put_contents("yeah_dump.json",json_dump('encu',array('operativos'),$jerarquia));
?>