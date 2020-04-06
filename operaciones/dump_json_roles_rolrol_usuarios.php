<?php
set_include_path(get_include_path() . PATH_SEPARATOR . "../eah");
include "lo_necesario.php";

//$cursor=$db->ejecutar("SELECT tab_tab as tabla FROM tablas WHERE tab_raiz_json ORDER BY tab_orden,tab_tab");
$tablas=array('roles','rol_rol','usuarios');
/*
while($fila=$cursor->fetchObject()){
	$tablas[]=$fila->tabla;
}
*/
file_put_contents("empezo.tmp","Este archivo esta para ver a que hora empezo el json_dump");
file_put_contents("roles_rol_rol_usuarios_dump.json",json_dump('yeah',$tablas));
?>