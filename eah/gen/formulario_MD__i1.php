<!DOCTYPE HTML>
<html manifest='manifiesto.manifest' lang="es-es">
<head>
	<meta charset="UTF-8">
	<meta name='viewport' content='user-scalable=no, width=device-width' />

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
<span class='pre_texto' id='pre_entre_realizada'>Entrevista realizada</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_entre_realizada' name='var_entre_realizada' type='text'  class='input_si_no' onblur='ValidarOpcion("var_entre_realizada");' onKeyPress='PresionTeclaEnVariable("var_entre_realizada",event);' onKeyDown='PresionOtraTeclaEnVariable("var_entre_realizada",event);' ></span>
</td><td colspan=3><li id='var_entre_realizada__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_entre_realizada','1')">1: Sí</span></li>
<li id='var_entre_realizada__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_entre_realizada','2','pre_razon_no_realizada')">2: No</span> <span class='texto_salto' id='var_entre_realizada.2.salto'> &#8631; razon_no_realizada</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para caracterización de la discapacidad<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
PARA TODAS LAS PERSONAS CON DISCAPACIDAD DE ORIGEN<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D1</span>
<span class='pre_texto' id='pre_D1'>¿A qué edad comenzó la discapacidad más antigua <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Para los menores de 1 año <span class='opc_aclaracion'>Indique los meses cumplidos - si es de nacimiento registre 00</span><td colspan=1><span class='respuesta'  title='meses'><input id='var_d1_meses' name='var_d1_meses' type='number'  class='input_meses' onblur='ValidarOpcion("var_d1_meses");' onKeyPress='PresionTeclaEnVariable("var_d1_meses",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d1_meses",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>Para los de 1 año y más <span class='opc_aclaracion'>Indique edad en años cumplidos</span><td colspan=1><span class='respuesta'  title='anios'><input id='var_d1_anios' name='var_d1_anios' type='number'  class='input_anios' onblur='ValidarOpcion("var_d1_anios");' onKeyPress='PresionTeclaEnVariable("var_d1_anios",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d1_anios",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO AL CERTIFICADO DE DISCAPACIDAD<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D2</span>
<span class='pre_texto' id='pre_D2'>¿Tiene Certificado de Discapacidad? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d2' name='var_d2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d2");' onKeyPress='PresionTeclaEnVariable("var_d2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d2",event);' ></span>
</td><td colspan=3><li id='var_d2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d2','1')">1: Sí</span></li>
<li id='var_d2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d2','2','pre_D4')">2: No</span> <span class='texto_salto' id='var_d2.2.salto'> &#8631; D4</span>
</li>
<li id='var_d2__3'><span onclick="PonerOpcion('var_d2','3','pre_D5')">3: Está en trámite</span> <span class='texto_salto' id='var_d2.3.salto'> &#8631; D5</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D3</span>
<span class='pre_texto' id='pre_D3'>¿Para que usa el Certificado de Discapacidad? <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_1' name='var_d3_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_1");' onKeyPress='PresionTeclaEnVariable("var_d3_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_1",event);' ></span>
</td><td colspan=3><li id='var_d3_1__1'><span onclick="PonerOpcion('var_d3_1','1')">1: Obtener cobertura integral de las prestaciones básicas de habilitación y rehabilitación</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_2' name='var_d3_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_2");' onKeyPress='PresionTeclaEnVariable("var_d3_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_2",event);' ></span>
</td><td colspan=3><li id='var_d3_2__2'><span onclick="PonerOpcion('var_d3_2','2')">2: Obtener cobertura integral de medicación</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_3' name='var_d3_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_3");' onKeyPress='PresionTeclaEnVariable("var_d3_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_3",event);' ></span>
</td><td colspan=3><li id='var_d3_3__3'><span onclick="PonerOpcion('var_d3_3','3')">3: Adquirir elementos ortopédicos</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_4' name='var_d3_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_4");' onKeyPress='PresionTeclaEnVariable("var_d3_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_4",event);' ></span>
</td><td colspan=3><li id='var_d3_4__4'><span onclick="PonerOpcion('var_d3_4','4')">4: Obtener el pase libre de transporte público</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_5' name='var_d3_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_5");' onKeyPress='PresionTeclaEnVariable("var_d3_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_5",event);' ></span>
</td><td colspan=3><li id='var_d3_5__5'><span onclick="PonerOpcion('var_d3_5','5')">5: Obtener el pase libre en autopistas de la Ciudad de Buenos Aires</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_6' name='var_d3_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_6");' onKeyPress='PresionTeclaEnVariable("var_d3_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_6",event);' ></span>
</td><td colspan=3><li id='var_d3_6__6'><span onclick="PonerOpcion('var_d3_6','6')">6: Obtener franquicias para la compra de automotores</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_7' name='var_d3_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_7");' onKeyPress='PresionTeclaEnVariable("var_d3_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_7",event);' ></span>
</td><td colspan=3><li id='var_d3_7__7'><span onclick="PonerOpcion('var_d3_7','7')">7: Obtener el Símbolo Internacional de Acceso para el Automóvil</span> <span class='opc_aclaracion'>logo</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_8' name='var_d3_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_8");' onKeyPress='PresionTeclaEnVariable("var_d3_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_8",event);' ></span>
</td><td colspan=3><li id='var_d3_8__8'><span onclick="PonerOpcion('var_d3_8','8')">8: Acceder a la exención de pago de ABL/patente</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_9' name='var_d3_9' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_9");' onKeyPress='PresionTeclaEnVariable("var_d3_9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_9",event);' ></span>
</td><td colspan=3><li id='var_d3_9__9'><span onclick="PonerOpcion('var_d3_9','9')">9: Obtener permiso de libre tránsito y estacionamiento domiciliario</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_10' name='var_d3_10' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_10");' onKeyPress='PresionTeclaEnVariable("var_d3_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_10",event);' ></span>
</td><td colspan=3><li id='var_d3_10__10'><span onclick="PonerOpcion('var_d3_10','10')">10: Acceder al régimen de asignaciones familiares en ANSeS</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_11' name='var_d3_11' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_11");' onKeyPress='PresionTeclaEnVariable("var_d3_11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_11",event);' ></span>
</td><td colspan=3><li id='var_d3_11__11'><span onclick="PonerOpcion('var_d3_11','11')">11: Realizar la administración de pequeños comercios</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_12' name='var_d3_12' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_12");' onKeyPress='PresionTeclaEnVariable("var_d3_12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_12",event);' ></span>
</td><td colspan=3><li id='var_d3_12__12'><span onclick="PonerOpcion('var_d3_12','12')">12: Solicitar empleo en la administración pública</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_13' name='var_d3_13' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_13");' onKeyPress='PresionTeclaEnVariable("var_d3_13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_13",event);' ></span>
</td><td colspan=3><li id='var_d3_13__13' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d3_13','13')">13: otros</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d3_14' name='var_d3_14' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d3_14");' onKeyPress='PresionTeclaEnVariable("var_d3_14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d3_14",event);' ></span>
</td><td colspan=3><li id='var_d3_14__14' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d3_14','14')">14: No la usa</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_FILTRO_0'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_0' name='var_filtro_0' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_0");' onKeyPress='PresionTeclaEnVariable("var_filtro_0",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_0",event);' ></span>
 <span class='texto_salto' id='var_filtro_0.salto'> &#8631; D5</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D4</span>
