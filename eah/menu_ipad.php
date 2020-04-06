<?php
include "lo_necesario.php";
IniciarSesion();

$str=<<<HTML
<H1>IPAD <script>
document.write(localStorage['numero_de_ipad']);
</script> - MENÚ PRINCIPAL
</H1>
<table id=encuestas_a_ingresar>
</table>
<script>
document.onload=Refresacar_encuestas_a_ingresar();
</script>
HTML;

EnviarStrAlCliente($str,array('para ipad'=>true));
?>