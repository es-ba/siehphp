<?php
include "lo_necesario.php";
IniciarSesion();

$str="";

$str.=<<<HTML
	<br>
	<h2>Ingreso de encuestas</h2>
	<form id=elegir_vivienda name=elegir_vivienda>
	<table>
HTML;

foreach($campos_identificacion_completa_encuesta as $campo=>$def){
	$str=str_replace('DESTINO_ENTER',$campo,$str);
	$str.=<<<HTML
		<tr><td><label for='$campo'>{$def['leyenda']}: </label><td><input type='number' name='$campo' id='$campo' style='width:{$def['ancho']}px' onkeypress='enter_va_a(forms.elegir_vivienda.DESTINO_ENTER,event);'>
HTML;
	if($campo=='nhogar'){
		$str.=" <small>(optativo, dejar en blanco para entrar a todos los hogares de una vivienda)</small>";
	}
}

$str=str_replace('DESTINO_ENTER','Abrir',$str);

if(Puede('eliminar','encuestas')){
	$mas_opciones=<<<HTML
	<p><input id=necesito_mas type=checkbox 
		onclick="elemento_existente('mas_opciones').style.display=(elemento_existente('necesito_mas').checked)?'inline':'none';"
	> <small>Necesito más opciones</small></p>
	<div id=mas_opciones style='display:none'>
		Para 
		<input type=text id=para_que style='width:100px' > 
		necesito 
		<input type=button value='abrir la encuesta con permisos especiales'
			onclick='AbrirEncuesta(elemento_existente("encuesta").value, elemento_existente("nhogar").value, elemento_existente("id_proc").value,elemento_existente("para_que").value);'
		></div>
HTML;
}else{
	$mas_opciones="";
}

$str.=<<<HTML
	<tr><td><td><input name='Abrir' type=button value='Abrir' 
		onclick='AbrirEncuesta(elemento_existente("encuesta").value, elemento_existente("nhogar").value, elemento_existente("id_proc").value);'>
	</table>
	</form>
	$mas_opciones
	<script>
			document.forms.elegir_vivienda.encuesta.focus();
</script>
HTML;

EnviarStrAlCliente($str);

?>