<span class='pre_texto' id='pre_D4'>¿Cual es el motivo principal por el que no posee Certificado de Discapacidad? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d4' name='var_d4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d4");' onKeyPress='PresionTeclaEnVariable("var_d4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d4",event);' ></span>
</td><td colspan=3><li id='var_d4__1'><span onclick="PonerOpcion('var_d4','1')">1: No sabe que existe</span></li>
<li id='var_d4__2'><span onclick="PonerOpcion('var_d4','2')">2: No sabe para qué le sirve</span></li>
<li id='var_d4__3'><span onclick="PonerOpcion('var_d4','3')">3: No sabe como obtenerlo o es complicado</span></li>
<li id='var_d4__4'><span onclick="PonerOpcion('var_d4','4')">4: Le queda muy lejos el lugar que lo otorga</span></li>
<li id='var_d4__5'><span onclick="PonerOpcion('var_d4','5')">5: No lo quiere</span></li>
<li id='var_d4__6'><span onclick="PonerOpcion('var_d4','6')">6: No lo necesita</span></li>
<li id='var_d4__7'><span onclick="PonerOpcion('var_d4','7')">7: Otros motivos</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESIBILIDAD<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO A LOS ESPACIOS FISICOS<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D5</span>
<span class='pre_texto' id='pre_D5'>¿Encuentra problemas u obstáculos para acceder o usar... ? <span class='pre_aclaracion'> se refiere a ingresar, permanecer, comunicarse y/o usar el baño) (G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_1' name='var_d5_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_1");' onKeyPress='PresionTeclaEnVariable("var_d5_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_1",event);' ></span>
</td><td colspan=3><li id='var_d5_1__1'><span onclick="PonerOpcion('var_d5_1','1')">1: Trenes, colectivos, subtes?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_2' name='var_d5_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_2");' onKeyPress='PresionTeclaEnVariable("var_d5_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_2",event);' ></span>
</td><td colspan=3><li id='var_d5_2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d5_2','2')">2: Taxis</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_3' name='var_d5_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_3");' onKeyPress='PresionTeclaEnVariable("var_d5_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_3",event);' ></span>
</td><td colspan=3><li id='var_d5_3__3'><span onclick="PonerOpcion('var_d5_3','3')">3: Bancos, comercios, negocios de alimentos, etc?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_4' name='var_d5_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_4");' onKeyPress='PresionTeclaEnVariable("var_d5_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_4",event);' ></span>
</td><td colspan=3><li id='var_d5_4__4'><span onclick="PonerOpcion('var_d5_4','4')">4: Cines, teatros, etc?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_5' name='var_d5_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_5");' onKeyPress='PresionTeclaEnVariable("var_d5_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_5",event);' ></span>
</td><td colspan=3><li id='var_d5_5__5'><span onclick="PonerOpcion('var_d5_5','5')">5: Veredas y calles?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_6' name='var_d5_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_6");' onKeyPress='PresionTeclaEnVariable("var_d5_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_6",event);' ></span>
</td><td colspan=3><li id='var_d5_6__6' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d5_6','6')">6: Plazas?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_7' name='var_d5_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_7");' onKeyPress='PresionTeclaEnVariable("var_d5_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_7",event);' ></span>
</td><td colspan=3><li id='var_d5_7__7'><span onclick="PonerOpcion('var_d5_7','7')">7: Cajeros automáticos?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_8' name='var_d5_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_8");' onKeyPress='PresionTeclaEnVariable("var_d5_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_8",event);' ></span>
</td><td colspan=3><li id='var_d5_8__8'><span onclick="PonerOpcion('var_d5_8','8')">8: Computadoras?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_9' name='var_d5_9' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_9");' onKeyPress='PresionTeclaEnVariable("var_d5_9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_9",event);' ></span>
</td><td colspan=3><li id='var_d5_9__9'><span onclick="PonerOpcion('var_d5_9','9')">9: Avisos electrónicos en bancos, aeropuertos, centros comerciales, etc? </span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_10' name='var_d5_10' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_10");' onKeyPress='PresionTeclaEnVariable("var_d5_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_10",event);' ></span>
</td><td colspan=3><li id='var_d5_10__10' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d5_10','10')">10: Otros</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d5_11' name='var_d5_11' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d5_11");' onKeyPress='PresionTeclaEnVariable("var_d5_11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d5_11",event);' ></span>
</td><td colspan=3><li id='var_d5_11__11'><span onclick="PonerOpcion('var_d5_11','11')">11: No encuentra ningún obstáculo</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO A LA ATENCIÓN DE SALUD<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D6</span>
<span class='pre_texto' id='pre_D6'>A causa de la discapacidad, ¿necesita recibir estimulación temprana, control, tratamiento, rehabilitación en forma periódica?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d6' name='var_d6' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d6");' onKeyPress='PresionTeclaEnVariable("var_d6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d6",event);' ></span>
</td><td colspan=3><li id='var_d6__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d6','1')">1: Si</span></li>
<li id='var_d6__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d6','2','pre_D10')">2: No</span> <span class='texto_salto' id='var_d6.2.salto'> &#8631; D10</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D7</span>
<span class='pre_texto' id='pre_D7'>¿Recibe la estimulación temprana, control, tratamiento, rehabilitación que necesita?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d7' name='var_d7' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d7");' onKeyPress='PresionTeclaEnVariable("var_d7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d7",event);' ></span>
</td><td colspan=3><li id='var_d7__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d7','1')">1: Si</span></li>
<li id='var_d7__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d7','2','pre_D9')">2: No</span> <span class='texto_salto' id='var_d7.2.salto'> &#8631; D9</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
SOLO PARA LAS PERSONAS CON DISCAPACIDAD QUE RECIBEN ESTIMULACIÓN TEMPRANA, CONTROL, TRATAMIENTO, REHABILITACIÓN<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D8</span>
<span class='pre_texto' id='pre_D8'>¿Quién cubre la mayor parte del costo de la estimulación temprana, control, tratamiento o rehabilitación? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d8' name='var_d8' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d8");' onKeyPress='PresionTeclaEnVariable("var_d8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d8",event);' ></span>
</td><td colspan=3><li id='var_d8__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d8','1','pre_D10')">1: PAMI</span> <span class='texto_salto' id='var_d8.1.salto'> &#8631; D10</span>
</li>
<li id='var_d8__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d8','2','pre_D10')">2: PROFE</span> <span class='texto_salto' id='var_d8.2.salto'> &#8631; D10</span>
</li>
<li id='var_d8__3'><span onclick="PonerOpcion('var_d8','3','pre_D10')">3: Una obra social</span> <span class='texto_salto' id='var_d8.3.salto'> &#8631; D10</span>
</li>
<li id='var_d8__4'><span onclick="PonerOpcion('var_d8','4','pre_D10')">4: Un plan de medicina prepaga / mutual</span> <span class='texto_salto' id='var_d8.4.salto'> &#8631; D10</span>
</li>
<li id='var_d8__5'><span onclick="PonerOpcion('var_d8','5','pre_D10')">5: Cobertura de salud porteña</span> <span class='texto_salto' id='var_d8.5.salto'> &#8631; D10</span>
</li>
<li id='var_d8__6'><span onclick="PonerOpcion('var_d8','6','pre_D10')">6: CESAC (Centro de Salud Comunitario) o salita de salud</span> <span class='texto_salto' id='var_d8.6.salto'> &#8631; D10</span>
</li>
<li id='var_d8__7'><span onclick="PonerOpcion('var_d8','7','pre_D10')">7: El hospital público</span> <span class='opc_aclaracion'>estatal</span> <span class='texto_salto' id='var_d8.7.salto'> &#8631; D10</span>
</li>
<li id='var_d8__8'><span onclick="PonerOpcion('var_d8','8','pre_D10')">8: El presupuesto familiar</span> <span class='texto_salto' id='var_d8.8.salto'> &#8631; D10</span>
</li>
<li id='var_d8__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d8','9')">9: Otro</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_d8_esp' name='var_d8_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_d8_esp");' onKeyPress='PresionTeclaEnVariable("var_d8_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d8_esp",event);' ></span>
 <span class='texto_salto' id='var_d8_esp.salto'> &#8631; D10</span>
