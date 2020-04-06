<?php
//UTF-8:SÍ
/* Copiar este lo_imprescindible en todos los directorios 
   e incluirlo en todos los archivos .php (pero incluirlo sin especificar la carpeta)
*/
require_once "../tedede/lo_imprescindible.php"; // así marco la dependencia con tedede
set_include_path(get_include_path() . PATH_SEPARATOR . dirname(__FILE__));

?>