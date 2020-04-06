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
<span class='pre_pre'>FILTRO_0</span>
<span class='pre_texto' id='pre_FILTRO_0'>Vivienda <span class='pre_aclaracion'>Si existe más de un hogar, aplique el bloque vivienda sólo al primero. El segundo hogar pasa a H1.</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_0' name='var_filtro_0' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_0");' onKeyPress='PresionTeclaEnVariable("var_filtro_0",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_0",event);' ></span>
 <span class='texto_salto' id='var_filtro_0.salto'> &#8631; H1</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V2</span>
<span class='pre_texto' id='pre_V2'>Tipo de vivienda <span class='pre_aclaracion'>Obsvacional</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_v2' name='var_v2' type='text'  class='input_opciones' onblur='ValidarOpcion("var_v2");' onKeyPress='PresionTeclaEnVariable("var_v2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v2",event);' ></span>
</td><td colspan=3><li id='var_v2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v2','1')">1: Casa</span></li>
<li id='var_v2__2'><span onclick="PonerOpcion('var_v2','2')">2: Departamento</span></li>
<li id='var_v2__3'><span onclick="PonerOpcion('var_v2','3')">3: Inquilinato o conventillo</span></li>
<li id='var_v2__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v2','4')">4: Pensión</span></li>
<li id='var_v2__5'><span onclick="PonerOpcion('var_v2','5')">5: Construcción no destinada a vivenda</span></li>
<li id='var_v2__6'><span onclick="PonerOpcion('var_v2','6')">6: Rancho o casilla</span></li>
<li id='var_v2__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v2','7')">7: Hotel</span></li>
<li id='var_v2__8' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v2','8')">8: Otro</span> <span class='opc_aclaracion'>Especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_v2_esp' name='var_v2_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_v2_esp");' onKeyPress='PresionTeclaEnVariable("var_v2_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v2_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V4</span>
<span class='pre_texto' id='pre_V4'>¿Cuántas habitaciones/ ambientes tiene, en total, esta vivienda? Sin contar baño/s, cocina/s, garajes o pasillo/s</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_v4' name='var_v4' type='text'  class='input_numeros' onblur='ValidarOpcion("var_v4");' onKeyPress='PresionTeclaEnVariable("var_v4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v4",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V5</span>
<span class='pre_texto' id='pre_V5'>Los pisos interiores son principalmente de... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_v5' name='var_v5' type='text'  class='input_opciones' onblur='ValidarOpcion("var_v5");' onKeyPress='PresionTeclaEnVariable("var_v5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v5",event);' ></span>
</td><td colspan=3><li id='var_v5__1'><span onclick="PonerOpcion('var_v5','1')">1: Mosaico/ baldosa/ madera/ cerámica</span></li>
<li id='var_v5__2'><span onclick="PonerOpcion('var_v5','2')">2: Cemento/ ladrillo fijo</span></li>
<li id='var_v5__3'><span onclick="PonerOpcion('var_v5','3')">3: Ladrillo suelto/ tierra</span></li>
<li id='var_v5__4'><span onclick="PonerOpcion('var_v5','4')">4: Otro material</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_v5_esp' name='var_v5_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_v5_esp");' onKeyPress='PresionTeclaEnVariable("var_v5_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v5_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V6</span>
<span class='pre_texto' id='pre_V6'>La cubierta exterior del techo es de... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_v6' name='var_v6' type='text'  class='input_opciones' onblur='ValidarOpcion("var_v6");' onKeyPress='PresionTeclaEnVariable("var_v6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v6",event);' ></span>
</td><td colspan=3><li id='var_v6__1'><span onclick="PonerOpcion('var_v6','1')">1: Membrana/ cubierta asfáltica</span></li>
<li id='var_v6__2'><span onclick="PonerOpcion('var_v6','2')">2: Baldosa/ losa sin cubierta</span></li>
<li id='var_v6__3'><span onclick="PonerOpcion('var_v6','3')">3: Pizarra/ teja</span></li>
<li id='var_v6__4'><span onclick="PonerOpcion('var_v6','4')">4: Chapa de metal sin cubierta</span></li>
<li id='var_v6__5'><span onclick="PonerOpcion('var_v6','5')">5: Chapa de fibrocemento/ plástico</span></li>
<li id='var_v6__6'><span onclick="PonerOpcion('var_v6','6')">6: Chapa de cartón</span></li>
<li id='var_v6__7'><span onclick="PonerOpcion('var_v6','7')">7: Caña/ tabla/ paja con barro/ paja sola</span></li>
<li id='var_v6__8'><span onclick="PonerOpcion('var_v6','8')">8: Es un edificio de departamento</span></li>
<li id='var_v6__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v6','9')">9: N/S</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V7</span>
<span class='pre_texto' id='pre_V7'>¿El techo tiene cielorraso/ revestimiento interior</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_v7' name='var_v7' type='text'  class='input_si_no' onblur='ValidarOpcion("var_v7");' onKeyPress='PresionTeclaEnVariable("var_v7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v7",event);' ></span>
</td><td colspan=3><li id='var_v7__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v7','1')">1: Sí</span></li>
<li id='var_v7__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v7','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>V12</span>
<span class='pre_texto' id='pre_V12'>Esta vivienda, ¿Dispone de.... <span class='pre_aclaracion'>G-S lea todas las opciones hasta obtener una respuesta hasta obtener una respuesta positiva</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_v12' name='var_v12' type='text'  class='input_opciones' onblur='ValidarOpcion("var_v12");' onKeyPress='PresionTeclaEnVariable("var_v12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v12",event);' ></span>
</td><td colspan=3><li id='var_v12__1'><span onclick="PonerOpcion('var_v12','1')">1: Inodoro o retrete con descarga de agua a red cloacal pública?</span> <span class='opc_aclaracion'>Botón, cadena, etc.</span></li>
<li id='var_v12__2'><span onclick="PonerOpcion('var_v12','2')">2: Inodoro o retrete con descarga de agua a pozo o cámara séptica?</span> <span class='opc_aclaracion'>Botón, cadena, etc.</span></li>
<li id='var_v12__3'><span onclick="PonerOpcion('var_v12','3')">3: Inodoro o retrete sin descarga de agua</span> <span class='opc_aclaracion'>Letrina</span></li>
<li id='var_v12__4'><span onclick="PonerOpcion('var_v12','4','pre_H2')">4: No dispone de inodoro o retrete</span> <span class='texto_salto' id='var_v12.4.salto'> &#8631; H2</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H1</span>
<span class='pre_texto' id='pre_H1'>¿El baño es... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_h1' name='var_h1' type='text'  class='input_opciones' onblur='ValidarOpcion("var_h1");' onKeyPress='PresionTeclaEnVariable("var_h1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h1",event);' ></span>
</td><td colspan=3><li id='var_h1__1'><span onclick="PonerOpcion('var_h1','1')">1: de uso exclusivo del hogar?</span></li>
<li id='var_h1__2'><span onclick="PonerOpcion('var_h1','2')">2: compartido con otro hogar?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H2</span>
<span class='pre_texto' id='pre_H2'>Este hogar ¿Es... <span class='pre_aclaracion'>G-S lea todas las opciones hasta obtener una respuesta hasta obtener una respuesta positiva</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_h2' name='var_h2' type='text'  class='input_opciones' onblur='ValidarOpcion("var_h2");' onKeyPress='PresionTeclaEnVariable("var_h2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h2",event);' ></span>
</td><td colspan=3><li id='var_h2__1'><span onclick="PonerOpcion('var_h2','1')">1: propietario de la vivienda y el terreno?</span></li>
<li id='var_h2__2'><span onclick="PonerOpcion('var_h2','2')">2: propietario de la vivenda solamente?</span></li>
<li id='var_h2__3'><span onclick="PonerOpcion('var_h2','3')">3: inquilino o arrendatario?</span></li>
<li id='var_h2__4'><span onclick="PonerOpcion('var_h2','4')">4: ocupante en relación de dependencia/ por trabajo?</span></li>
<li id='var_h2__5'><span onclick="PonerOpcion('var_h2','5')">5: ocupante por préstamo, cesién o permiso gratuito?</span> <span class='opc_aclaracion'>sin pago</span></li>
<li id='var_h2__6'><span onclick="PonerOpcion('var_h2','6')">6: ocupande de hecho de la vivienda?</span></li>
<li id='var_h2__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h2','7')">7: otro</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_h2_esp' name='var_h2_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_h2_esp");' onKeyPress='PresionTeclaEnVariable("var_h2_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h2_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H3</span>
<span class='pre_texto' id='pre_H3'>¿Cuántas habitaciones/ ambientes son de uso exclusivo de este hogar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_h3' name='var_h3' type='text'  class='input_numeros' onblur='ValidarOpcion("var_h3");' onKeyPress='PresionTeclaEnVariable("var_h3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h3",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H4</span>
<span class='pre_texto' id='pre_H4'>¿Disponen de teléfono para uso del hogar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_h4' name='var_h4' type='text'  class='input_opciones' onblur='ValidarOpcion("var_h4");' onKeyPress='PresionTeclaEnVariable("var_h4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h4",event);' ></span>
</td><td colspan=3><li id='var_h4__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h4','1')">1: Si</span></li>
<li id='var_h4__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h4','2')">2: No</span></li>
</td></tr>
<tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_h4_tipot' name='var_h4_tipot' type='text'  class='input_opciones' onblur='ValidarOpcion("var_h4_tipot");' onKeyPress='PresionTeclaEnVariable("var_h4_tipot",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h4_tipot",event);' ></span>
</td><td colspan=3><li id='var_h4_tipot__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h4_tipot','1')">1: Fijo</span></li>
<li id='var_h4_tipot__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h4_tipot','2')">2: Celular</span></li>
<li id='var_h4_tipot__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h4_tipot','3')">3: Ambos</span></li>
</td></tr>
<tr><td colspan=3>¿Desea dar algun numero?<td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_h4_tel' name='var_h4_tel' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_h4_tel");' onKeyPress='PresionTeclaEnVariable("var_h4_tel",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h4_tel",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H20</span>
<span class='pre_texto' id='pre_H20'>Le voy a nombrar distintas formas para mantener un hogar y quisiera que me diga las que uds utilicen. ¿En los últimos 3 meses este hogar ha vivido... <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_1' name='var_h20_1' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_1");' onKeyPress='PresionTeclaEnVariable("var_h20_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_1",event);' ></span>
</td><td colspan=3><li id='var_h20_1__1'><span onclick="PonerOpcion('var_h20_1','1')">1: de lo que ganan los miembros del hogar en el trabajo?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_4' name='var_h20_4' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_4");' onKeyPress='PresionTeclaEnVariable("var_h20_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_4",event);' ></span>
</td><td colspan=3><li id='var_h20_4__4'><span onclick="PonerOpcion('var_h20_4','4')">4: retirando dinero o mercadería del propio negocio?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_2' name='var_h20_2' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_2");' onKeyPress='PresionTeclaEnVariable("var_h20_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_2",event);' ></span>
</td><td colspan=3><li id='var_h20_2__2'><span onclick="PonerOpcion('var_h20_2','2')">2: de la jubilación o pensión de algun/os de los miembros del hogar?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_17' name='var_h20_17' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_17");' onKeyPress='PresionTeclaEnVariable("var_h20_17",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_17",event);' ></span>
</td><td colspan=3><li id='var_h20_17__17'><span onclick="PonerOpcion('var_h20_17','17')">17: del seguro de desempleo?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_18' name='var_h20_18' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_18");' onKeyPress='PresionTeclaEnVariable("var_h20_18",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_18",event);' ></span>
</td><td colspan=3><li id='var_h20_18__18'><span onclick="PonerOpcion('var_h20_18','18')">18: indemnización por despido?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_5' name='var_h20_5' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_5");' onKeyPress='PresionTeclaEnVariable("var_h20_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_5",event);' ></span>
</td><td colspan=3><li id='var_h20_5__5'><span onclick="PonerOpcion('var_h20_5','5')">5: del cobro de alquileres, rentas, intereses o dividendos?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_6' name='var_h20_6' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_6");' onKeyPress='PresionTeclaEnVariable("var_h20_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_6",event);' ></span>
</td><td colspan=3><li id='var_h20_6__6'><span onclick="PonerOpcion('var_h20_6','6')">6: de cuotas de alimento?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_7' name='var_h20_7' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_7");' onKeyPress='PresionTeclaEnVariable("var_h20_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_7",event);' ></span>
</td><td colspan=3><li id='var_h20_7__7'><span onclick="PonerOpcion('var_h20_7','7')">7: de ayuda en dinero de personas que no viven en el hogar?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_15' name='var_h20_15' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_15");' onKeyPress='PresionTeclaEnVariable("var_h20_15",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_15",event);' ></span>
</td><td colspan=3><li id='var_h20_15__15'><span onclick="PonerOpcion('var_h20_15','15')">15: de lo que recibe del programa ciudadanía porteña a travez de una tarjeta de compra Cabal?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_8' name='var_h20_8' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_8");' onKeyPress='PresionTeclaEnVariable("var_h20_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_8",event);' ></span>
</td><td colspan=3><li id='var_h20_8__8'><span onclick="PonerOpcion('var_h20_8','8')">8: de otro subsidio o plan social del gobierno?</span> <span class='opc_aclaracion'>En dinero, nacional o local</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_19' name='var_h20_19' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_19");' onKeyPress='PresionTeclaEnVariable("var_h20_19",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_19",event);' ></span>
</td><td colspan=3><li id='var_h20_19__19'><span onclick="PonerOpcion('var_h20_19','19')">19: de una beca de estudio?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_20' name='var_h20_20' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_20");' onKeyPress='PresionTeclaEnVariable("var_h20_20",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_20",event);' ></span>
</td><td colspan=3><li id='var_h20_20__20'><span onclick="PonerOpcion('var_h20_20','20')">20: de dinero entregado por una iglesia, escuela, organización comunitaria, etc.?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_16' name='var_h20_16' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_16");' onKeyPress='PresionTeclaEnVariable("var_h20_16",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_16",event);' ></span>
</td><td colspan=3><li id='var_h20_16__16'><span onclick="PonerOpcion('var_h20_16','16')">16: con mercaderia, ropa, alimentos entregado por el gobierno?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_10' name='var_h20_10' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_10");' onKeyPress='PresionTeclaEnVariable("var_h20_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_10",event);' ></span>
</td><td colspan=3><li id='var_h20_10__10'><span onclick="PonerOpcion('var_h20_10','10')">10: con mercaderia, ropa, alimentos entregado por alguna iglesia, escuela, organización comunitaria, etc.?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_12' name='var_h20_12' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_12");' onKeyPress='PresionTeclaEnVariable("var_h20_12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_12",event);' ></span>
</td><td colspan=3><li id='var_h20_12__12'><span onclick="PonerOpcion('var_h20_12','12')">12: comprando a fiado o en cuota?</span> <span class='opc_aclaracion'>Libreta, tarjeta de crédito</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_11' name='var_h20_11' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_11");' onKeyPress='PresionTeclaEnVariable("var_h20_11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_11",event);' ></span>
</td><td colspan=3><li id='var_h20_11__11'><span onclick="PonerOpcion('var_h20_11','11')">11: gastando lo que tenía ahorrado?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_13' name='var_h20_13' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_13");' onKeyPress='PresionTeclaEnVariable("var_h20_13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_13",event);' ></span>
</td><td colspan=3><li id='var_h20_13__13'><span onclick="PonerOpcion('var_h20_13','13')">13: de la venta de pertenencias?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_h20_14' name='var_h20_14' type='text'  class='input_marcar' onblur='ValidarOpcion("var_h20_14");' onKeyPress='PresionTeclaEnVariable("var_h20_14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_14",event);' ></span>
</td><td colspan=3><li id='var_h20_14__14'><span onclick="PonerOpcion('var_h20_14','14')">14: de alguna otra forma?</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_h20_esp' name='var_h20_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_h20_esp");' onKeyPress='PresionTeclaEnVariable("var_h20_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h20_esp",event);' ></span>
</td><td colspan=0></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>X5</span>
<span class='pre_texto' id='pre_X5'>¿Alguna persona que formaba parte de este hogar y vivía en la ciudad, se ha ido a vivir fuera de la ciudad?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_x5' name='var_x5' type='text'  class='input_opciones' onblur='ValidarOpcion("var_x5");' onKeyPress='PresionTeclaEnVariable("var_x5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_x5",event);' ></span>
</td><td colspan=3><li id='var_x5__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_x5','1')">1: Sí</span></li>
<li id='var_x5__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_x5','2','pre_H30')">2: No</span> <span class='texto_salto' id='var_x5.2.salto'> &#8631; H30</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2>
Grilla ex-miembros		<table class="matriz_horizontal"><tr id='titulos_matriz_X' class='unica_fila_preguntas_matriz'>
<td>
<span class='hori_pre_texto' id='pre_ex'>Nro</span>
<td>
<span class='hori_pre_texto' id='pre_sexo_ex'>Sexo</span>
<td>
<span class='hori_pre_texto' id='pre_pais_nac'>País de nacimiento</span>
<td>
<span class='hori_pre_texto' id='pre_edad_ex'>Edad al momento de irse</span>
<td>
<span class='hori_pre_texto' id='pre_niv_educ'>Nivel educativo al momento de irse</span>
<td>
<span class='hori_pre_texto' id='pre_anio'>Año en que se fue</span>
<td>
<span class='hori_pre_texto' id='pre_lugar'>A que lugar se fué?</span>
<tr id='fila_matriz_X' class='fila_matriz'><td id='var_ex_miembro'><td id='var_sexo_ex'><td id='var_pais_nac'><td id='var_edad_ex'><td id='var_niv_educ'><td id='var_anio'><td id='var_lugar'><td id='var_lugar_desc'>	</table><tr class='fila_pregunta'>
<td>
<span class='pre_pre'>X5_tot</span>
<span class='pre_texto' id='pre_X5_tot'>Total de personas</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Total de personas<td colspan=1><span class='respuesta'  title='numeros'><input id='var_x5_tot' name='var_x5_tot' type='text'  class='input_numeros' onblur='ValidarOpcion("var_x5_tot");' onKeyPress='PresionTeclaEnVariable("var_x5_tot",event);' onKeyDown='PresionOtraTeclaEnVariable("var_x5_tot",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>H30</span>
<span class='pre_texto' id='pre_H30'>¿En su hogar tienen...</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>televisor?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_tv' name='var_h30_tv' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_tv");' onKeyPress='PresionTeclaEnVariable("var_h30_tv",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_tv",event);' ></span>
</td><td colspan=3><li id='var_h30_tv__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_tv','1')">1: Sólo 1</span></li>
<li id='var_h30_tv__2'><span onclick="PonerOpcion('var_h30_tv','2')">2: Dos y más</span></li>
<li id='var_h30_tv__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_tv','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>heladera con freezer?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_hf' name='var_h30_hf' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_hf");' onKeyPress='PresionTeclaEnVariable("var_h30_hf",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_hf",event);' ></span>
</td><td colspan=3><li id='var_h30_hf__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_hf','1')">1: Sólo 1</span></li>
<li id='var_h30_hf__2'><span onclick="PonerOpcion('var_h30_hf','2')">2: Dos y más</span></li>
<li id='var_h30_hf__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_hf','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>lavarropas automatico?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_la' name='var_h30_la' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_la");' onKeyPress='PresionTeclaEnVariable("var_h30_la",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_la",event);' ></span>
</td><td colspan=3><li id='var_h30_la__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_la','1')">1: Sólo 1</span></li>
<li id='var_h30_la__2'><span onclick="PonerOpcion('var_h30_la','2')">2: Dos y más</span></li>
<li id='var_h30_la__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_la','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>videocasetera?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_vi' name='var_h30_vi' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_vi");' onKeyPress='PresionTeclaEnVariable("var_h30_vi",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_vi",event);' ></span>
</td><td colspan=3><li id='var_h30_vi__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_vi','1')">1: Sólo 1</span></li>
<li id='var_h30_vi__2'><span onclick="PonerOpcion('var_h30_vi','2')">2: Dos y más</span></li>
<li id='var_h30_vi__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_vi','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>aire acondicionado?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_ac' name='var_h30_ac' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_ac");' onKeyPress='PresionTeclaEnVariable("var_h30_ac",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_ac",event);' ></span>
</td><td colspan=3><li id='var_h30_ac__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_ac','1')">1: Sólo 1</span></li>
<li id='var_h30_ac__2'><span onclick="PonerOpcion('var_h30_ac','2')">2: Dos y más</span></li>
<li id='var_h30_ac__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_ac','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>DVD?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_dvd' name='var_h30_dvd' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_dvd");' onKeyPress='PresionTeclaEnVariable("var_h30_dvd",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_dvd",event);' ></span>
</td><td colspan=3><li id='var_h30_dvd__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_dvd','1')">1: Sólo 1</span></li>
<li id='var_h30_dvd__2'><span onclick="PonerOpcion('var_h30_dvd','2')">2: Dos y más</span></li>
<li id='var_h30_dvd__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_dvd','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>microondas?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_mo' name='var_h30_mo' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_mo");' onKeyPress='PresionTeclaEnVariable("var_h30_mo",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_mo",event);' ></span>
</td><td colspan=3><li id='var_h30_mo__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_mo','1')">1: Sólo 1</span></li>
<li id='var_h30_mo__2'><span onclick="PonerOpcion('var_h30_mo','2')">2: Dos y más</span></li>
<li id='var_h30_mo__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_mo','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>computadora?<td colspan=1><span class='respuesta'  title='solo12no_tiene'><input id='var_h30_pc' name='var_h30_pc' type='text'  class='input_solo12no_tiene' onblur='ValidarOpcion("var_h30_pc");' onKeyPress='PresionTeclaEnVariable("var_h30_pc",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_pc",event);' ></span>
</td><td colspan=3><li id='var_h30_pc__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_pc','1')">1: Sólo 1</span></li>
<li id='var_h30_pc__2'><span onclick="PonerOpcion('var_h30_pc','2')">2: Dos y más</span></li>
<li id='var_h30_pc__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_pc','3')">3: No tienen</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>conexión a internet?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_h30_in' name='var_h30_in' type='text'  class='input_si_no' onblur='ValidarOpcion("var_h30_in");' onKeyPress='PresionTeclaEnVariable("var_h30_in",event);' onKeyDown='PresionOtraTeclaEnVariable("var_h30_in",event);' ></span>
</td><td colspan=3><li id='var_h30_in__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_in','1')">1: Si</span></li>
<li id='var_h30_in__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_h30_in','2')">2: No</span></li>
</td></tr>
</table>
	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"A1","matriz":null});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>