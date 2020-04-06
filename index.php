<?php
//UTF-8:SÍ

if(file_exists('ruta_principal.txt')){
	$ruta=file_get_contents('ruta_principal.txt');
    header('Location: '.$ruta);
	die();
}

$ruta=__DIR__; 
$partes_ruta = preg_split('/[\\/]/', $ruta);
$cuantas_partes = count($partes_ruta);
if ($cuantas_partes>1) {
    $carpeta=$partes_ruta[$cuantas_partes-1];
    if (substr($carpeta,0,9)!='alserver_' || strlen($carpeta)<10){
        echo 'Sistema no instalado (cod 4)'; // la carpeta no comienza con alserver_
    }else{
        $carpeta_aplicacion=substr($carpeta,9);
        if (!file_exists($carpeta_aplicacion)) {
            echo 'Sistema no instalado (cod 3)'; // no existe la carpeta de la aplicacion
        }else{        
            if (!file_exists($carpeta_aplicacion.'/configuracion_local.php')) {
                echo 'Sistema no instalado (cod 2)'; // falta el archivo configuracion_local.php
            }else{
                header('Location: '.$carpeta_aplicacion.'/'.$carpeta_aplicacion.'.php');
            }
        }
    }
}else{
    echo 'Sistema no instalado (cod 1)'; // error en la ruta
}

?>
