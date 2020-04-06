<?php
//UTF-8:SÍ 
$date_default_timezone_set = date_default_timezone_set('America/Argentina/Buenos_Aires');

$params=json_decode($_REQUEST['todo']);
$params->tra_line=escapeshellcmd($params->tra_line);
$params->tra_file=escapeshellcmd($params->tra_file);
file_put_contents('abrir.bat',"\"C:\\Archivos de programa\\Notepad++\\notepad++.exe\" -n{$params->tra_line} {$params->tra_file}");
$output='Abrir a mano el archivo ../tools/abrir.bat';
// $output=exec('abrir.bat');

echo json_encode(array('ok'=>true,'mensaje'=>$output));

?>