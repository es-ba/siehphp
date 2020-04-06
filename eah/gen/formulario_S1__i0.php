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
<span class='pre_texto' id='pre_part'>Hogar: <span id=BotoneraHogares></span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Participación<td colspan=1><span class='respuesta'  title='info_numero'><input id='var_participacion' name='var_participacion' type='text' readonly=readonly class='input_info_numero' onblur='ValidarOpcion("var_participacion");' onKeyPress='PresionTeclaEnVariable("var_participacion",event);' onKeyDown='PresionOtraTeclaEnVariable("var_participacion",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_entrea'>Entrevista Realizada</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_entrea' name='var_entrea' type='text'  class='input_opciones' onblur='ValidarOpcion("var_entrea");' onKeyPress='PresionTeclaEnVariable("var_entrea",event);' onKeyDown='PresionOtraTeclaEnVariable("var_entrea",event);' ></span>
</td><td colspan=3><li id='var_entrea__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_entrea','1')">1: Sí</span></li>
<li id='var_entrea__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_entrea','2')">2: No</span></li>
<li id='var_entrea__18'><span onclick="PonerOpcion('var_entrea','18')">18: Parcialmente realizada</span> <span class='opc_aclaracion'> * </span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_respond'>Número de miembro respondente</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_respond' name='var_respond' type='text'  class='input_numeros' onblur='ValidarOpcion("var_respond");' onKeyPress='PresionTeclaEnVariable("var_respond",event);' onKeyDown='PresionOtraTeclaEnVariable("var_respond",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_telefono'>Tel</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_telefono' name='var_telefono' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_telefono");' onKeyPress='PresionTeclaEnVariable("var_telefono",event);' onKeyDown='PresionOtraTeclaEnVariable("var_telefono",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_nombrer'>Nombre</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_nombrer' name='var_nombrer' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_nombrer");' onKeyPress='PresionTeclaEnVariable("var_nombrer",event);' onKeyDown='PresionOtraTeclaEnVariable("var_nombrer",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_f_realiz_o'>Fecha de realizacion</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='fecha_corta'><input id='var_f_realiz_o' name='var_f_realiz_o' type='text'  class='input_fecha_corta' onblur='ValidarOpcion("var_f_realiz_o");' onKeyPress='PresionTeclaEnVariable("var_f_realiz_o",event);' onKeyDown='PresionOtraTeclaEnVariable("var_f_realiz_o",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>v1</span>
<span class='pre_texto' id='pre_v1'>¿Todas las personas que residen en esta vivienda comparten los gastos de comida?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_v1' name='var_v1' type='text'  class='input_opciones' onblur='ValidarOpcion("var_v1");' onKeyPress='PresionTeclaEnVariable("var_v1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_v1",event);' ></span>
</td><td colspan=3><li id='var_v1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v1','1')">1: Si</span></li>
<li id='var_v1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_v1','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_total_h'>Total de hogares</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_total_h' name='var_total_h' type='text'  class='input_numeros' onblur='ValidarOpcion("var_total_h");' onKeyPress='PresionTeclaEnVariable("var_total_h",event);' onKeyDown='PresionOtraTeclaEnVariable("var_total_h",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_total_m'>Total de miembros</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_total_m' name='var_total_m' type='text'  class='input_numeros' onblur='ValidarOpcion("var_total_m");' onKeyPress='PresionTeclaEnVariable("var_total_m",event);' onKeyDown='PresionOtraTeclaEnVariable("var_total_m",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2>
COMPONENTES DEL HOGAR		<table class="matriz_horizontal"><tr id='titulos_matriz_P' class='unica_fila_preguntas_matriz'>
<td>
<span class='hori_pre_pre'>P0</span>
<span class='hori_pre_texto' id='pre_P0'>Nº</span>
<td>
<span class='hori_pre_pre'>P1</span>
<span class='hori_pre_texto' id='pre_P1'>nombre</span>
<td>
<span class='hori_pre_pre'>P2</span>
<span class='hori_pre_texto' id='pre_P2'>sexo</span>
<td>
<span class='hori_pre_pre'>P3A</span>
<span class='hori_pre_texto' id='pre_P3A'>f.nac</span>
<td>
<span class='hori_pre_pre'>P7</span>
<span class='hori_pre_texto' id='pre_P7'>Ent/Sal</span>
<td>
<span class='hori_pre_pre'>P8</span>
<span class='hori_pre_texto' id='pre_P8'>motivo</span>
<td>
<span class='hori_pre_pre'>P3B</span>
<span class='hori_pre_texto' id='pre_P3B'>años</span>
<td>
<span class='hori_pre_pre'>P4</span>
<span class='hori_pre_texto' id='pre_P4'>parentesco</span>
<td>
<span class='hori_pre_pre'>P5</span>
<span class='hori_pre_texto' id='pre_P5'>estado cony</span>
<td>
<span class='hori_pre_pre'>P5B</span>
<span class='hori_pre_texto' id='pre_P5B'>convive con</span>
<td>
<span class='hori_pre_pre'>P6A</span>
<span class='hori_pre_texto' id='pre_P6A'>padre</span>
<td>
<span class='hori_pre_pre'>P6B</span>
<span class='hori_pre_texto' id='pre_P6B'>madre</span>
<td>
<span class='hori_pre_texto' id='pre_Fin'>Fin del formulario</span>
<tr id='fila_matriz_P' class='fila_matriz'><td id='var_p0'><td id='var_nombre'><td id='var_sexo'><td id='var_f_nac_o'><td id='var_p7'><td id='var_p8'><td id='var_edad'><td id='var_p4'><td id='var_p5'><td id='var_p5b'><td id='var_p6_a'><td id='var_p6_b'>	</table><tr class='fila_pregunta'>
<td colspan=2><input type=button id=boton_ver_consistencias value='Ver consistencias' title='para todas las hogares de esta vivienda' onclick='CorrerConsistencias(this,pk_ud.encuesta,false);'>
<input type=button id=boton_correr_consistencias value='Correr consistencias' title='para todas las hogares de esta vivienda' onclick='CorrerConsistencias(this,pk_ud.encuesta,true);'>
<input type=button id=fin_encuesta_4 value='Mandar a campo' style='display:none' onclick='Cerrar_Encuesta(4)'><input type=button id=fin_encuesta_5 value='Mandar a procesamiento' style='display:none' onclick='Cerrar_Encuesta(5)'><input type=button id=fin_encuesta_6 value='Pasar a Fase 2' style='display:none' onclick='Cerrar_Encuesta(6)'><input type=button id=boton_cerrar_encuesta value='Cerrar encuesta' style='display:none' onclick='Cerrar_Encuesta()'><tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon1</span>
<span class='pre_texto' id='pre_razon1'>RAZON POR LA CUAL NO SE REALIZO LA ENTREVISTA</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon1' name='var_razon1' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon1");' onKeyPress='PresionTeclaEnVariable("var_razon1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon1",event);' ></span>
</td><td colspan=3><li id='var_razon1__1'><span onclick="PonerOpcion('var_razon1','1','pre_razon2_1')">1: Deshabilitada</span> <span class='texto_salto' id='var_razon1.1.salto'> &#8631; razon2_1</span>
</li>
<li id='var_razon1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon1','2','pre_razon2_2')">2: Demolida</span> <span class='texto_salto' id='var_razon1.2.salto'> &#8631; razon2_2</span>
</li>
<li id='var_razon1__3'><span onclick="PonerOpcion('var_razon1','3','pre_razon2_3')">3: Fin de Semana</span> <span class='texto_salto' id='var_razon1.3.salto'> &#8631; razon2_3</span>
</li>
<li id='var_razon1__4'><span onclick="PonerOpcion('var_razon1','4','pre_razon2_4')">4: Construcción</span> <span class='texto_salto' id='var_razon1.4.salto'> &#8631; razon2_4</span>
</li>
<li id='var_razon1__5'><span onclick="PonerOpcion('var_razon1','5','pre_razon2_5')">5: Vivienda usada como establecimiento</span> <span class='texto_salto' id='var_razon1.5.salto'> &#8631; razon2_5</span>
</li>
<li id='var_razon1__6'><span onclick="PonerOpcion('var_razon1','6','pre_razon2_6')">6: Variaciones en el listado</span> <span class='texto_salto' id='var_razon1.6.salto'> &#8631; razon2_6</span>
</li>
<li id='var_razon1__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon1','7','pre_razon2_7')">7: Ausencia</span> <span class='texto_salto' id='var_razon1.7.salto'> &#8631; razon2_7</span>
</li>
<li id='var_razon1__8' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon1','8','pre_razon2_8')">8: Rechazo</span> <span class='texto_salto' id='var_razon1.8.salto'> &#8631; razon2_8</span>
</li>
<li id='var_razon1__9'><span onclick="PonerOpcion('var_razon1','9','pre_razon2_9')">9: Otras causas</span> <span class='texto_salto' id='var_razon1.9.salto'> &#8631; razon2_9</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_1</span>
<span class='pre_texto' id='pre_razon2_1'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_1' name='var_razon2_1' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_1");' onKeyPress='PresionTeclaEnVariable("var_razon2_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_1",event);' ></span>
</td><td colspan=3><li id='var_razon2_1__1'><span onclick="PonerOpcion('var_razon2_1','1')">1: Venta o alquiler</span></li>
<li id='var_razon2_1__2'><span onclick="PonerOpcion('var_razon2_1','2')">2: Sucesión o remate</span></li>
<li id='var_razon2_1__3'><span onclick="PonerOpcion('var_razon2_1','3')">3: Construccion reciente</span></li>
<li id='var_razon2_1__4'><span onclick="PonerOpcion('var_razon2_1','4')">4: Sin causa conocida</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_2</span>
<span class='pre_texto' id='pre_razon2_2'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_2' name='var_razon2_2' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_2");' onKeyPress='PresionTeclaEnVariable("var_razon2_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_2",event);' ></span>
</td><td colspan=3><li id='var_razon2_2__1'><span onclick="PonerOpcion('var_razon2_2','1')">1: Fue demolida</span></li>
<li id='var_razon2_2__2'><span onclick="PonerOpcion('var_razon2_2','2')">2: En demolición</span></li>
<li id='var_razon2_2__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_2','3')">3: Levantada</span></li>
<li id='var_razon2_2__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_2','4')">4: Tapiada</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_3</span>
<span class='pre_texto' id='pre_razon2_3'> <span class='pre_aclaracion'>Viven en otra vivienda la mayor parte...</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_3' name='var_razon2_3' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_3");' onKeyPress='PresionTeclaEnVariable("var_razon2_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_3",event);' ></span>
</td><td colspan=3><li id='var_razon2_3__1'><span onclick="PonerOpcion('var_razon2_3','1')">1: de la semana</span></li>
<li id='var_razon2_3__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_3','2')">2: del mes</span></li>
<li id='var_razon2_3__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_3','3')">3: del año</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_4</span>
<span class='pre_texto' id='pre_razon2_4'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_4' name='var_razon2_4' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_4");' onKeyPress='PresionTeclaEnVariable("var_razon2_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_4",event);' ></span>
</td><td colspan=3><li id='var_razon2_4__1'><span onclick="PonerOpcion('var_razon2_4','1')">1: Se está construyendo</span></li>
<li id='var_razon2_4__2'><span onclick="PonerOpcion('var_razon2_4','2')">2: Construccion paralizada</span></li>
<li id='var_razon2_4__3'><span onclick="PonerOpcion('var_razon2_4','3')">3: Refacción</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_5</span>
<span class='pre_texto' id='pre_razon2_5'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_5' name='var_razon2_5' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_5");' onKeyPress='PresionTeclaEnVariable("var_razon2_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_5",event);' ></span>
</td><td colspan=3><li id='var_razon2_5__1'><span onclick="PonerOpcion('var_razon2_5','1')">1: Conserva comodidad de vivienda</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_6</span>
<span class='pre_texto' id='pre_razon2_6'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_6' name='var_razon2_6' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_6");' onKeyPress='PresionTeclaEnVariable("var_razon2_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_6",event);' ></span>
</td><td colspan=3><li id='var_razon2_6__1'><span onclick="PonerOpcion('var_razon2_6','1')">1: No existe lugar físico</span></li>
<li id='var_razon2_6__2'><span onclick="PonerOpcion('var_razon2_6','2')">2: No es vivienda</span></li>
<li id='var_razon2_6__3'><span onclick="PonerOpcion('var_razon2_6','3')">3: Existen otras viviendas</span></li>
<li id='var_razon2_6__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_6','4')">4: Otro</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_razon3' name='var_razon3' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_razon3");' onKeyPress='PresionTeclaEnVariable("var_razon3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon3",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_7</span>
<span class='pre_texto' id='pre_razon2_7'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_7' name='var_razon2_7' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_7");' onKeyPress='PresionTeclaEnVariable("var_razon2_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_7",event);' ></span>
</td><td colspan=3><li id='var_razon2_7__1'><span onclick="PonerOpcion('var_razon2_7','1')">1: No se pudo contactar en 3 visitas</span></li>
<li id='var_razon2_7__2'><span onclick="PonerOpcion('var_razon2_7','2')">2: Por causas circunstanciales</span></li>
<li id='var_razon2_7__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_razon2_7','3')">3: Viaje</span></li>
<li id='var_razon2_7__4'><span onclick="PonerOpcion('var_razon2_7','4')">4: Vacaciones</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_8</span>
<span class='pre_texto' id='pre_razon2_8'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_8' name='var_razon2_8' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_8");' onKeyPress='PresionTeclaEnVariable("var_razon2_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_8",event);' ></span>
</td><td colspan=3><li id='var_razon2_8__1'><span onclick="PonerOpcion('var_razon2_8','1')">1: Negativa rotunda</span></li>
<li id='var_razon2_8__2'><span onclick="PonerOpcion('var_razon2_8','2')">2: Rechazo por portero eléctrico</span></li>
<li id='var_razon2_8__3'><span onclick="PonerOpcion('var_razon2_8','3')">3: Se acordaron entrevistas que no se concretaron</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>razon2_9</span>
<span class='pre_texto' id='pre_razon2_9'></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_razon2_9' name='var_razon2_9' type='text'  class='input_opciones' onblur='ValidarOpcion("var_razon2_9");' onKeyPress='PresionTeclaEnVariable("var_razon2_9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_razon2_9",event);' ></span>
</td><td colspan=3><li id='var_razon2_9__1'><span onclick="PonerOpcion('var_razon2_9','1')">1: Inquilinato, pención, hotel, usurpado, conventillo</span></li>
<li id='var_razon2_9__2'><span onclick="PonerOpcion('var_razon2_9','2')">2: Duelo, alcoholismo, discapacidad, idioma extranjero</span></li>
<li id='var_razon2_9__3'><span onclick="PonerOpcion('var_razon2_9','3')">3: Problemas de seguridad</span></li>
<li id='var_razon2_9__4'><span onclick="PonerOpcion('var_razon2_9','4')">4: Inaccesible(Problemas climáticos u otros)</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>s1a1_obs</span>
<span class='pre_texto' id='pre_s1a1_obs'>Observaciones</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='observaciones'><input id='var_s1a1_obs' name='var_s1a1_obs' type='text'  class='input_observaciones' onblur='ValidarOpcion("var_s1a1_obs");' onKeyPress='PresionTeclaEnVariable("var_s1a1_obs",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s1a1_obs",event);' ></span>
</td><td colspan=3></td></tr>
</table>
	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"S1","matriz":null});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>