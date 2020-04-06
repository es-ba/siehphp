<?php
//UTF-8:SÍ
/* Copiar este lo_imprescindible en todos los directorios 
   e incluirlo en todos los archivos .php (pero incluirlo sin especificar la carpeta)
*/
require_once "../tedede/lo_imprescindible.php";
set_include_path(get_include_path() . PATH_SEPARATOR . dirname(__FILE__));
if(!isset($GLOBALS['NOMBRE_APP'])){
    throw new Exception_Tedede("No esta declarada la variable global NOMBRE_APP");
} else{
    $GLOBALS['nombre_app']=strtolower($GLOBALS['NOMBRE_APP']); 
}
?>