</td><td colspan=4></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D9</span>
<span class='pre_texto' id='pre_D9'>¿Cuál es el motivo principal por el que no recibe estimulación temprana, control, tratamiento o rehabilitación? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d9' name='var_d9' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d9");' onKeyPress='PresionTeclaEnVariable("var_d9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d9",event);' ></span>
</td><td colspan=3><li id='var_d9__1'><span onclick="PonerOpcion('var_d9','1')">1: Porque el hospital público / el CeSaC / Cobertura de Salud Porteña no da respuesta</span></li>
<li id='var_d9__2'><span onclick="PonerOpcion('var_d9','2')">2: Porque la obra social / mutual / prepaga no da respuesta</span></li>
<li id='var_d9__3'><span onclick="PonerOpcion('var_d9','3')">3: Porque no sabe qué trámites tiene que hacer o dónde debe solicitarlo</span></li>
<li id='var_d9__4'><span onclick="PonerOpcion('var_d9','4')">4: No lo puede pagar con el presupuesto del hogar</span></li>
<li id='var_d9__5'><span onclick="PonerOpcion('var_d9','5')">5: No tengo tiempo / no quiero</span></li>
<li id='var_d9__6'><span onclick="PonerOpcion('var_d9','6')">6: Por falta de acceso del transporte o lejanía</span></li>
<li id='var_d9__7'><span onclick="PonerOpcion('var_d9','7')">7: otros motivos</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_d9_esp' name='var_d9_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_d9_esp");' onKeyPress='PresionTeclaEnVariable("var_d9_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d9_esp",event);' ></span>
</td><td colspan=4></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D10</span>
<span class='pre_texto' id='pre_D10'>A cusa de la discapacidad ¿Necesita ayudas técnicas y/o apoyos? <span class='pre_aclaracion'>tales como bastón, prótesis, audífono, muletas, oxígeno, etc.</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d10' name='var_d10' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d10");' onKeyPress='PresionTeclaEnVariable("var_d10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d10",event);' ></span>
</td><td colspan=3><li id='var_d10__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d10','1')">1: Si</span></li>
<li id='var_d10__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d10','2','pre_D14')">2: No</span> <span class='texto_salto' id='var_d10.2.salto'> &#8631; D14</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D11</span>
<span class='pre_texto' id='pre_D11'>¿Qué técnicas y/o apoyo tiene y/o usa? <span class='pre_aclaracion'>E-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_1' name='var_d11_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_1");' onKeyPress='PresionTeclaEnVariable("var_d11_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_1",event);' ></span>
</td><td colspan=3><li id='var_d11_1__1'><span onclick="PonerOpcion('var_d11_1','1')">1: Bastón blanco o verde</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_2' name='var_d11_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_2");' onKeyPress='PresionTeclaEnVariable("var_d11_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_2",event);' ></span>
</td><td colspan=3><li id='var_d11_2__2'><span onclick="PonerOpcion('var_d11_2','2')">2: Prótesis ocular</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_3' name='var_d11_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_3");' onKeyPress='PresionTeclaEnVariable("var_d11_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_3",event);' ></span>
</td><td colspan=3><li id='var_d11_3__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d11_3','3')">3: Audífono</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_4' name='var_d11_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_4");' onKeyPress='PresionTeclaEnVariable("var_d11_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_4",event);' ></span>
</td><td colspan=3><li id='var_d11_4__4'><span onclick="PonerOpcion('var_d11_4','4')">4: Implante coclear</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_5' name='var_d11_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_5");' onKeyPress='PresionTeclaEnVariable("var_d11_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_5",event);' ></span>
</td><td colspan=3><li id='var_d11_5__5'><span onclick="PonerOpcion('var_d11_5','5')">5: Bastón, muletas, trípode, andador, etc.</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_6' name='var_d11_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_6");' onKeyPress='PresionTeclaEnVariable("var_d11_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_6",event);' ></span>
</td><td colspan=3><li id='var_d11_6__6'><span onclick="PonerOpcion('var_d11_6','6')">6: Silla de rueda común o especial</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_7' name='var_d11_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_7");' onKeyPress='PresionTeclaEnVariable("var_d11_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_7",event);' ></span>
</td><td colspan=3><li id='var_d11_7__7'><span onclick="PonerOpcion('var_d11_7','7')">7: Prótesis u ortésis</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_8' name='var_d11_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_8");' onKeyPress='PresionTeclaEnVariable("var_d11_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_8",event);' ></span>
</td><td colspan=3><li id='var_d11_8__8'><span onclick="PonerOpcion('var_d11_8','8')">8: Programas informáticosadaptados para leer, escribir, etc.</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_9' name='var_d11_9' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_9");' onKeyPress='PresionTeclaEnVariable("var_d11_9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_9",event);' ></span>
</td><td colspan=3><li id='var_d11_9__9'><span onclick="PonerOpcion('var_d11_9','9')">9: Otro tipo de ayuda técnica</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d11_10' name='var_d11_10' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d11_10");' onKeyPress='PresionTeclaEnVariable("var_d11_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d11_10",event);' ></span>
 <span class='texto_salto' id='var_d11_10.salto'> &#8631; D13</span>
