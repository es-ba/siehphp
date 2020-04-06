<!DOCTYPE HTML>
<html  lang="es-es">
<head>
	<meta charset="UTF-8">
	
	<script language="JavaScript" src="comunes.js"> </script>
	<script language="JavaScript" src="encuesta.js"> </script>
	<script language="JavaScript" src="gen/estructura_yeah.js"> </script>
	<script language='JavaScript' src='editor.js'></script>
	
	<link rel="stylesheet" href="yeah.css" type="text/css" title="main" charset="utf-8">
	<link rel="stylesheet" href="ipad.css" type="text/css" title="main" charset="utf-8">
    <link rel="apple-touch-icon" href="imagenes/eah_icon.gif"/>
	<link rel="icon" type="image/gif" href="imagenes/eah_icon.gif" />
</head>
<body >
<table class=no_imprimir><tr>
	<td  >
	<a href='index.php'><img src='imagenes/logo_prototipo.png' title="Ir al Menu"></a></td>
	<td>
	<div id=div_para_portapapeles style="visibility:hidden; position:absolute; left:730px; top:20px;">
	<textarea id=para_portapapeles style="width:3px; color:white; background-color:white"></textarea>
	Exportado<img src=imagenes/mini_confirmado.png>
	<td>
</table>


<table>
<tr><td><input type='button' onclick='VolverDelFormulario();' value='Volver'>
<td>ud:<span id='id_ud'></span></td></table>
<small>Rev: 8.98 </small>		<table class="de_preguntas">
			<colgroup>
			<col width="40">
			<col width="60"><tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U2</span>
<span class='pre_texto' id='pre_U2'>Relación Nº</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='info_numero'><input id='var_relacion' name='var_relacion' type='text' readonly=readonly class='input_info_numero' onblur='ValidarOpcion("var_relacion");' onKeyPress='PresionTeclaEnVariable("var_relacion",event);' onKeyDown='PresionOtraTeclaEnVariable("var_relacion",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U3_mes</span>
<span class='pre_texto' id='pre_U3_mes'>Mes Inicio</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='mes'><input id='var_u3_mes' name='var_u3_mes' type='text'  class='input_mes' onblur='ValidarOpcion("var_u3_mes");' onKeyPress='PresionTeclaEnVariable("var_u3_mes",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u3_mes",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U3_anio</span>
<span class='pre_texto' id='pre_U3_anio'>Año Inicio</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='anio'><input id='var_u3_anio' name='var_u3_anio' type='text'  class='input_anio' onblur='ValidarOpcion("var_u3_anio");' onKeyPress='PresionTeclaEnVariable("var_u3_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u3_anio",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U4_mes</span>
<span class='pre_texto' id='pre_U4_mes'>Mes Finalización</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='mes'><input id='var_u4_mes' name='var_u4_mes' type='text'  class='input_mes' onblur='ValidarOpcion("var_u4_mes");' onKeyPress='PresionTeclaEnVariable("var_u4_mes",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u4_mes",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U4_anio</span>
<span class='pre_texto' id='pre_U4_anio'>Año Finalización</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='anio'><input id='var_u4_anio' name='var_u4_anio' type='text'  class='input_anio' onblur='ValidarOpcion("var_u4_anio");' onKeyPress='PresionTeclaEnVariable("var_u4_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u4_anio",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U5</span>
<span class='pre_texto' id='pre_U5'>Motivo por el que finalizó la relación</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_u5' name='var_u5' type='text'  class='input_opciones' onblur='ValidarOpcion("var_u5");' onKeyPress='PresionTeclaEnVariable("var_u5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u5",event);' ></span>
</td><td colspan=3><li id='var_u5__1'><span onclick="PonerOpcion('var_u5','1')">1: Se divorciaron o separaron legalmente</span></li>
<li id='var_u5__2'><span onclick="PonerOpcion('var_u5','2')">2: Se separaron de hecho por acuerdo mutuo</span></li>
<li id='var_u5__3'><span onclick="PonerOpcion('var_u5','3')">3: Fallecimiento</span></li>
<li id='var_u5__4'><span onclick="PonerOpcion('var_u5','4')">4: otras causas</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U6</span>
<span class='pre_texto' id='pre_U6'>Tipo de unión</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_u6' name='var_u6' type='text'  class='input_opciones' onblur='ValidarOpcion("var_u6");' onKeyPress='PresionTeclaEnVariable("var_u6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u6",event);' ></span>
</td><td colspan=3><li id='var_u6__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_u6','1')">1: Legal</span></li>
<li id='var_u6__2'><span onclick="PonerOpcion('var_u6','2')">2: Consensual</span></li>
</td></tr>
</table>
	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"I1","matriz":"U"});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>