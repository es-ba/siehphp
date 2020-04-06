<?php
include "lo_necesario.php";
IniciarSesion();

$str="";
$str.=<<<HTML
<h1>Administrador del IPAD</h1>
<table id='estados_admin_ipad'>
</table>
<table id='botonera_admin_ipad'>
<tr><td><input type=button onclick='Mostrar_Estado_Ipad();' value=refrescar></tr>
<tr><td><input type=button onclick='Numerar_Ipad();' value="Numerar IPAD"></tr>
<tr><td><input type=button onclick='Cargar_Lote_a_Ipad();' value="Cargar un Lote"></tr>
<tr><td><a href='menu_ipad.php'>MENÚ IPAD</a></tr>
<tr><td><input type=button onclick='Descargar_Lote_desde_Ipad();' value="Descargar un Lote al servidor"></tr>
<tr><td><input type=button onclick='Borrar_Local_Storage_en_iPad();' value="Borrar la carga"></tr>
</table>
<div id='consola'>
</div>
<script>
Mostrar_Estado_Ipad();
</script>
HTML;

EnviarStrAlCliente($str);

?>