</td><td colspan=3><li id='var_d11_10__10'><span onclick="PonerOpcion('var_d11_10','10','pre_D13')">10: No tiene y no usa ninguna ayuda técnica y/o apoyo</span> <span class='texto_salto' id='var_d11_10.10.salto'> &#8631; D13</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D12</span>
<span class='pre_texto' id='pre_D12'>¿Quién cubre la mayor parte del costo de las ayudas técnicas y7o apoyos que tiene y usa usa? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d12' name='var_d12' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d12");' onKeyPress='PresionTeclaEnVariable("var_d12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d12",event);' ></span>
 <span class='texto_salto' id='var_d12.salto'> &#8631; D14</span>
</td><td colspan=3><li id='var_d12__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d12','1')">1: PAMI</span></li>
<li id='var_d12__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d12','2')">2: PROFE</span></li>
<li id='var_d12__3'><span onclick="PonerOpcion('var_d12','3')">3: Una obra social</span></li>
<li id='var_d12__4'><span onclick="PonerOpcion('var_d12','4')">4: Un plan de medicina prepaga / mutual</span></li>
<li id='var_d12__5'><span onclick="PonerOpcion('var_d12','5')">5: Cobertura de salud porteña</span></li>
<li id='var_d12__6'><span onclick="PonerOpcion('var_d12','6')">6: CESAC (Centro de Salud Comunitario) o salita de salud</span></li>
<li id='var_d12__7'><span onclick="PonerOpcion('var_d12','7')">7: Banco de elementos ortopédicos</span> <span class='opc_aclaracion'>estatal</span></li>
<li id='var_d12__8'><span onclick="PonerOpcion('var_d12','8')">8: El hospital público (estatal)</span></li>
<li id='var_d12__9'><span onclick="PonerOpcion('var_d12','9')">9: El establecimiento escolar</span> <span class='opc_aclaracion'>estatal</span></li>
<li id='var_d12__10'><span onclick="PonerOpcion('var_d12','10')">10: El presupuesto familiar</span></li>
<li id='var_d12__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d12','11')">11: Otro</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
SOLO PARA LAS PERSONAS CON DISCAPACIDAD QUE NECESITAN AYUDAS TÉCNICAS O APOYOS PERO NO TIENEN Y NO USAN<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D13</span>
<span class='pre_texto' id='pre_D13'>¿Cuál es el motivo principal por el que no tiene y no usa ayudas técnicas y/o apoyos? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d13' name='var_d13' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d13");' onKeyPress='PresionTeclaEnVariable("var_d13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d13",event);' ></span>
</td><td colspan=3><li id='var_d13__1'><span onclick="PonerOpcion('var_d13','1')">1: Porque la obra social/mutual/prepaga no da respuesta</span></li>
<li id='var_d13__2'><span onclick="PonerOpcion('var_d13','2')">2: Porque no sabe qué trámites tiene que hacer o dónde debe solicitarlo</span></li>
<li id='var_d13__3'><span onclick="PonerOpcion('var_d13','3')">3: El establecimiento escolar no lo cubre/no lo brinda</span></li>
<li id='var_d13__4'><span onclick="PonerOpcion('var_d13','4')">4: Porque el Banco de elementos ortopédicos no se lo cubre</span></li>
<li id='var_d13__5'><span onclick="PonerOpcion('var_d13','5')">5: Porque no hay un programa público que lo brinde</span></li>
<li id='var_d13__6'><span onclick="PonerOpcion('var_d13','6')">6: No lo puede pagar con el presupuesto del hogar</span></li>
<li id='var_d13__7'><span onclick="PonerOpcion('var_d13','7')">7: otros motivos</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO A LA ASISTENCIA Y AYUDA DE PERSONAS<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D14</span>
<span class='pre_texto' id='pre_D14'>A cusa de la discapacidad ¿Necesita ser asistido o ayudado habitualmente por otra persona para... <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_1' name='var_d14_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_1");' onKeyPress='PresionTeclaEnVariable("var_d14_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_1",event);' ></span>
</td><td colspan=3><li id='var_d14_1__1'><span onclick="PonerOpcion('var_d14_1','1')">1: Comer / beber</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_2' name='var_d14_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_2");' onKeyPress='PresionTeclaEnVariable("var_d14_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_2",event);' ></span>
</td><td colspan=3><li id='var_d14_2__2'><span onclick="PonerOpcion('var_d14_2','2')">2: Lavarse / cuidar de su aspecto</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_3' name='var_d14_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_3");' onKeyPress='PresionTeclaEnVariable("var_d14_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_3",event);' ></span>
</td><td colspan=3><li id='var_d14_3__3'><span onclick="PonerOpcion('var_d14_3','3')">3: Realizar las tareas domésticas</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_4' name='var_d14_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_4");' onKeyPress='PresionTeclaEnVariable("var_d14_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_4",event);' ></span>
</td><td colspan=3><li id='var_d14_4__4'><span onclick="PonerOpcion('var_d14_4','4')">4: Realizar compras e ir a lugares</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_5' name='var_d14_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_5");' onKeyPress='PresionTeclaEnVariable("var_d14_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_5",event);' ></span>
</td><td colspan=3><li id='var_d14_5__5'><span onclick="PonerOpcion('var_d14_5','5')">5: Viajar en transporte público</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_d14_6' name='var_d14_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_d14_6");' onKeyPress='PresionTeclaEnVariable("var_d14_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d14_6",event);' ></span>
 <span class='texto_salto' id='var_d14_6.salto'> &#8631; FILTRO_1</span>
