<?php
include "es_chrome.php";
Detectar_Ipad();
$formulario=@$_REQUEST['usar'];
$matriz=@$_REQUEST['matriz']?:'';
$para_ipad=$_SESSION['ipad']?1:0;
if($formulario=='S1' && !$matriz && FALSE){
	header("Location: generar_despliegue_formulario.php?usar={$formulario}&matriz={$matriz}");
}else{
	$contenido=file_get_contents($var="gen/formulario_{$formulario}_{$matriz}_i{$para_ipad}.php");
	echo $contenido;
	// echo $var;
}

// repito la funci�n porque no est� el include

?>