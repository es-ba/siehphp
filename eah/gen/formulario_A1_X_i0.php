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
<span class='pre_texto' id='pre_ex'>Nro</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='info_numero'><input id='var_ex_miembro' name='var_ex_miembro' type='text' readonly=readonly class='input_info_numero' onblur='ValidarOpcion("var_ex_miembro");' onKeyPress='PresionTeclaEnVariable("var_ex_miembro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_ex_miembro",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_sexo_ex'>Sexo</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sexo_ex' name='var_sexo_ex' type='text'  class='input_opciones' onblur='ValidarOpcion("var_sexo_ex");' onKeyPress='PresionTeclaEnVariable("var_sexo_ex",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sexo_ex",event);' ></span>
</td><td colspan=3><li id='var_sexo_ex__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sexo_ex','1')">1: Varón</span></li>
<li id='var_sexo_ex__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sexo_ex','2')">2: Mujer</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_pais_nac'>País de nacimiento</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_pais_nac' name='var_pais_nac' type='text'  class='input_opciones' onblur='ValidarOpcion("var_pais_nac");' onKeyPress='PresionTeclaEnVariable("var_pais_nac",event);' onKeyDown='PresionOtraTeclaEnVariable("var_pais_nac",event);' ></span>
</td><td colspan=3><li id='var_pais_nac__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_pais_nac','1')">1: Argentina</span></li>
<li id='var_pais_nac__2'><span onclick="PonerOpcion('var_pais_nac','2')">2: Otro país</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_edad_ex'>Edad al momento de irse <span class='pre_aclaracion'>En años cumplidos</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3> <span class='opc_aclaracion'>En años cumplidos</span><td colspan=1><span class='respuesta'  title='edad'><input id='var_edad_ex' name='var_edad_ex' type='text'  class='input_edad' onblur='ValidarOpcion("var_edad_ex");' onKeyPress='PresionTeclaEnVariable("var_edad_ex",event);' onKeyDown='PresionOtraTeclaEnVariable("var_edad_ex",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_niv_educ'>Nivel educativo al momento de irse</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_niv_educ' name='var_niv_educ' type='text'  class='input_opciones' onblur='ValidarOpcion("var_niv_educ");' onKeyPress='PresionTeclaEnVariable("var_niv_educ",event);' onKeyDown='PresionOtraTeclaEnVariable("var_niv_educ",event);' ></span>
</td><td colspan=3><li id='var_niv_educ__1'><span onclick="PonerOpcion('var_niv_educ','1')">1: Hasta Primario incompleto</span></li>
<li id='var_niv_educ__2'><span onclick="PonerOpcion('var_niv_educ','2')">2: Primario comp. - Secundario incompleto</span></li>
<li id='var_niv_educ__3'><span onclick="PonerOpcion('var_niv_educ','3')">3: Secundario comp. - Terc./Univ. incomp.</span></li>
<li id='var_niv_educ__4'><span onclick="PonerOpcion('var_niv_educ','4')">4: Terciario / Universitario completo</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_anio'>Año en que se fue</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='anio'><input id='var_anio' name='var_anio' type='text'  class='input_anio' onblur='ValidarOpcion("var_anio");' onKeyPress='PresionTeclaEnVariable("var_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_anio",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_lugar'>A que lugar se fué?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_lugar' name='var_lugar' type='text'  class='input_opciones' onblur='ValidarOpcion("var_lugar");' onKeyPress='PresionTeclaEnVariable("var_lugar",event);' onKeyDown='PresionOtraTeclaEnVariable("var_lugar",event);' ></span>
</td><td colspan=3><li id='var_lugar__1'><span onclick="PonerOpcion('var_lugar','1')">1: A la Pcia. de Buenos Aires</span> <span class='opc_aclaracion'>(especificar lugar)</span></li>
<li id='var_lugar__2'><span onclick="PonerOpcion('var_lugar','2')">2: Al resto del país</span></li>
<li id='var_lugar__3'><span onclick="PonerOpcion('var_lugar','3')">3: A otro país</span> <span class='opc_aclaracion'>(especificar país)</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_lugar_desc' name='var_lugar_desc' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_lugar_desc");' onKeyPress='PresionTeclaEnVariable("var_lugar_desc",event);' onKeyDown='PresionOtraTeclaEnVariable("var_lugar_desc",event);' ></span>
</td><td colspan=4></td></tr>
</table>
	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"A1","matriz":"X"});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>