</td><td colspan=3><li id='var_d14_6__6'><span onclick="PonerOpcion('var_d14_6','6','pre_FILTRO_1')">6: No necesita ser asistido o ayudado para ninguna de las actividades</span> <span class='texto_salto' id='var_d14_6.6.salto'> &#8631; FILTRO_1</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D15</span>
<span class='pre_texto' id='pre_D15'>¿Recibe la asistencia o la ayuda que necesita habitualmente de otra persona?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d15' name='var_d15' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d15");' onKeyPress='PresionTeclaEnVariable("var_d15",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d15",event);' ></span>
</td><td colspan=3><li id='var_d15__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d15','1')">1: Si</span></li>
<li id='var_d15__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d15','2','pre_D17')">2: No</span> <span class='texto_salto' id='var_d15.2.salto'> &#8631; D17</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D16</span>
<span class='pre_texto' id='pre_D16'>¿Quién cubre la mayor parte de la asistencia o ayuda que recibe habitualmente de otra persona? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d16' name='var_d16' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d16");' onKeyPress='PresionTeclaEnVariable("var_d16",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d16",event);' ></span>
 <span class='texto_salto' id='var_d16.salto'> &#8631; FILTRO_1</span>
</td><td colspan=3><li id='var_d16__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d16','1')">1: PAMI</span></li>
<li id='var_d16__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d16','2')">2: PROFE</span></li>
<li id='var_d16__3'><span onclick="PonerOpcion('var_d16','3')">3: Una obra social</span></li>
<li id='var_d16__4'><span onclick="PonerOpcion('var_d16','4')">4: Un plan de medicina prepaga / mutual</span></li>
<li id='var_d16__5'><span onclick="PonerOpcion('var_d16','5')">5: Cobertura de salud porteña</span></li>
<li id='var_d16__6'><span onclick="PonerOpcion('var_d16','6')">6: Algún programa del Estado</span></li>
<li id='var_d16__7'><span onclick="PonerOpcion('var_d16','7')">7: Un familiar o amigo que no cobra</span></li>
<li id='var_d16__8'><span onclick="PonerOpcion('var_d16','8')">8: El presupuesto familiar</span></li>
<li id='var_d16__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d16','9')">9: Otro</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
SOLO PARA LAS PERSONAS CON DISCAPACIDAD QUE NECESITAN ASISTENCIA O AYUDA HABITUAL DE OTRA PERSONA PERO NO LA RECIBEN<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D17</span>
<span class='pre_texto' id='pre_D17'>¿Cuál es el motivo principal por el que no recibe la asistencia o la ayuda habitual de otra persona para realizar las actividades cotidianas? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d17' name='var_d17' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d17");' onKeyPress='PresionTeclaEnVariable("var_d17",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d17",event);' ></span>
</td><td colspan=3><li id='var_d17__1'><span onclick="PonerOpcion('var_d17','1')">1: Porque la obra social/mutual/prepaga no le da respuesta</span></li>
<li id='var_d17__2'><span onclick="PonerOpcion('var_d17','2')">2: Porque no sabe qué trámites tiene que hacer o dónde debe solicitarlo</span></li>
<li id='var_d17__3'><span onclick="PonerOpcion('var_d17','3')">3: Porque no hay un programa público que lo brinde</span></li>
<li id='var_d17__4'><span onclick="PonerOpcion('var_d17','4')">4: No tiene un familiar o amigo que lo asista</span></li>
<li id='var_d17__5'><span onclick="PonerOpcion('var_d17','5')">5: No lo puede pagar con el presupuesto del hogar</span></li>
<li id='var_d17__6'><span onclick="PonerOpcion('var_d17','6')">6: otros motivos</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_1</span>
<span class='pre_texto' id='pre_FILTRO_1'>SOLO PARA LAS PERSONAS CON DISCAPACIDAD QUE ASISTEN ACTUALMENTE A EDUCACIÓN COMÚN <span class='pre_aclaracion'>Cuestionario I1. Pregunta E6 ≠ 5 o 6. Resto pase a Filtro 3</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_1' name='var_filtro_1' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_1");' onKeyPress='PresionTeclaEnVariable("var_filtro_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_1",event);' ></span>
 <span class='texto_salto' id='var_filtro_1.salto'> &#8631; FILTRO_2</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO A EDUCACIÓN Y APOYO EDUCATIVO<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D18</span>
