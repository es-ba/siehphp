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
<span class='pre_pre'>P0</span>
<span class='pre_texto' id='pre_P0'>Nº</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='info_numero'><input id='var_p0' name='var_p0' type='text' readonly=readonly class='input_info_numero' onblur='ValidarOpcion("var_p0");' onKeyPress='PresionTeclaEnVariable("var_p0",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p0",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P1</span>
<span class='pre_texto' id='pre_P1'>nombre <span class='pre_aclaracion'>No se olvide de usted ni de los bebes y niños</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_nombre' name='var_nombre' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_nombre");' onKeyPress='PresionTeclaEnVariable("var_nombre",event);' onKeyDown='PresionOtraTeclaEnVariable("var_nombre",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P2</span>
<span class='pre_texto' id='pre_P2'>sexo <span class='pre_aclaracion'>Anote el código</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sexo' name='var_sexo' type='text'  class='input_opciones' onblur='ValidarOpcion("var_sexo");' onKeyPress='PresionTeclaEnVariable("var_sexo",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sexo",event);' ></span>
</td><td colspan=3><li id='var_sexo__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sexo','1')">1: Varon</span></li>
<li id='var_sexo__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sexo','2')">2: Mujer</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P3A</span>
<span class='pre_texto' id='pre_P3A'>f.nac</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='fecha'><input id='var_f_nac_o' name='var_f_nac_o' type='text'  class='input_fecha' onblur='ValidarOpcion("var_f_nac_o");' onKeyPress='PresionTeclaEnVariable("var_f_nac_o",event);' onKeyDown='PresionOtraTeclaEnVariable("var_f_nac_o",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P7</span>
<span class='pre_texto' id='pre_P7'>Ent/Sal <span class='pre_aclaracion'>Anote código tabla</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_p7' name='var_p7' type='text'  class='input_opciones' onblur='ValidarOpcion("var_p7");' onKeyPress='PresionTeclaEnVariable("var_p7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p7",event);' ></span>
</td><td colspan=3><li id='var_p7__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p7','1','pre_P3B')">1: Permanece</span> <span class='texto_salto' id='var_p7.1.salto'> &#8631; P3B</span>
</li>
<li id='var_p7__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p7','2')">2: Entró</span></li>
<li id='var_p7__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p7','3')">3: Salió</span></li>
<li id='var_p7__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p7','4')">4: Error</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P8</span>
<span class='pre_texto' id='pre_P8'>motivo <span class='pre_aclaracion'>Anote código tabla</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_p8' name='var_p8' type='text'  class='input_opciones' onblur='ValidarOpcion("var_p8");' onKeyPress='PresionTeclaEnVariable("var_p8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p8",event);' ></span>
</td><td colspan=3><li id='var_p8__1'><span onclick="PonerOpcion('var_p8','1','pre_Fin')">1: Nacimiento/ adopción</span> <span class='texto_salto' id='var_p8.1.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__2'><span onclick="PonerOpcion('var_p8','2','pre_Fin')">2: Matrimonio/ unión</span> <span class='texto_salto' id='var_p8.2.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__3'><span onclick="PonerOpcion('var_p8','3','pre_Fin')">3: Divorcio/ separación</span> <span class='texto_salto' id='var_p8.3.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__4'><span onclick="PonerOpcion('var_p8','4','pre_Fin')">4: Fallecimiento</span> <span class='texto_salto' id='var_p8.4.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__5'><span onclick="PonerOpcion('var_p8','5','pre_Fin')">5: Por estudio</span> <span class='texto_salto' id='var_p8.5.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__6'><span onclick="PonerOpcion('var_p8','6','pre_Fin')">6: Por trabajo</span> <span class='texto_salto' id='var_p8.6.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p8','7','pre_Fin')">7: Por salud</span> <span class='texto_salto' id='var_p8.7.salto'> &#8631; Fin</span>
</li>
<li id='var_p8__8'><span onclick="PonerOpcion('var_p8','8','pre_Fin')">8: Otros motivos</span> <span class='opc_aclaracion'>especificar</span> <span class='texto_salto' id='var_p8.8.salto'> &#8631; Fin</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P3B</span>
<span class='pre_texto' id='pre_P3B'>años <span class='pre_aclaracion'>Si tiene menos de un año anote 0</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_edad' name='var_edad' type='text'  class='input_numeros' onblur='ValidarOpcion("var_edad");' onKeyPress='PresionTeclaEnVariable("var_edad",event);' onKeyDown='PresionOtraTeclaEnVariable("var_edad",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P4</span>
<span class='pre_texto' id='pre_P4'>parentesco <span class='pre_aclaracion'>Anote código tabla. E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_p4' name='var_p4' type='text'  class='input_opciones' onblur='ValidarOpcion("var_p4");' onKeyPress='PresionTeclaEnVariable("var_p4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p4",event);' ></span>
</td><td colspan=3><li id='var_p4__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','1')">1: Jefe/a</span></li>
<li id='var_p4__2'><span onclick="PonerOpcion('var_p4','2')">2: Cónyuge/ pareja</span></li>
<li id='var_p4__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','3')">3: Hijo/a</span></li>
<li id='var_p4__4'><span onclick="PonerOpcion('var_p4','4')">4: Hijastro/a</span></li>
<li id='var_p4__5'><span onclick="PonerOpcion('var_p4','5')">5: Yerno o nuera</span></li>
<li id='var_p4__6' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','6')">6: Nieto/a</span></li>
<li id='var_p4__7'><span onclick="PonerOpcion('var_p4','7')">7: Padre/ madre/ suegro/a</span></li>
<li id='var_p4__8' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','8')">8: Hermano/a</span></li>
<li id='var_p4__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','9')">9: Cuñado/a</span></li>
<li id='var_p4__10' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','10')">10: Sobrino/a</span></li>
<li id='var_p4__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p4','11')">11: Abuelo/a</span></li>
<li id='var_p4__12'><span onclick="PonerOpcion('var_p4','12')">12: Otro familiar</span></li>
<li id='var_p4__13'><span onclick="PonerOpcion('var_p4','13')">13: Servicio domestico y sus familiares</span></li>
<li id='var_p4__14'><span onclick="PonerOpcion('var_p4','14')">14: Otro no familiar</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P5</span>
<span class='pre_texto' id='pre_P5'>estado cony <span class='pre_aclaracion'>Anote código tabla. E-S para 14 años y más</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_p5' name='var_p5' type='text'  class='input_opciones' onblur='ValidarOpcion("var_p5");' onKeyPress='PresionTeclaEnVariable("var_p5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p5",event);' ></span>
</td><td colspan=3><li id='var_p5__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p5','1')">1: Unido/a</span></li>
<li id='var_p5__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_p5','2')">2: Casado/a</span></li>
<li id='var_p5__3'><span onclick="PonerOpcion('var_p5','3')">3: Separado/a de unión</span></li>
<li id='var_p5__4'><span onclick="PonerOpcion('var_p5','4')">4: Viudo/a de unión</span></li>
<li id='var_p5__5'><span onclick="PonerOpcion('var_p5','5')">5: Divorciado/a</span></li>
<li id='var_p5__6'><span onclick="PonerOpcion('var_p5','6')">6: Separado/a de matrimonio</span></li>
<li id='var_p5__7'><span onclick="PonerOpcion('var_p5','7')">7: Viudo/a de matrimonio</span></li>
<li id='var_p5__8'><span onclick="PonerOpcion('var_p5','8')">8: Soltero/a nunca casado/a ni unido/a</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P5B</span>
<span class='pre_texto' id='pre_P5B'>convive con <span class='pre_aclaracion'>Para 14 y más unidos/casados. Si no convive anote 95</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_p5b' name='var_p5b' type='text'  class='input_numeros' onblur='ValidarOpcion("var_p5b");' onKeyPress='PresionTeclaEnVariable("var_p5b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p5b",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P6A</span>
<span class='pre_texto' id='pre_P6A'>padre <span class='pre_aclaracion'>para 24 años o menos. Si no vive en el hogar anote 95</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_p6_a' name='var_p6_a' type='text'  class='input_numeros' onblur='ValidarOpcion("var_p6_a");' onKeyPress='PresionTeclaEnVariable("var_p6_a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p6_a",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>P6B</span>
<span class='pre_texto' id='pre_P6B'>madre <span class='pre_aclaracion'>para 24 años o menos. Si no vive en el hogar anote 95</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_p6_b' name='var_p6_b' type='text'  class='input_numeros' onblur='ValidarOpcion("var_p6_b");' onKeyPress='PresionTeclaEnVariable("var_p6_b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_p6_b",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_Fin'>Fin del formulario</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup></table>
	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"S1","matriz":"P"});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>