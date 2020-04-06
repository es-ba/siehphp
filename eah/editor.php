<?php
include "lo_necesario.php";
IniciarSesion();
$str=Incluir_tabla_editor('localStorage["parametro_editor.php"]','JSON.parse(localStorage["parametros_editor.php"]||"false")');
EnviarStrAlCliente($str);

?>