<span class='pre_texto' id='pre_D18'>A causa de la discapacidad ¿Necesita apoyos para la integración educativa? <span class='pre_aclaracion'>de algún personal especializado</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d18' name='var_d18' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d18");' onKeyPress='PresionTeclaEnVariable("var_d18",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d18",event);' ></span>
</td><td colspan=3><li id='var_d18__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d18','1')">1: Si</span></li>
<li id='var_d18__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d18','2','pre_FILTRO_2')">2: No</span> <span class='texto_salto' id='var_d18.2.salto'> &#8631; FILTRO_2</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D19</span>
<span class='pre_texto' id='pre_D19'>¿Recibe el apoyo que necesita para la integración educativa? <span class='pre_aclaracion'>de algún personal especializado</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d19' name='var_d19' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d19");' onKeyPress='PresionTeclaEnVariable("var_d19",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d19",event);' ></span>
</td><td colspan=3><li id='var_d19__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d19','1')">1: Si</span></li>
<li id='var_d19__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d19','2','pre_D21')">2: No</span> <span class='texto_salto' id='var_d19.2.salto'> &#8631; D21</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
SÓLO PARA LAS PERSONAS CON DISCAPACIDAD QUE RECIBEN APOYO PARA LA INTEGRACIÓN EDUCATIVA<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D20</span>
<span class='pre_texto' id='pre_D20'>¿Quién cubre la mayor parte del costo del apoyo a la integración educativa? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d20' name='var_d20' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d20");' onKeyPress='PresionTeclaEnVariable("var_d20",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d20",event);' ></span>
 <span class='texto_salto' id='var_d20.salto'> &#8631; FILTRO_2</span>
</td><td colspan=3><li id='var_d20__1'><span onclick="PonerOpcion('var_d20','1')">1: Una obra social</span></li>
<li id='var_d20__2'><span onclick="PonerOpcion('var_d20','2')">2: Una mutual</span></li>
<li id='var_d20__3'><span onclick="PonerOpcion('var_d20','3')">3: El establecimiento escolar</span></li>
<li id='var_d20__4'><span onclick="PonerOpcion('var_d20','4')">4: El presupuesto familiar</span></li>
<li id='var_d20__5' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d20','5')">5: Otro</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
SÓLO PARA LAS PERSONAS CON DISCAPACIDAD QUE NECESITAN Y NO RECIBEN APOYO PARA LA INTEGRACIÓN EDUCATIVA<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D21</span>
<span class='pre_texto' id='pre_D21'>¿Cuál es el motivo principal por el que no recibe apoyo para la integración educativa? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d21' name='var_d21' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d21");' onKeyPress='PresionTeclaEnVariable("var_d21",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d21",event);' ></span>
</td><td colspan=3><li id='var_d21__1'><span onclick="PonerOpcion('var_d21','1')">1: Porque la obra social/mutual/prepaga dice que no lo cubre</span></li>
<li id='var_d21__2'><span onclick="PonerOpcion('var_d21','2')">2: Porque la obra social/mutual/prepaga no le da respuesta</span></li>
<li id='var_d21__3'><span onclick="PonerOpcion('var_d21','3')">3: Porque no sabe que tipo de apoyo necesita</span></li>
<li id='var_d21__4'><span onclick="PonerOpcion('var_d21','4')">4: Porque no sabe que tipo de trámites tiene que hacer o dónde solicitarlo</span></li>
<li id='var_d21__5'><span onclick="PonerOpcion('var_d21','5')">5: Porque el establecimiento escolar no se lo permite</span></li>
<li id='var_d21__6'><span onclick="PonerOpcion('var_d21','6')">6: otros motivos</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_2</span>
<span class='pre_texto' id='pre_FILTRO_2'>SÓLO PARA LAS PERSONAS CON DISCAPACIDAD QUE ASISTEN ACTUALMENTE A EDUCACIÓN ESPECIAL <span class='pre_aclaracion'>Cuestionario I1. Pregunta E6 = 5 o 6</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_2' name='var_filtro_2' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_2");' onKeyPress='PresionTeclaEnVariable("var_filtro_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_2",event);' ></span>
 <span class='texto_salto' id='var_filtro_2.salto'> &#8631; FILTRO_3</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D22</span>
<span class='pre_texto' id='pre_D22'>¿Intentó conseguir vacante en la escuela común en el nivel actual?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d22' name='var_d22' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d22");' onKeyPress='PresionTeclaEnVariable("var_d22",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d22",event);' ></span>
</td><td colspan=3><li id='var_d22__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d22','1')">1: Si</span></li>
<li id='var_d22__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d22','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
ACCESO AL TRABAJO<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_3</span>
<span class='pre_texto' id='pre_FILTRO_3'>SÓLO PARA LAS PERSONAS CON DISCAPACIDAD OCUPADAS <span class='pre_aclaracion'>Cuestionario I1. Pregunta T35 = 1 o 2. Resto pase a FILTRO 5</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_3' name='var_filtro_3' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_3");' onKeyPress='PresionTeclaEnVariable("var_filtro_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_3",event);' ></span>
 <span class='texto_salto' id='var_filtro_3.salto'> &#8631; FILTRO_5</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
PARA TODAS LAS PERSONAS OCUPADAS<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D23</span>
<span class='pre_texto' id='pre_D23'>A causa de la discapacidad ¿Necesita apoyos para trabajar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d23' name='var_d23' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d23");' onKeyPress='PresionTeclaEnVariable("var_d23",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d23",event);' ></span>
</td><td colspan=3><li id='var_d23__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d23','1')">1: Si</span></li>
<li id='var_d23__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d23','2','pre_FILTRO_4')">2: No</span> <span class='texto_salto' id='var_d23.2.salto'> &#8631; FILTRO_4</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D24</span>
<span class='pre_texto' id='pre_D24'>¿Recibe los apoyos que necesita para trabajar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d24' name='var_d24' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d24");' onKeyPress='PresionTeclaEnVariable("var_d24",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d24",event);' ></span>
</td><td colspan=3><li id='var_d24__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d24','1')">1: Si</span></li>
<li id='var_d24__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d24','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_4</span>
<span class='pre_texto' id='pre_FILTRO_4'>SÓLO PARA LAS PERSONAS CON DISCAPACIDAD OCUPADAS DEL SECTOR PÚBLICO <span class='pre_aclaracion'>Cuestionario I1. Pregunta T38 = 1. Resto pase a pregunta D27.</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_4' name='var_filtro_4' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_4");' onKeyPress='PresionTeclaEnVariable("var_filtro_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_4",event);' ></span>
 <span class='texto_salto' id='var_filtro_4.salto'> &#8631; D27</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D25</span>
<span class='pre_texto' id='pre_D25'>¿Ingresó por la ley de cupo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d25' name='var_d25' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d25");' onKeyPress='PresionTeclaEnVariable("var_d25",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d25",event);' ></span>
 <span class='texto_salto' id='var_d25.salto'> &#8631; D27</span>
</td><td colspan=3><li id='var_d25__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d25','1')">1: Si</span></li>
<li id='var_d25__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d25','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_5</span>
<span class='pre_texto' id='pre_FILTRO_5'>SÓLO PARA LAS PERSONAS CON DISCAPACIDAD INACTIVAS <span class='pre_aclaracion'>Cuestionario I1. Pregunta T13 = 1 o 2. Resto pase a pregunta D 27</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_5' name='var_filtro_5' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_5");' onKeyPress='PresionTeclaEnVariable("var_filtro_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_5",event);' ></span>
 <span class='texto_salto' id='var_filtro_5.salto'> &#8631; D27</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D26</span>
<span class='pre_texto' id='pre_D26'>¿Cuál es el motivo principal por el que no buscó trabajo? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d26' name='var_d26' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d26");' onKeyPress='PresionTeclaEnVariable("var_d26",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d26",event);' ></span>
</td><td colspan=3><li id='var_d26__1'><span onclick="PonerOpcion('var_d26','1')">1: Porque piensa que no va a encontrar trabajo/se cansó de buscar trabajo</span></li>
<li id='var_d26__2'><span onclick="PonerOpcion('var_d26','2')">2: Porque no hay trabajo para las personas con discapacidad</span></li>
<li id='var_d26__3'><span onclick="PonerOpcion('var_d26','3')">3: Porque considera que no está lo suficientemente preparado/a</span></li>
<li id='var_d26__4'><span onclick="PonerOpcion('var_d26','4')">4: Por los problemas de accesibilidad en la vía pública, edificios, establecimientos, etc.</span></li>
<li id='var_d26__5'><span onclick="PonerOpcion('var_d26','5')">5: Porque cobra una pensión por discapacidad o un subsidio y no quiere perderlo o suspenderlo</span></li>
<li id='var_d26__6'><span onclick="PonerOpcion('var_d26','6')">6: Porque todavía está estudiando</span></li>
<li id='var_d26__7'><span onclick="PonerOpcion('var_d26','7')">7: Otro motivo</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>D27</span>
<span class='pre_texto' id='pre_D27'>¿Conoce la actual COPIDIS? <span class='pre_aclaracion'>Comisión para la Plena Inclusión de las Personas con Discapacidad - ex COPINE</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_d27' name='var_d27' type='number'  class='input_opciones' onblur='ValidarOpcion("var_d27");' onKeyPress='PresionTeclaEnVariable("var_d27",event);' onKeyDown='PresionOtraTeclaEnVariable("var_d27",event);' ></span>
 <span class='texto_salto' id='var_d27.salto'> &#8631; Fin</span>
</td><td colspan=3><li id='var_d27__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d27','1')">1: Si</span></li>
<li id='var_d27__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_d27','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Razón por la cual no se realizó la entrevista<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_razon_no_realizada'>Entrevista realizada</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon_no_realizada' name='var_razon_no_realizada' type='number'  class='input_opciones' onblur='ValidarOpcion("var_razon_no_realizada");' onKeyPress='PresionTeclaEnVariable("var_razon_no_realizada",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon_no_realizada",event);' ></span>
</td><td colspan=3><li id='var_razon_no_realizada__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon_no_realizada','1')">1: Ausencia</span></li>
<li id='var_razon_no_realizada__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon_no_realizada','2')">2: Rechazo</span></li>
<li id='var_razon_no_realizada__3'><span onclick="PonerOpcion('var_razon_no_realizada','3','pre_Fin')">3: Otras causas</span> <span class='texto_salto' id='var_razon_no_realizada.3.salto'> &#8631; Fin</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Razon de la ausencia<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_razon_no_realizada_1'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon_no_realizada_1' name='var_razon_no_realizada_1' type='number'  class='input_opciones' onblur='ValidarOpcion("var_razon_no_realizada_1");' onKeyPress='PresionTeclaEnVariable("var_razon_no_realizada_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon_no_realizada_1",event);' ></span>
 <span class='texto_salto' id='var_razon_no_realizada_1.salto'> &#8631; Fin</span>
</td><td colspan=3><li id='var_razon_no_realizada_1__a'><span onclick="PonerOpcion('var_razon_no_realizada_1','a')">a: No se pudo contactar en 3 visitas</span></li>
<li id='var_razon_no_realizada_1__b'><span onclick="PonerOpcion('var_razon_no_realizada_1','b')">b: Por causas circunstanciales</span></li>
<li id='var_razon_no_realizada_1__c' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon_no_realizada_1','c')">c: Viaje</span></li>
<li id='var_razon_no_realizada_1__d'><span onclick="PonerOpcion('var_razon_no_realizada_1','d')">d: Vacaciones</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Razon del rechazo<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_razon_no_realizada_2'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon_no_realizada_2' name='var_razon_no_realizada_2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_razon_no_realizada_2");' onKeyPress='PresionTeclaEnVariable("var_razon_no_realizada_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon_no_realizada_2",event);' ></span>
 <span class='texto_salto' id='var_razon_no_realizada_2.salto'> &#8631; Fin</span>
</td><td colspan=3><li id='var_razon_no_realizada_2__a'><span onclick="PonerOpcion('var_razon_no_realizada_2','a')">a: Negativa rotunda</span></li>
<li id='var_razon_no_realizada_2__b'><span onclick="PonerOpcion('var_razon_no_realizada_2','b')">b: Rechazo por portero eléctrico</span></li>
<li id='var_razon_no_realizada_2__c'><span onclick="PonerOpcion('var_razon_no_realizada_2','c')">c: Se acordaron entrevistas que no se acordaron</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Fin del formulario	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"MD","matriz":null});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>