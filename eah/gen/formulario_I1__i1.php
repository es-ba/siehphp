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
<span class='pre_pre'>FILTRO_0</span>
<span class='pre_texto' id='pre_FILTRO_0'>CONFRONTE EDAD</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Menores de 14 años o P5=8<td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_0' name='var_filtro_0' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_0");' onKeyPress='PresionTeclaEnVariable("var_filtro_0",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_0",event);' ></span>
 <span class='texto_salto' id='var_filtro_0.salto'> &#8631; FILTRO_1</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Trayectoria de Nupcialidad - Uniones<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>U1</span>
<span class='pre_texto' id='pre_U1'>¿Cuántos matrimonios y/o relaciones de pareja estables ha tenido? <span class='pre_aclaracion'>Encuestador: Para los que estén en unión (legal o consensual) se incluye la actual</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_u1' name='var_u1' type='number'  class='input_numeros' onblur='ValidarOpcion("var_u1");' onKeyPress='PresionTeclaEnVariable("var_u1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_u1",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2>
Grilla Nupcialidad - Uniones		<table class="matriz_horizontal"><tr id='titulos_matriz_U' class='unica_fila_preguntas_matriz'>
<td>
<span class='hori_pre_pre'>U2</span>
<span class='hori_pre_texto' id='pre_U2'>Relación Nº</span>
<td>
<span class='hori_pre_pre'>U3_mes</span>
<span class='hori_pre_texto' id='pre_U3_mes'>Mes Inicio</span>
<td>
<span class='hori_pre_pre'>U3_anio</span>
<span class='hori_pre_texto' id='pre_U3_anio'>Año Inicio</span>
<td>
<span class='hori_pre_pre'>U4_mes</span>
<span class='hori_pre_texto' id='pre_U4_mes'>Mes Finalización</span>
<td>
<span class='hori_pre_pre'>U4_anio</span>
<span class='hori_pre_texto' id='pre_U4_anio'>Año Finalización</span>
<td>
<span class='hori_pre_pre'>U5</span>
<span class='hori_pre_texto' id='pre_U5'>Motivo por el que finalizó la relación</span>
<td>
<span class='hori_pre_pre'>U6</span>
<span class='hori_pre_texto' id='pre_U6'>Tipo de unión</span>
<tr id='fila_matriz_U' class='fila_matriz'><td id='var_relacion'><td id='var_u3_mes'><td id='var_u3_anio'><td id='var_u4_mes'><td id='var_u4_anio'><td id='var_u5'><td id='var_u6'>	</table><tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Trabajo - Para todas las personas de 10 años o más<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_1</span>
<span class='pre_texto' id='pre_FILTRO_1'>CONFRONTE EDAD</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>9 años o menos<td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_1' name='var_filtro_1' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_1");' onKeyPress='PresionTeclaEnVariable("var_filtro_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_1",event);' ></span>
 <span class='texto_salto' id='var_filtro_1.salto'> &#8631; FILTRO_2</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T1</span>
<span class='pre_texto' id='pre_T1'>¿La semana pasada trabajó _________ por lo menos una hora?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_t1' name='var_t1' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t1");' onKeyPress='PresionTeclaEnVariable("var_t1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t1",event);' ></span>
</td><td colspan=3><li id='var_t1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t1','1','pre_T7')">1: Sí</span> <span class='texto_salto' id='var_t1.1.salto'> &#8631; T7</span>
</li>
<li id='var_t1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t1','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T2</span>
<span class='pre_texto' id='pre_T2'>En esta semana ¿Hizo alguna changa, fabricó en su casa al para vender, ayudó a un familiar o amigo en su negocio?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_t2' name='var_t2' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t2");' onKeyPress='PresionTeclaEnVariable("var_t2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t2",event);' ></span>
</td><td colspan=3><li id='var_t2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t2','1','pre_T7')">1: Sí</span> <span class='texto_salto' id='var_t2.1.salto'> &#8631; T7</span>
</li>
<li id='var_t2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t2','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T3</span>
<span class='pre_texto' id='pre_T3'>¿La semana pasada... <span class='pre_aclaracion'>G-S, Primero lea todas las opciones y luego marque la respuesta</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t3' name='var_t3' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t3");' onKeyPress='PresionTeclaEnVariable("var_t3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t3",event);' ></span>
</td><td colspan=3><li id='var_t3__1'><span onclick="PonerOpcion('var_t3','1','pre_T13')">1: no deseaba, no quería trabajar?</span> <span class='texto_salto' id='var_t3.1.salto'> &#8631; T13</span>
</li>
<li id='var_t3__2'><span onclick="PonerOpcion('var_t3','2','pre_T9')">2: no podía trabajar por razones especiales?</span> <span class='opc_aclaracion'>estudio, cuidado hogar, etc.</span> <span class='texto_salto' id='var_t3.2.salto'> &#8631; T9</span>
</li>
<li id='var_t3__3'><span onclick="PonerOpcion('var_t3','3','pre_T9')">3: no tuvo pedidos/ clientes?</span> <span class='texto_salto' id='var_t3.3.salto'> &#8631; T9</span>
</li>
<li id='var_t3__4'><span onclick="PonerOpcion('var_t3','4','pre_T9')">4: no tenía trabajo y quería trabajar?</span> <span class='texto_salto' id='var_t3.4.salto'> &#8631; T9</span>
</li>
<li id='var_t3__5'><span onclick="PonerOpcion('var_t3','5','pre_T4')">5: tenía un trabajo/ negocio al que no concurrió?</span> <span class='texto_salto' id='var_t3.5.salto'> &#8631; T4</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T4</span>
<span class='pre_texto' id='pre_T4'>¿No concurrió a su trabajo por... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t4' name='var_t4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t4");' onKeyPress='PresionTeclaEnVariable("var_t4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t4",event);' ></span>
</td><td colspan=3><li id='var_t4__1'><span onclick="PonerOpcion('var_t4','1','pre_T28')">1: licencia, vacaciones o enfermedad?</span> <span class='texto_salto' id='var_t4.1.salto'> &#8631; T28</span>
</li>
<li id='var_t4__2'><span onclick="PonerOpcion('var_t4','2','pre_T28')">2: otras causas personales?</span> <span class='opc_aclaracion'>viajes, trámites, etc.</span> <span class='texto_salto' id='var_t4.2.salto'> &#8631; T28</span>
</li>
<li id='var_t4__3'><span onclick="PonerOpcion('var_t4','3','pre_T28')">3: huelga o conflicto laboral?</span> <span class='texto_salto' id='var_t4.3.salto'> &#8631; T28</span>
</li>
<li id='var_t4__4'><span onclick="PonerOpcion('var_t4','4','pre_T5')">4: suspensión de su trabajo en relación de dependencia?</span> <span class='texto_salto' id='var_t4.4.salto'> &#8631; T5</span>
</li>
<li id='var_t4__5'><span onclick="PonerOpcion('var_t4','5','pre_T6')">5: otras causas laborales</span> <span class='opc_aclaracion'>rotura de equipo, falta de materias primas, mal tiempo, etc.</span> <span class='texto_salto' id='var_t4.5.salto'> &#8631; T6</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T5</span>
<span class='pre_texto' id='pre_T5'>¿Le siguen pagando durante la suspensión? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no_nosabe3'><input id='var_t5' name='var_t5' type='text'  class='input_si_no_nosabe3' onblur='ValidarOpcion("var_t5");' onKeyPress='PresionTeclaEnVariable("var_t5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t5",event);' ></span>
</td><td colspan=3><li id='var_t5__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t5','1','pre_T28')">1: Sí</span> <span class='texto_salto' id='var_t5.1.salto'> &#8631; T28</span>
</li>
<li id='var_t5__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t5','2','pre_T9')">2: No</span> <span class='texto_salto' id='var_t5.2.salto'> &#8631; T9</span>
</li>
<li id='var_t5__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t5','3','pre_T9')">3: No sabe</span> <span class='texto_salto' id='var_t5.3.salto'> &#8631; T9</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T6</span>
<span class='pre_texto' id='pre_T6'>¿Volverá a ese trabajo a lo sumo en un mes? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no_nosabe3'><input id='var_t6' name='var_t6' type='text'  class='input_si_no_nosabe3' onblur='ValidarOpcion("var_t6");' onKeyPress='PresionTeclaEnVariable("var_t6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t6",event);' ></span>
</td><td colspan=3><li id='var_t6__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t6','1','pre_T28')">1: Sí</span> <span class='texto_salto' id='var_t6.1.salto'> &#8631; T28</span>
</li>
<li id='var_t6__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t6','2','pre_T9')">2: No</span> <span class='texto_salto' id='var_t6.2.salto'> &#8631; T9</span>
</li>
<li id='var_t6__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t6','3','pre_T9')">3: No sabe</span> <span class='texto_salto' id='var_t6.3.salto'> &#8631; T9</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T7</span>
<span class='pre_texto' id='pre_T7'>¿Recibe u obtiene algún pago por su trabajo? <span class='pre_aclaracion'>En dinero o en especie</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_t7' name='var_t7' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t7");' onKeyPress='PresionTeclaEnVariable("var_t7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t7",event);' ></span>
</td><td colspan=3><li id='var_t7__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t7','1','pre_T30')">1: Sí</span> <span class='texto_salto' id='var_t7.1.salto'> &#8631; T30</span>
</li>
<li id='var_t7__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t7','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T8</span>
<span class='pre_texto' id='pre_T8'>¿Trabajó... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t8' name='var_t8' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t8");' onKeyPress='PresionTeclaEnVariable("var_t8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t8",event);' ></span>
</td><td colspan=3><li id='var_t8__1'><span onclick="PonerOpcion('var_t8','1','pre_T30')">1: en el negocio, taller o actividad de un familiar, pariente o amigo?</span> <span class='texto_salto' id='var_t8.1.salto'> &#8631; T30</span>
</li>
<li id='var_t8__2'><span onclick="PonerOpcion('var_t8','2','pre_T30')">2: como trabajador ad-honorem?</span> <span class='opc_aclaracion'>aprendiz, meritorio, judicial, etc.</span> <span class='texto_salto' id='var_t8.2.salto'> &#8631; T30</span>
</li>
<li id='var_t8__3'><span onclick="PonerOpcion('var_t8','3')">3: de alguna otra forma?</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t8_otro' name='var_t8_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t8_otro");' onKeyPress='PresionTeclaEnVariable("var_t8_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t8_otro",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T9</span>
<span class='pre_texto' id='pre_T9'>Durante los últimos 30 días, ¿Estuvo buscando trabajo de alguna manera?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t9' name='var_t9' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t9");' onKeyPress='PresionTeclaEnVariable("var_t9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t9",event);' ></span>
</td><td colspan=3><li id='var_t9__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t9','1','pre_T12')">1: Sí</span> <span class='texto_salto' id='var_t9.1.salto'> &#8631; T12</span>
</li>
<li id='var_t9__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t9','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T10</span>
<span class='pre_texto' id='pre_T10'>Durante esos 30 días ¿Hizo algo para instalarse por su cuenta/puso carteles/consultó parientes, amigos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t10' name='var_t10' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t10");' onKeyPress='PresionTeclaEnVariable("var_t10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t10",event);' ></span>
</td><td colspan=3><li id='var_t10__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t10','1','pre_T12')">1: Sí</span> <span class='texto_salto' id='var_t10.1.salto'> &#8631; T12</span>
</li>
<li id='var_t10__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t10','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T11</span>
<span class='pre_texto' id='pre_T11'>No buscó trabajo (ni hizo algo para trabajar) porque... <span class='pre_aclaracion'>G-S, primero lea todas las opciones y luego marque la respuesta</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t11' name='var_t11' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t11");' onKeyPress='PresionTeclaEnVariable("var_t11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t11",event);' ></span>
</td><td colspan=3><li id='var_t11__1'><span onclick="PonerOpcion('var_t11','1','pre_T12')">1: tenía un trabajo asegurado?</span> <span class='texto_salto' id='var_t11.1.salto'> &#8631; T12</span>
</li>
<li id='var_t11__2'><span onclick="PonerOpcion('var_t11','2','pre_T12')">2: está suspendido y espera ser llamado?</span> <span class='texto_salto' id='var_t11.2.salto'> &#8631; T12</span>
</li>
<li id='var_t11__3'><span onclick="PonerOpcion('var_t11','3','pre_T13')">3: se cansó de buscar trabajo?</span> <span class='texto_salto' id='var_t11.3.salto'> &#8631; T13</span>
</li>
<li id='var_t11__4'><span onclick="PonerOpcion('var_t11','4')">4: por otras razones?</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t11_otro' name='var_t11_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t11_otro");' onKeyPress='PresionTeclaEnVariable("var_t11_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t11_otro",event);' ></span>
 <span class='texto_salto' id='var_t11_otro.salto'> &#8631; T13</span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T12</span>
<span class='pre_texto' id='pre_T12'>Si la semana pasada conseguía trabajo, ¿podía empezar a trabajar en ese momento? <span class='pre_aclaracion'>O a más tardar en dos semanas</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t12' name='var_t12' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t12");' onKeyPress='PresionTeclaEnVariable("var_t12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t12",event);' ></span>
</td><td colspan=3><li id='var_t12__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t12','1','pre_T15')">1: Sí</span> <span class='texto_salto' id='var_t12.1.salto'> &#8631; T15</span>
</li>
<li id='var_t12__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t12','2','pre_T13')">2: No</span> <span class='texto_salto' id='var_t12.2.salto'> &#8631; T13</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T13</span>
<span class='pre_texto' id='pre_T13'>En los últimos 12 meses ¿buscó trabajo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t13' name='var_t13' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t13");' onKeyPress='PresionTeclaEnVariable("var_t13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t13",event);' ></span>
</td><td colspan=3><li id='var_t13__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t13','1')">1: Sí</span></li>
<li id='var_t13__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t13','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T14</span>
<span class='pre_texto' id='pre_T14'>En los últimos 12 meses ¿tuvo alguna ocupación con pago?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t14' name='var_t14' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t14");' onKeyPress='PresionTeclaEnVariable("var_t14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t14",event);' ></span>
</td><td colspan=3><li id='var_t14__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t14','1','pre_T27')">1: Sí</span> <span class='texto_salto' id='var_t14.1.salto'> &#8631; T27</span>
</li>
<li id='var_t14__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t14','2','pre_I1')">2: No</span> <span class='texto_salto' id='var_t14.2.salto'> &#8631; I1</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para desocupados<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T15</span>
<span class='pre_texto' id='pre_T15'>¿Cuánto hace que está buscando trabajo? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t15' name='var_t15' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t15");' onKeyPress='PresionTeclaEnVariable("var_t15",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t15",event);' ></span>
</td><td colspan=3><li id='var_t15__1'><span onclick="PonerOpcion('var_t15','1')">1: Menos de 1 mes</span></li>
<li id='var_t15__2'><span onclick="PonerOpcion('var_t15','2')">2: De 1 a 3 meses</span></li>
<li id='var_t15__3'><span onclick="PonerOpcion('var_t15','3')">3: Más de 3 a 6 meses</span></li>
<li id='var_t15__4'><span onclick="PonerOpcion('var_t15','4')">4: Más de 6 a 12 meses</span></li>
<li id='var_t15__5'><span onclick="PonerOpcion('var_t15','5')">5: Más de 1 año</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T16</span>
<span class='pre_texto' id='pre_T16'>¿Durante ese tiempo hizo algún trabajo/ changa?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t16' name='var_t16' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t16");' onKeyPress='PresionTeclaEnVariable("var_t16",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t16",event);' ></span>
</td><td colspan=3><li id='var_t16__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t16','1','pre_T17')">1: Sí</span> <span class='texto_salto' id='var_t16.1.salto'> &#8631; T17</span>
</li>
<li id='var_t16__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t16','2','pre_T18')">2: No</span> <span class='texto_salto' id='var_t16.2.salto'> &#8631; T18</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T17</span>
<span class='pre_texto' id='pre_T17'>¿Cuánto tiempo hace que terminó su último trabajo/ changa? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t17' name='var_t17' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t17");' onKeyPress='PresionTeclaEnVariable("var_t17",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t17",event);' ></span>
 <span class='texto_salto' id='var_t17.salto'> &#8631; T20</span>
</td><td colspan=3><li id='var_t17__1'><span onclick="PonerOpcion('var_t17','1')">1: Menos de 1 mes</span></li>
<li id='var_t17__2'><span onclick="PonerOpcion('var_t17','2')">2: De 1 a 3 meses</span></li>
<li id='var_t17__3'><span onclick="PonerOpcion('var_t17','3')">3: Más de 3 a 6 meses</span></li>
<li id='var_t17__4'><span onclick="PonerOpcion('var_t17','4')">4: Más de 6 a 12 meses</span></li>
<li id='var_t17__5'><span onclick="PonerOpcion('var_t17','5')">5: Más de 1 año</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T18</span>
<span class='pre_texto' id='pre_T18'>¿Ha trabajado alguna vez?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t18' name='var_t18' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t18");' onKeyPress='PresionTeclaEnVariable("var_t18",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t18",event);' ></span>
</td><td colspan=3><li id='var_t18__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t18','1','pre_T19')">1: Sí</span> <span class='texto_salto' id='var_t18.1.salto'> &#8631; T19</span>
</li>
<li id='var_t18__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t18','2','pre_I1')">2: No</span> <span class='texto_salto' id='var_t18.2.salto'> &#8631; I1</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T19</span>
<span class='pre_texto' id='pre_T19'>¿En qué año dejó de trabajar en su última ocupación, changa, empleo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Año en que dejó de trabajar<td colspan=1><span class='respuesta'  title='anio'><input id='var_t19_anio' name='var_t19_anio' type='number'  class='input_anio' onblur='ValidarOpcion("var_t19_anio");' onKeyPress='PresionTeclaEnVariable("var_t19_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t19_anio",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T20</span>
<span class='pre_texto' id='pre_T20'>¿Ese trabajo _________ lo hacía... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t20' name='var_t20' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t20");' onKeyPress='PresionTeclaEnVariable("var_t20",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t20",event);' ></span>
</td><td colspan=3><li id='var_t20__1'><span onclick="PonerOpcion('var_t20','1','pre_T22')">1: para su propio negocio/ empresa/ actividad?</span> <span class='texto_salto' id='var_t20.1.salto'> &#8631; T22</span>
</li>
<li id='var_t20__2'><span onclick="PonerOpcion('var_t20','2','pre_T21')">2: para el negocio/ empresa/ actividad de un familiar?</span> <span class='texto_salto' id='var_t20.2.salto'> &#8631; T21</span>
</li>
<li id='var_t20__3'><span onclick="PonerOpcion('var_t20','3','pre_T23')">3: o para un patrón/ empresa/ institución?</span> <span class='texto_salto' id='var_t20.3.salto'> &#8631; T23</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T21</span>
<span class='pre_texto' id='pre_T21'>¿Por ese trabajo... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t21' name='var_t21' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t21");' onKeyPress='PresionTeclaEnVariable("var_t21",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t21",event);' ></span>
</td><td colspan=3><li id='var_t21__1'><span onclick="PonerOpcion('var_t21','1','pre_T23')">1: le pagaban sueldo?</span> <span class='opc_aclaracion'>en dinero/ especie</span> <span class='texto_salto' id='var_t21.1.salto'> &#8631; T23</span>
</li>
<li id='var_t21__2'><span onclick="PonerOpcion('var_t21','2','pre_T22')">2: retiraba dinero?</span> <span class='texto_salto' id='var_t21.2.salto'> &#8631; T22</span>
</li>
<li id='var_t21__3'><span onclick="PonerOpcion('var_t21','3','pre_T23')">3: no le pagaban ni retiraba dinero?</span> <span class='texto_salto' id='var_t21.3.salto'> &#8631; T23</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T22</span>
<span class='pre_texto' id='pre_T22'>¿En ese negocio/ empresa/ actividad, se empleaban personas asalariadas? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t22' name='var_t22' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t22");' onKeyPress='PresionTeclaEnVariable("var_t22",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t22",event);' ></span>
</td><td colspan=3><li id='var_t22__1'><span onclick="PonerOpcion('var_t22','1')">1: Sí, siempre</span></li>
<li id='var_t22__2'><span onclick="PonerOpcion('var_t22','2')">2: Sólo a veces o por temporadas</span></li>
<li id='var_t22__3'><span onclick="PonerOpcion('var_t22','3')">3: No empleaban ni contrataban personal</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T23</span>
<span class='pre_texto' id='pre_T23'>¿A qué se dedicaba o qué producía el negocio/ empresa/ institución en la que trabajaba? <span class='pre_aclaracion'>Regístrese el producto principal que producía o los servicios que prestaba el establecimiento en el que trabaja. Para los trabajadores por cuenta propia, el establecimiento es la misma actividad que realizaban</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t23' name='var_t23' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t23");' onKeyPress='PresionTeclaEnVariable("var_t23",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t23",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T24</span>
<span class='pre_texto' id='pre_T24'>¿Cuál era el nombre de su ocupación?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t24' name='var_t24' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t24");' onKeyPress='PresionTeclaEnVariable("var_t24",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t24",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T25</span>
<span class='pre_texto' id='pre_T25'>¿Qué tareas realizaba en ella?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t25' name='var_t25' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t25");' onKeyPress='PresionTeclaEnVariable("var_t25",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t25",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T26</span>
<span class='pre_texto' id='pre_T26'>¿Qué herramientas, maquinas o equipos usaba?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t26' name='var_t26' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t26");' onKeyPress='PresionTeclaEnVariable("var_t26",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t26",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para desocupados e inactivos<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T27</span>
<span class='pre_texto' id='pre_T27'>¿Cobra actualmente el seguro de desempleo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t27' name='var_t27' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t27");' onKeyPress='PresionTeclaEnVariable("var_t27",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t27",event);' ></span>
 <span class='texto_salto' id='var_t27.salto'> &#8631; I1</span>
</td><td colspan=3><li id='var_t27__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t27','1')">1: Sí</span></li>
<li id='var_t27__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t27','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para Ocupados que no trabajaron en la semana de referencia<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T28</span>
<span class='pre_texto' id='pre_T28'>¿Cuántos empleos/ ocupaciones tiene? <span class='pre_aclaracion'>En el caso de tener más de un empleo verifique que no haya trabajado en ninguno durante la semana pasada</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_t28' name='var_t28' type='number'  class='input_numeros' onblur='ValidarOpcion("var_t28");' onKeyPress='PresionTeclaEnVariable("var_t28",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t28",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T29</span>
<span class='pre_texto' id='pre_T29'>¿Cuántas horas semanales trabaja habitualmente en todos sus empleos/ ocupaciones?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t29' name='var_t29' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t29");' onKeyPress='PresionTeclaEnVariable("var_t29",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t29",event);' ></span>
</td><td colspan=3><li id='var_t29__1'><span onclick="PonerOpcion('var_t29','1')">1: Menos de 35 horas semanales</span></li>
<li id='var_t29__2'><span onclick="PonerOpcion('var_t29','2')">2: Entre 35 y 45 horas semanales</span></li>
<li id='var_t29__3'><span onclick="PonerOpcion('var_t29','3')">3: Más de 45 horas semanales</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T29a</span>
<span class='pre_texto' id='pre_T29a'>¿Quiere trabajar más horas?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t29a' name='var_t29a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t29a");' onKeyPress='PresionTeclaEnVariable("var_t29a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t29a",event);' ></span>
 <span class='texto_salto' id='var_t29a.salto'> &#8631; T35</span>
</td><td colspan=3><li id='var_t29a__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t29a','1')">1: Sí</span></li>
<li id='var_t29a__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t29a','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para Ocupados que trabajaron en la semana de referencia<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T30</span>
<span class='pre_texto' id='pre_T30'>¿Cuántos empleos/ ocupaciones tuvo la semana pasada?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t30' name='var_t30' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t30");' onKeyPress='PresionTeclaEnVariable("var_t30",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t30",event);' ></span>
</td><td colspan=3><li id='var_t30__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t30','1')">1: Sólo una</span></li>
<li id='var_t30__2'><span onclick="PonerOpcion('var_t30','2')">2: Más de una</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T31</span>
<span class='pre_texto' id='pre_T31'>¿En su ocupación cuántas horas trabajó... <span class='pre_aclaracion'>Si es más de una la que le lleva más horas) 
(Códigos para los que no trabajaron algún día de la semana:
30: Enfermedad
31: Otra licencia con goce de sueldo
32: Falta de trabajo o suspención
33: Feriados
00: En otras no incluidas en las anteriores (francos, nunca trabaja esos días)</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>el domingo?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_d' name='var_t31_d' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_d");' onKeyPress='PresionTeclaEnVariable("var_t31_d",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_d",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el lunes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_l' name='var_t31_l' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_l");' onKeyPress='PresionTeclaEnVariable("var_t31_l",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_l",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el martes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_ma' name='var_t31_ma' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_ma");' onKeyPress='PresionTeclaEnVariable("var_t31_ma",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_ma",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el miércoles?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_mi' name='var_t31_mi' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_mi");' onKeyPress='PresionTeclaEnVariable("var_t31_mi",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_mi",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el jueves?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_j' name='var_t31_j' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_j");' onKeyPress='PresionTeclaEnVariable("var_t31_j",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_j",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el viernes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_v' name='var_t31_v' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_v");' onKeyPress='PresionTeclaEnVariable("var_t31_v",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_v",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el sábado?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t31_s' name='var_t31_s' type='number'  class='input_horas' onblur='ValidarOpcion("var_t31_s");' onKeyPress='PresionTeclaEnVariable("var_t31_s",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t31_s",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T32</span>
<span class='pre_texto' id='pre_T32'>En su/s otra/s ocupación/es ¿Cuántas horas trabajó…</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>el domingo?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_d' name='var_t32_d' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_d");' onKeyPress='PresionTeclaEnVariable("var_t32_d",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_d",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el lunes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_l' name='var_t32_l' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_l");' onKeyPress='PresionTeclaEnVariable("var_t32_l",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_l",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el martes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_ma' name='var_t32_ma' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_ma");' onKeyPress='PresionTeclaEnVariable("var_t32_ma",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_ma",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el miércoles?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_mi' name='var_t32_mi' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_mi");' onKeyPress='PresionTeclaEnVariable("var_t32_mi",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_mi",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el jueves?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_j' name='var_t32_j' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_j");' onKeyPress='PresionTeclaEnVariable("var_t32_j",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_j",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el viernes?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_v' name='var_t32_v' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_v");' onKeyPress='PresionTeclaEnVariable("var_t32_v",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_v",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>el sábado?<td colspan=1><span class='respuesta'  title='horas'><input id='var_t32_s' name='var_t32_s' type='number'  class='input_horas' onblur='ValidarOpcion("var_t32_s");' onKeyPress='PresionTeclaEnVariable("var_t32_s",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t32_s",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T33</span>
<span class='pre_texto' id='pre_T33'>La semana pasada ¿Quería trabajar más horas?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t33' name='var_t33' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t33");' onKeyPress='PresionTeclaEnVariable("var_t33",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t33",event);' ></span>
</td><td colspan=3><li id='var_t33__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t33','1','pre_T34')">1: Sí</span> <span class='texto_salto' id='var_t33.1.salto'> &#8631; T34</span>
</li>
<li id='var_t33__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t33','2','pre_T35')">2: No</span> <span class='texto_salto' id='var_t33.2.salto'> &#8631; T35</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T34</span>
<span class='pre_texto' id='pre_T34'>Si hubiera conseguido más horas ¿Podría trabajarlas esa semana? <span class='pre_aclaracion'>A más tardar en dos semanas</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t34' name='var_t34' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t34");' onKeyPress='PresionTeclaEnVariable("var_t34",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t34",event);' ></span>
</td><td colspan=3><li id='var_t34__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t34','1')">1: Sí</span></li>
<li id='var_t34__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t34','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para todos los ocupados<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T35</span>
<span class='pre_texto' id='pre_T35'>En los últimos 30 días ¿busco otra ocupación? <span class='pre_aclaracion'>Encuestador: debe buscar activamente otra ocupación</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t35' name='var_t35' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t35");' onKeyPress='PresionTeclaEnVariable("var_t35",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t35",event);' ></span>
</td><td colspan=3><li id='var_t35__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t35','1','pre_T36')">1: Sí</span> <span class='texto_salto' id='var_t35.1.salto'> &#8631; T36</span>
</li>
<li id='var_t35__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t35','2','pre_T37')">2: No</span> <span class='texto_salto' id='var_t35.2.salto'> &#8631; T37</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T36</span>
<span class='pre_texto' id='pre_T36'>¿Cuál es la razón por la que buscó otra ocupación o trabajo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_1' name='var_t36_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_1");' onKeyPress='PresionTeclaEnVariable("var_t36_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_1",event);' ></span>
</td><td colspan=3><li id='var_t36_1__1'><span onclick="PonerOpcion('var_t36_1','1')">1: Porque gana poco, se atrasan en el pago</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_2' name='var_t36_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_2");' onKeyPress='PresionTeclaEnVariable("var_t36_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_2",event);' ></span>
</td><td colspan=3><li id='var_t36_2__2'><span onclick="PonerOpcion('var_t36_2','2')">2: Porque está insatisfecho con su tarea</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_3' name='var_t36_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_3");' onKeyPress='PresionTeclaEnVariable("var_t36_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_3",event);' ></span>
</td><td colspan=3><li id='var_t36_3__3'><span onclick="PonerOpcion('var_t36_3','3')">3: Porque la relación con su empleador es mala</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_4' name='var_t36_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_4");' onKeyPress='PresionTeclaEnVariable("var_t36_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_4",event);' ></span>
</td><td colspan=3><li id='var_t36_4__4'><span onclick="PonerOpcion('var_t36_4','4')">4: Porque cree que lo van a despedir</span> <span class='opc_aclaracion'>asalariados</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_5' name='var_t36_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_5");' onKeyPress='PresionTeclaEnVariable("var_t36_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_5",event);' ></span>
</td><td colspan=3><li id='var_t36_5__5'><span onclick="PonerOpcion('var_t36_5','5')">5: Porque el trabajo que tiene se va a acabar</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_6' name='var_t36_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_6");' onKeyPress='PresionTeclaEnVariable("var_t36_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_6",event);' ></span>
</td><td colspan=3><li id='var_t36_6__6'><span onclick="PonerOpcion('var_t36_6','6')">6: Porque tiene poco trabajo</span> <span class='opc_aclaracion'>no asalariados</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_7' name='var_t36_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_7");' onKeyPress='PresionTeclaEnVariable("var_t36_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_7",event);' ></span>
</td><td colspan=3><li id='var_t36_7__7'><span onclick="PonerOpcion('var_t36_7','7')">7: Por otras causas laborales</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t36_7_otro' name='var_t36_7_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t36_7_otro");' onKeyPress='PresionTeclaEnVariable("var_t36_7_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_7_otro",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_t36_8' name='var_t36_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_t36_8");' onKeyPress='PresionTeclaEnVariable("var_t36_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_8",event);' ></span>
</td><td colspan=3><li id='var_t36_8__8'><span onclick="PonerOpcion('var_t36_8','8')">8: Por causas personales</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t36_8_otro' name='var_t36_8_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t36_8_otro");' onKeyPress='PresionTeclaEnVariable("var_t36_8_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_8_otro",event);' ></span>
</td><td colspan=0></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T36_a</span>
<span class='pre_texto' id='pre_T36_a'>¿Cual es la mas importante?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t36_a' name='var_t36_a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t36_a");' onKeyPress='PresionTeclaEnVariable("var_t36_a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t36_a",event);' ></span>
</td><td colspan=3><li id='var_t36_a__1'><span onclick="PonerOpcion('var_t36_a','1')">1: Porque gana poco, se atrasan en el pago</span></li>
<li id='var_t36_a__2'><span onclick="PonerOpcion('var_t36_a','2')">2: Porque está insatisfecho con su tarea</span></li>
<li id='var_t36_a__3'><span onclick="PonerOpcion('var_t36_a','3')">3: Porque la relación con su empleador es mala</span></li>
<li id='var_t36_a__4'><span onclick="PonerOpcion('var_t36_a','4')">4: Porque cree que lo van a despedir</span> <span class='opc_aclaracion'>asalariados</span></li>
<li id='var_t36_a__5'><span onclick="PonerOpcion('var_t36_a','5')">5: Porque el trabajo que tiene se va a acabar</span></li>
<li id='var_t36_a__6'><span onclick="PonerOpcion('var_t36_a','6')">6: Porque tiene poco trabajo</span> <span class='opc_aclaracion'>no asalariados</span></li>
<li id='var_t36_a__7'><span onclick="PonerOpcion('var_t36_a','7')">7: Por otras causas laborales</span> <span class='opc_aclaracion'>especificar</span></li>
<li id='var_t36_a__8'><span onclick="PonerOpcion('var_t36_a','8')">8: Por causas personales</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Hablemos ahora de su unica ocupación o de la que le lleva mas horas<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T37</span>
<span class='pre_texto' id='pre_T37'>¿A qué se dedica o qué produce el negocio, empresa o institución en la que trabaja? <span class='pre_aclaracion'>Registre el producto principal que produce o los servicios que presta el establecimiento en el que trabaja. Para los trabajadores por cuenta propia, el establecimiento es la misma actividad que realizan</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t37' name='var_t37' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t37");' onKeyPress='PresionTeclaEnVariable("var_t37",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t37",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T37sd</span>
<span class='pre_texto' id='pre_T37sd'>Si presta servicio doméstico en hogares particulares marque</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t37sd' name='var_t37sd' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t37sd");' onKeyPress='PresionTeclaEnVariable("var_t37sd",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t37sd",event);' ></span>
</td><td colspan=3><li id='var_t37sd__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t37sd','1','pre_T49')">1: marcar</span> <span class='texto_salto' id='var_t37sd.1.salto'> &#8631; T49</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T38</span>
<span class='pre_texto' id='pre_T38'>¿Ese negocio/ empresa/ institución es... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t38' name='var_t38' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t38");' onKeyPress='PresionTeclaEnVariable("var_t38",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t38",event);' ></span>
</td><td colspan=3><li id='var_t38__1'><span onclick="PonerOpcion('var_t38','1')">1: estatal/ pública?</span></li>
<li id='var_t38__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t38','2')">2: privada?</span></li>
<li id='var_t38__3'><span onclick="PonerOpcion('var_t38','3')">3: de otro tipo?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T39</span>
<span class='pre_texto' id='pre_T39'>¿Dónde está ubicado ese negocio/ empresa/ institución? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t39' name='var_t39' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t39");' onKeyPress='PresionTeclaEnVariable("var_t39",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39",event);' ></span>
</td><td colspan=3><li id='var_t39__1'><span onclick="PonerOpcion('var_t39','1','pre_T39_bis')">1: En su domicilio</span> <span class='texto_salto' id='var_t39.1.salto'> &#8631; T39_bis</span>
</li>
<li id='var_t39__2'><span onclick="PonerOpcion('var_t39','2')">2: En otro lugar de la ciudad A. de Bs. As</span> <span class='opc_aclaracion'>Barrio/calles</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t39_barrio' name='var_t39_barrio' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t39_barrio");' onKeyPress='PresionTeclaEnVariable("var_t39_barrio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_barrio",event);' ></span>
 <span class='texto_salto' id='var_t39_barrio.salto'> &#8631; T39_bis2</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_t39__3'><span onclick="PonerOpcion('var_t39','3','pre_T39_bis2')">3: Partidos del Gran Bs. As</span> <span class='texto_salto' id='var_t39.3.salto'> &#8631; T39_bis2</span>
</li>
<li id='var_t39__4'><span onclick="PonerOpcion('var_t39','4')">4: Otro lugar</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t39_otro' name='var_t39_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t39_otro");' onKeyPress='PresionTeclaEnVariable("var_t39_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_otro",event);' ></span>
 <span class='texto_salto' id='var_t39_otro.salto'> &#8631; T39_bis2</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_t39__5'><span onclick="PonerOpcion('var_t39','5','pre_T39_bis2')">5: No tiene un lugar fijo de trabajo</span> <span class='texto_salto' id='var_t39.5.salto'> &#8631; T39_bis2</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T39_bis</span>
<span class='pre_texto' id='pre_T39_bis'>¿Trabaja con alguna/s persona/s que vive/n en este hogar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_t39_bis' name='var_t39_bis' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t39_bis");' onKeyPress='PresionTeclaEnVariable("var_t39_bis",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_bis",event);' ></span>
</td><td colspan=3><li id='var_t39_bis__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t39_bis','1')">1: Sí</span> <span class='opc_aclaracion'>¿Cuantos?</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>¿Cuantos?<td colspan=2><span class='respuesta'  title='numeros'><input id='var_t39_bis_cuantos' name='var_t39_bis_cuantos' type='number'  class='input_numeros' onblur='ValidarOpcion("var_t39_bis_cuantos");' onKeyPress='PresionTeclaEnVariable("var_t39_bis_cuantos",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_bis_cuantos",event);' ></span>
 <span class='texto_salto' id='var_t39_bis_cuantos.salto'> &#8631; T40</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_t39_bis__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t39_bis','2','pre_T40')">2: No</span> <span class='texto_salto' id='var_t39_bis.2.salto'> &#8631; T40</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T39_bis2</span>
<span class='pre_texto' id='pre_T39_bis2'>Dónde realiza principalmente sus tareas? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t39_bis2' name='var_t39_bis2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t39_bis2");' onKeyPress='PresionTeclaEnVariable("var_t39_bis2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_bis2",event);' ></span>
</td><td colspan=3><li id='var_t39_bis2__1'><span onclick="PonerOpcion('var_t39_bis2','1')">1: En un local, establecimiento, negocio, taller</span></li>
<li id='var_t39_bis2__2'><span onclick="PonerOpcion('var_t39_bis2','2')">2: En un puesto fijo o negocio callejero</span></li>
<li id='var_t39_bis2__3'><span onclick="PonerOpcion('var_t39_bis2','3')">3: En vehículos</span> <span class='opc_aclaracion'>no incluye servicio de transporte</span></li>
<li id='var_t39_bis2__4'><span onclick="PonerOpcion('var_t39_bis2','4')">4: En vehículos para transporte de mercancias</span></li>
<li id='var_t39_bis2__5'><span onclick="PonerOpcion('var_t39_bis2','5')">5: En obras de construcción de infraestructura</span></li>
<li id='var_t39_bis2__6'><span onclick="PonerOpcion('var_t39_bis2','6')">6: En la vivienda del socio o patrón</span></li>
<li id='var_t39_bis2__7'><span onclick="PonerOpcion('var_t39_bis2','7')">7: En la calle, espacios públicos, ambulante, puesto móvil callejero</span></li>
<li id='var_t39_bis2__8'><span onclick="PonerOpcion('var_t39_bis2','8')">8: En otros lugares</span> <span class='opc_aclaracion'>Especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t39_bis2_esp' name='var_t39_bis2_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t39_bis2_esp");' onKeyPress='PresionTeclaEnVariable("var_t39_bis2_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t39_bis2_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T40</span>
<span class='pre_texto' id='pre_T40'>¿Cuántas personas trabajan allí? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t40' name='var_t40' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t40");' onKeyPress='PresionTeclaEnVariable("var_t40",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t40",event);' ></span>
</td><td colspan=3><li id='var_t40__1'><span onclick="PonerOpcion('var_t40','1')">1: Una persona</span></li>
<li id='var_t40__2'><span onclick="PonerOpcion('var_t40','2')">2: De 2 a 5 personas</span></li>
<li id='var_t40__3'><span onclick="PonerOpcion('var_t40','3')">3: De 6 a 40 personas</span></li>
<li id='var_t40__4'><span onclick="PonerOpcion('var_t40','4')">4: Más de 40 personas</span></li>
<li id='var_t40__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t40','9')">9: No sabe</span></li>
<li id='var_t40__5'><span onclick="PonerOpcion('var_t40','5')">5: ¿Hasta 40?</span></li>
<li id='var_t40__6'><span onclick="PonerOpcion('var_t40','6')">6: ¿Más de 40?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T41</span>
<span class='pre_texto' id='pre_T41'>¿Cuál es el nombre de su ocupación?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t41' name='var_t41' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t41");' onKeyPress='PresionTeclaEnVariable("var_t41",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t41",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T42</span>
<span class='pre_texto' id='pre_T42'>¿Qué tareas realiza en ella?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t42' name='var_t42' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t42");' onKeyPress='PresionTeclaEnVariable("var_t42",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t42",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T43</span>
<span class='pre_texto' id='pre_T43'>¿Qué herramientas, maquinarias o equipos usa?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_t43' name='var_t43' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t43");' onKeyPress='PresionTeclaEnVariable("var_t43",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t43",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T44</span>
<span class='pre_texto' id='pre_T44'>¿Ese trabajo lo hace... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t44' name='var_t44' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t44");' onKeyPress='PresionTeclaEnVariable("var_t44",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t44",event);' ></span>
</td><td colspan=3><li id='var_t44__1'><span onclick="PonerOpcion('var_t44','1','pre_T46')">1: para su propio negocio/ empresa/ actividad?</span> <span class='texto_salto' id='var_t44.1.salto'> &#8631; T46</span>
</li>
<li id='var_t44__2'><span onclick="PonerOpcion('var_t44','2','pre_T45')">2: para el necio/ empresa/ actividad de un familiar?</span> <span class='texto_salto' id='var_t44.2.salto'> &#8631; T45</span>
</li>
<li id='var_t44__3'><span onclick="PonerOpcion('var_t44','3','pre_T49')">3: o para un patrón/ empresa/ institución?</span> <span class='texto_salto' id='var_t44.3.salto'> &#8631; T49</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T45</span>
<span class='pre_texto' id='pre_T45'>¿Por ese trabajo... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t45' name='var_t45' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t45");' onKeyPress='PresionTeclaEnVariable("var_t45",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t45",event);' ></span>
</td><td colspan=3><li id='var_t45__1'><span onclick="PonerOpcion('var_t45','1','pre_T49')">1: le pagan sueldo?</span> <span class='opc_aclaracion'>en dinero/ especie</span> <span class='texto_salto' id='var_t45.1.salto'> &#8631; T49</span>
</li>
<li id='var_t45__2'><span onclick="PonerOpcion('var_t45','2','pre_T46')">2: retira dinero?</span> <span class='texto_salto' id='var_t45.2.salto'> &#8631; T46</span>
</li>
<li id='var_t45__3'><span onclick="PonerOpcion('var_t45','3','pre_T53c')">3: no le pagan ni retira dinero?</span> <span class='texto_salto' id='var_t45.3.salto'> &#8631; T53c</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T46</span>
<span class='pre_texto' id='pre_T46'>¿En ese negocio/ empresa/ actividad, se emplean personas asalariadas? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t46' name='var_t46' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t46");' onKeyPress='PresionTeclaEnVariable("var_t46",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t46",event);' ></span>
</td><td colspan=3><li id='var_t46__1'><span onclick="PonerOpcion('var_t46','1')">1: Sí, siempre</span></li>
<li id='var_t46__2'><span onclick="PonerOpcion('var_t46','2')">2: Sólo a veces o por temporadas</span></li>
<li id='var_t46__3'><span onclick="PonerOpcion('var_t46','3')">3: No emplea ni contrata personal</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T47</span>
<span class='pre_texto' id='pre_T47'>¿Ese negocio/ empresa, trabaja... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t47' name='var_t47' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t47");' onKeyPress='PresionTeclaEnVariable("var_t47",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t47",event);' ></span>
</td><td colspan=3><li id='var_t47__1'><span onclick="PonerOpcion('var_t47','1','pre_T48')">1: siempre para el mismo cliente?</span> <span class='opc_aclaracion'>personas, empresas</span> <span class='texto_salto' id='var_t47.1.salto'> &#8631; T48</span>
</li>
<li id='var_t47__2'><span onclick="PonerOpcion('var_t47','2','pre_T48a')">2: para distintos clientes?</span> <span class='opc_aclaracion'>incluye publico en general</span> <span class='texto_salto' id='var_t47.2.salto'> &#8631; T48a</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T48</span>
<span class='pre_texto' id='pre_T48'>¿Ese cliente es... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t48' name='var_t48' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t48");' onKeyPress='PresionTeclaEnVariable("var_t48",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t48",event);' ></span>
</td><td colspan=3><li id='var_t48__1'><span onclick="PonerOpcion('var_t48','1')">1: una empresa/ negocio/ institución?</span></li>
<li id='var_t48__2'><span onclick="PonerOpcion('var_t48','2')">2: una familia/ hogar?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T48a</span>
<span class='pre_texto' id='pre_T48a'>¿Para poder realizar su actividad... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t48a' name='var_t48a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t48a");' onKeyPress='PresionTeclaEnVariable("var_t48a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t48a",event);' ></span>
</td><td colspan=3><li id='var_t48a__1'><span onclick="PonerOpcion('var_t48a','1')">1: No se registró nunca porque no le sirve?</span></li>
<li id='var_t48a__2'><span onclick="PonerOpcion('var_t48a','2')">2: No se registró nunca porque le resulta caro?</span></li>
<li id='var_t48a__3'><span onclick="PonerOpcion('var_t48a','3')">3: No se registró nunca porque es muy complicado/lleva demasiado tiempo</span></li>
<li id='var_t48a__4'><span onclick="PonerOpcion('var_t48a','4')">4: Se registró alguna vez pero luego dejó de hacer pagos regulares?</span></li>
<li id='var_t48a__5'><span onclick="PonerOpcion('var_t48a','5')">5: Se registró y realiza pagos regularmente?</span></li>
<li id='var_t48a__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t48a','9')">9: Ns/Nc</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T48b</span>
<span class='pre_texto' id='pre_T48b'>La jubilación ¿La paga regularmente... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t48b' name='var_t48b' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t48b");' onKeyPress='PresionTeclaEnVariable("var_t48b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t48b",event);' ></span>
</td><td colspan=3><li id='var_t48b__1'><span onclick="PonerOpcion('var_t48b','1','pre_T53')">1: Como monotributista?</span> <span class='texto_salto' id='var_t48b.1.salto'> &#8631; T53</span>
</li>
<li id='var_t48b__2'><span onclick="PonerOpcion('var_t48b','2','pre_T53')">2: Como autonómo aporta a una caja previsional o profesional?</span> <span class='texto_salto' id='var_t48b.2.salto'> &#8631; T53</span>
</li>
<li id='var_t48b__3'><span onclick="PonerOpcion('var_t48b','3','pre_T53')">3: No paga porque no le alcanza el dinero para aportar?</span> <span class='texto_salto' id='var_t48b.3.salto'> &#8631; T53</span>
</li>
<li id='var_t48b__4'><span onclick="PonerOpcion('var_t48b','4','pre_T53')">4: No paga porque la jubición que le darían sería muy baja</span> <span class='texto_salto' id='var_t48b.4.salto'> &#8631; T53</span>
</li>
<li id='var_t48b__5'><span onclick="PonerOpcion('var_t48b','5','pre_T53')">5: No paga porque el sistema jubilatorio no es confiable?</span> <span class='texto_salto' id='var_t48b.5.salto'> &#8631; T53</span>
</li>
<li id='var_t48b__6'><span onclick="PonerOpcion('var_t48b','6')">6: No paga por alguna otra razón</span> <span class='opc_aclaracion'>(especificar)</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_t48b_esp' name='var_t48b_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_t48b_esp");' onKeyPress='PresionTeclaEnVariable("var_t48b_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t48b_esp",event);' ></span>
 <span class='texto_salto' id='var_t48b_esp.salto'> &#8631; T53</span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T49</span>
<span class='pre_texto' id='pre_T49'>¿Ese trabajo tiene tiempo de finalización? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t49' name='var_t49' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t49");' onKeyPress='PresionTeclaEnVariable("var_t49",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t49",event);' ></span>
</td><td colspan=3><li id='var_t49__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t49','1')">1: Sí</span> <span class='opc_aclaracion'>temporario, contrato por obra, etc.</span></li>
<li id='var_t49__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t49','2')">2: No</span> <span class='opc_aclaracion'>permanente, fijo, estable, etc.</span></li>
<li id='var_t49__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t49','3')">3: Ns/Nc</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T50</span>
<span class='pre_texto' id='pre_T50'>¿En esa ocupación... <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>tiene vacaciones pagas?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50a' name='var_t50a' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50a");' onKeyPress='PresionTeclaEnVariable("var_t50a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50a",event);' ></span>
</td><td colspan=3><li id='var_t50a__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50a','1')">1: Sí</span></li>
<li id='var_t50a__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50a','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>le pagan aguinaldo?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50b' name='var_t50b' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50b");' onKeyPress='PresionTeclaEnVariable("var_t50b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50b",event);' ></span>
</td><td colspan=3><li id='var_t50b__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50b','1')">1: Sí</span></li>
<li id='var_t50b__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50b','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>tiene días pagos por enfermedad o accidente?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50c' name='var_t50c' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50c");' onKeyPress='PresionTeclaEnVariable("var_t50c",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50c",event);' ></span>
</td><td colspan=3><li id='var_t50c__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50c','1')">1: Sí</span></li>
<li id='var_t50c__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50c','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>tiene indemnización por despido?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50d' name='var_t50d' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50d");' onKeyPress='PresionTeclaEnVariable("var_t50d",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50d",event);' ></span>
</td><td colspan=3><li id='var_t50d__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50d','1')">1: Sí</span></li>
<li id='var_t50d__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50d','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>le descuentan para una obra social?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50e' name='var_t50e' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50e");' onKeyPress='PresionTeclaEnVariable("var_t50e",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50e",event);' ></span>
</td><td colspan=3><li id='var_t50e__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50e','1')">1: Sí</span></li>
<li id='var_t50e__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50e','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>le pagan salario familiar?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t50f' name='var_t50f' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t50f");' onKeyPress='PresionTeclaEnVariable("var_t50f",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t50f",event);' ></span>
</td><td colspan=3><li id='var_t50f__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50f','1')">1: Sí</span></li>
<li id='var_t50f__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t50f','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T51</span>
<span class='pre_texto' id='pre_T51'>¿En ese trabajo... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t51' name='var_t51' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t51");' onKeyPress='PresionTeclaEnVariable("var_t51",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t51",event);' ></span>
</td><td colspan=3><li id='var_t51__1'><span onclick="PonerOpcion('var_t51','1')">1: le descuentan para la jubilación?</span></li>
<li id='var_t51__2'><span onclick="PonerOpcion('var_t51','2')">2: aporta por si mismo para la jubilación?</span></li>
<li id='var_t51__3'><span onclick="PonerOpcion('var_t51','3')">3: no le descuentan ni aporta?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T52</span>
<span class='pre_texto' id='pre_T52'>¿Recibe además como pago... <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>comida en el lugar de trabajo?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t52a' name='var_t52a' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t52a");' onKeyPress='PresionTeclaEnVariable("var_t52a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t52a",event);' ></span>
</td><td colspan=3><li id='var_t52a__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52a','1')">1: Sí</span></li>
<li id='var_t52a__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52a','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>vivienda o alquiler para la vivienda?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t52b' name='var_t52b' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t52b");' onKeyPress='PresionTeclaEnVariable("var_t52b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t52b",event);' ></span>
</td><td colspan=3><li id='var_t52b__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52b','1')">1: Sí</span></li>
<li id='var_t52b__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52b','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>tickets de comida o de compra?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_t52c' name='var_t52c' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t52c");' onKeyPress='PresionTeclaEnVariable("var_t52c",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t52c",event);' ></span>
</td><td colspan=3><li id='var_t52c__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52c','1')">1: Sí</span></li>
<li id='var_t52c__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t52c','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T53</span>
<span class='pre_texto' id='pre_T53'>¿Cuánto gana en esa ocupación? <span class='pre_aclaracion'>O si es nuevo ¿cuánto arreglo que le paguen?</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Ingreso de la ocupación<td colspan=1><span class='respuesta'  title='monetaria'><input id='var_t53_ing' name='var_t53_ing' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_t53_ing");' onKeyPress='PresionTeclaEnVariable("var_t53_ing",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53_ing",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T53_bis1</span>
<span class='pre_texto' id='pre_T53_bis1'>Lo ganado corresponde a su trabajo de... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_t53_bis1' name='var_t53_bis1' type='number'  class='input_opciones' onblur='ValidarOpcion("var_t53_bis1");' onKeyPress='PresionTeclaEnVariable("var_t53_bis1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53_bis1",event);' ></span>
</td><td colspan=3><li id='var_t53_bis1__1'><span onclick="PonerOpcion('var_t53_bis1','1')">1: Todo el mes trabajando todos los días de la semana</span></li>
<li id='var_t53_bis1__2'><span onclick="PonerOpcion('var_t53_bis1','2')">2: Todo el mes trabajando algunos días de la semana</span></li>
<li id='var_t53_bis1__3'><span onclick="PonerOpcion('var_t53_bis1','3')">3: Menos de todo el mes</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1>Cuántos días por semana<td colspan=2><span class='respuesta'  title='numeros'><input id='var_t53_bis1_sem' name='var_t53_bis1_sem' type='number'  class='input_numeros' onblur='ValidarOpcion("var_t53_bis1_sem");' onKeyPress='PresionTeclaEnVariable("var_t53_bis1_sem",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53_bis1_sem",event);' ></span>
</td><td colspan=4></td></tr>
<tr><td colspan=1 class=sangria><td colspan=1>Cuántos días por mes<td colspan=2><span class='respuesta'  title='numeros'><input id='var_t53_bis1_mes' name='var_t53_bis1_mes' type='number'  class='input_numeros' onblur='ValidarOpcion("var_t53_bis1_mes");' onKeyPress='PresionTeclaEnVariable("var_t53_bis1_mes",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53_bis1_mes",event);' ></span>
 <span class='texto_salto' id='var_t53_bis1_mes.salto'> &#8631; T53c</span>
</td><td colspan=4></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T53_bis2</span>
<span class='pre_texto' id='pre_T53_bis2'>¿Cuántas horas promedio corresponde? <span class='pre_aclaracion'>en un día promedio</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='horas'><input id='var_t53_bis2' name='var_t53_bis2' type='number'  class='input_horas' onblur='ValidarOpcion("var_t53_bis2");' onKeyPress='PresionTeclaEnVariable("var_t53_bis2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53_bis2",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T53c</span>
<span class='pre_texto' id='pre_T53c'>¿Hace cuantos años que esta trabajando en ese empleo/ ocupación en forma continua? <span class='pre_aclaracion'>Para asalariados sin interrupciones de la relación laboral con la misma empresa/ negocio/ institución; para patrones y cuentapropias sin interrupciones laborales mayores de 15 días</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Años<td colspan=1><span class='respuesta'  title='anios'><input id='var_t53c_anios' name='var_t53c_anios' type='number'  class='input_anios' onblur='ValidarOpcion("var_t53c_anios");' onKeyPress='PresionTeclaEnVariable("var_t53c_anios",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53c_anios",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>Meses<td colspan=1><span class='respuesta'  title='meses'><input id='var_t53c_meses' name='var_t53c_meses' type='number'  class='input_meses' onblur='ValidarOpcion("var_t53c_meses");' onKeyPress='PresionTeclaEnVariable("var_t53c_meses",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53c_meses",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>Si es menos de un mes consigne 98<td colspan=1><span class='respuesta'  title='marcar_nulidad'><input id='var_t53c_98' name='var_t53c_98' type='text'  class='input_marcar_nulidad' onblur='ValidarOpcion("var_t53c_98");' onKeyPress='PresionTeclaEnVariable("var_t53c_98",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t53c_98",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T54</span>
<span class='pre_texto' id='pre_T54'>¿Participa en algún programa de empleo? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_t54' name='var_t54' type='text'  class='input_si_no' onblur='ValidarOpcion("var_t54");' onKeyPress='PresionTeclaEnVariable("var_t54",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t54",event);' ></span>
</td><td colspan=3><li id='var_t54__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t54','1')">1: Sí</span></li>
<li id='var_t54__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_t54','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>T54b</span>
<span class='pre_texto' id='pre_T54b'>¿A qué edad empezó a trabajar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='anios'><input id='var_t54b' name='var_t54b' type='number'  class='input_anios' onblur='ValidarOpcion("var_t54b");' onKeyPress='PresionTeclaEnVariable("var_t54b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_t54b",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Ingresos<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>I1</span>
<span class='pre_texto' id='pre_I1'>Hablemos de los ingresos que percibió durante el mes pasado. En ese mes ¿Tuvo algún ingreso en efectivo por trabajo?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='si_no'><input id='var_i1' name='var_i1' type='text'  class='input_si_no' onblur='ValidarOpcion("var_i1");' onKeyPress='PresionTeclaEnVariable("var_i1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i1",event);' ></span>
</td><td colspan=3><li id='var_i1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_i1','1')">1: Sí</span></li>
<li id='var_i1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_i1','2','pre_I3')">2: No</span> <span class='texto_salto' id='var_i1.2.salto'> &#8631; I3</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>I2</span>
<span class='pre_texto' id='pre_I2'>En el mes pasado ¿Podría decirme de cuanto fueron sus ingresos por trabajo, en efectivo en todas sus ocupaciones? <span class='pre_aclaracion'>Incluye gratificaciones/ bonificaciones no habituales, sueldo asignado como ganancia de patrón</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>Total Ingresos<td colspan=1><span class='respuesta'  title='monetaria'><input id='var_i2_totx' name='var_i2_totx' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i2_totx");' onKeyPress='PresionTeclaEnVariable("var_i2_totx",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i2_totx",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Tickets<td colspan=1><span class='respuesta'  title='monetaria'><input id='var_i2_ticx' name='var_i2_ticx' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i2_ticx");' onKeyPress='PresionTeclaEnVariable("var_i2_ticx",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i2_ticx",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>I3</span>
<span class='pre_texto' id='pre_I3'>¿Recibió ingresos en el mes pasado por... <span class='pre_aclaracion'>Aparte de sus ingresos por trabajo</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_1' name='var_i3_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_1");' onKeyPress='PresionTeclaEnVariable("var_i3_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_1",event);' ></span>
</td><td colspan=3><li id='var_i3_1__1'><span onclick="PonerOpcion('var_i3_1','1')">1: jubilación o pensión?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_1x' name='var_i3_1x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_1x");' onKeyPress='PresionTeclaEnVariable("var_i3_1x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_1x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_2' name='var_i3_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_2");' onKeyPress='PresionTeclaEnVariable("var_i3_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_2",event);' ></span>
</td><td colspan=3><li id='var_i3_2__2'><span onclick="PonerOpcion('var_i3_2','2')">2: alquileres, rentas o intereses?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_2x' name='var_i3_2x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_2x");' onKeyPress='PresionTeclaEnVariable("var_i3_2x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_2x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_3' name='var_i3_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_3");' onKeyPress='PresionTeclaEnVariable("var_i3_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_3",event);' ></span>
</td><td colspan=3><li id='var_i3_3__3'><span onclick="PonerOpcion('var_i3_3','3')">3: utilidades, beneficios o dividendos?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_3x' name='var_i3_3x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_3x");' onKeyPress='PresionTeclaEnVariable("var_i3_3x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_3x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_4' name='var_i3_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_4");' onKeyPress='PresionTeclaEnVariable("var_i3_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_4",event);' ></span>
</td><td colspan=3><li id='var_i3_4__4'><span onclick="PonerOpcion('var_i3_4','4')">4: seguro de desempleo?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_4x' name='var_i3_4x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_4x");' onKeyPress='PresionTeclaEnVariable("var_i3_4x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_4x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_5' name='var_i3_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_5");' onKeyPress='PresionTeclaEnVariable("var_i3_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_5",event);' ></span>
</td><td colspan=3><li id='var_i3_5__5'><span onclick="PonerOpcion('var_i3_5','5')">5: indemnización por despido?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_5x' name='var_i3_5x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_5x");' onKeyPress='PresionTeclaEnVariable("var_i3_5x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_5x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_6' name='var_i3_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_6");' onKeyPress='PresionTeclaEnVariable("var_i3_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_6",event);' ></span>
</td><td colspan=3><li id='var_i3_6__6'><span onclick="PonerOpcion('var_i3_6','6')">6: becas de estudio?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_6x' name='var_i3_6x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_6x");' onKeyPress='PresionTeclaEnVariable("var_i3_6x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_6x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_7' name='var_i3_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_7");' onKeyPress='PresionTeclaEnVariable("var_i3_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_7",event);' ></span>
</td><td colspan=3><li id='var_i3_7__7'><span onclick="PonerOpcion('var_i3_7','7')">7: cuota por alimentos?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_7x' name='var_i3_7x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_7x");' onKeyPress='PresionTeclaEnVariable("var_i3_7x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_7x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_8' name='var_i3_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_8");' onKeyPress='PresionTeclaEnVariable("var_i3_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_8",event);' ></span>
</td><td colspan=3><li id='var_i3_8__8'><span onclick="PonerOpcion('var_i3_8','8')">8: aportes de personas que no viven en el hogar?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_8x' name='var_i3_8x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_8x");' onKeyPress='PresionTeclaEnVariable("var_i3_8x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_8x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_11' name='var_i3_11' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_11");' onKeyPress='PresionTeclaEnVariable("var_i3_11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_11",event);' ></span>
</td><td colspan=3><li id='var_i3_11__11'><span onclick="PonerOpcion('var_i3_11','11')">11: el programa ciudadanía porteña?</span> <span class='opc_aclaracion'>tarjeta cabal</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_11x' name='var_i3_11x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_11x");' onKeyPress='PresionTeclaEnVariable("var_i3_11x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_11x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_12' name='var_i3_12' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_12");' onKeyPress='PresionTeclaEnVariable("var_i3_12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_12",event);' ></span>
</td><td colspan=3><li id='var_i3_12__12'><span onclick="PonerOpcion('var_i3_12','12')">12: otro subsidio o plan social del gobierno?</span> <span class='opc_aclaracion'>en dinero</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_12x' name='var_i3_12x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_12x");' onKeyPress='PresionTeclaEnVariable("var_i3_12x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_12x",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_10' name='var_i3_10' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_10");' onKeyPress='PresionTeclaEnVariable("var_i3_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_10",event);' ></span>
</td><td colspan=3><li id='var_i3_10__10'><span onclick="PonerOpcion('var_i3_10','10')">10: algún otro ingreso?</span> <span class='opc_aclaracion'>en dinero, especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_10x' name='var_i3_10x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_10x");' onKeyPress='PresionTeclaEnVariable("var_i3_10x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_10x",event);' ></span>
</td><td colspan=0></td></tr>
<tr><td colspan=5 class=sangria><td colspan=1><td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_i3_10_otro' name='var_i3_10_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_i3_10_otro");' onKeyPress='PresionTeclaEnVariable("var_i3_10_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_10_otro",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_13' name='var_i3_13' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_13");' onKeyPress='PresionTeclaEnVariable("var_i3_13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_13",event);' ></span>
</td><td colspan=3><li id='var_i3_13__13'><span onclick="PonerOpcion('var_i3_13','13')">13: asignación universal por hijo</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>$<td colspan=2><span class='respuesta'  title='monetaria'><input id='var_i3_13x' name='var_i3_13x' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_13x");' onKeyPress='PresionTeclaEnVariable("var_i3_13x",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_13x",event);' ></span>
</td><td colspan=0></td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Total ingresos<td colspan=1><span class='respuesta'  title='monetaria'><input id='var_i3_tot' name='var_i3_tot' type='number'  class='input_monetaria' onblur='ValidarOpcion("var_i3_tot");' onKeyPress='PresionTeclaEnVariable("var_i3_tot",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_tot",event);' ></span>
</td><td colspan=3></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_i3_99' name='var_i3_99' type='number'  class='input_marcar' onblur='ValidarOpcion("var_i3_99");' onKeyPress='PresionTeclaEnVariable("var_i3_99",event);' onKeyDown='PresionOtraTeclaEnVariable("var_i3_99",event);' ></span>
</td><td colspan=3><li id='var_i3_99__99'><span onclick="PonerOpcion('var_i3_99','99')">99: No tuvo ningún ingreso de este tipo</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_2</span>
<span class='pre_texto' id='pre_FILTRO_2'>CONFRONTE EDAD</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>menores de 3 años<td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_2' name='var_filtro_2' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_2");' onKeyPress='PresionTeclaEnVariable("var_filtro_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_2",event);' ></span>
 <span class='texto_salto' id='var_filtro_2.salto'> &#8631; E2</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Educación - para personas de 3 años o más<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E1</span>
<span class='pre_texto' id='pre_E1'>¿Sabe leer y escribir?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e1' name='var_e1' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e1");' onKeyPress='PresionTeclaEnVariable("var_e1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e1",event);' ></span>
</td><td colspan=3><li id='var_e1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e1','1')">1: Sí</span></li>
<li id='var_e1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e1','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E2</span>
<span class='pre_texto' id='pre_E2'>¿Asiste o asistió a algún establecimiento educativo? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e2' name='var_e2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e2");' onKeyPress='PresionTeclaEnVariable("var_e2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e2",event);' ></span>
</td><td colspan=3><li id='var_e2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e2','1','pre_E3')">1: Asiste</span> <span class='texto_salto' id='var_e2.1.salto'> &#8631; E3</span>
</li>
<li id='var_e2__2'><span onclick="PonerOpcion('var_e2','2','pre_E9')">2: no asiste pero asistió</span> <span class='texto_salto' id='var_e2.2.salto'> &#8631; E9</span>
</li>
<li id='var_e2__3'><span onclick="PonerOpcion('var_e2','3','pre_E15')">3: nunca asistió</span> <span class='texto_salto' id='var_e2.3.salto'> &#8631; E15</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para personas que asisten a un establecimiento educativo<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E3</span>
<span class='pre_texto' id='pre_E3'>¿Este establecimiento educativo esta en... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e3' name='var_e3' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e3");' onKeyPress='PresionTeclaEnVariable("var_e3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e3",event);' ></span>
</td><td colspan=3><li id='var_e3__1'><span onclick="PonerOpcion('var_e3','1','pre_E3a')">1: ciudad autónoma de Bs. As?</span> <span class='texto_salto' id='var_e3.1.salto'> &#8631; E3a</span>
</li>
<li id='var_e3__2'><span onclick="PonerOpcion('var_e3','2','pre_E4')">2: partido/ localidad del gran Bs. As</span> <span class='texto_salto' id='var_e3.2.salto'> &#8631; E4</span>
</li>
<li id='var_e3__3'><span onclick="PonerOpcion('var_e3','3','pre_E4')">3: otro lugar</span> <span class='texto_salto' id='var_e3.3.salto'> &#8631; E4</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E3a</span>
<span class='pre_texto' id='pre_E3a'>¿A que distancia de su casa? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e3a' name='var_e3a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e3a");' onKeyPress='PresionTeclaEnVariable("var_e3a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e3a",event);' ></span>
</td><td colspan=3><li id='var_e3a__1'><span onclick="PonerOpcion('var_e3a','1')">1: Hasta 10 cuadras</span></li>
<li id='var_e3a__2'><span onclick="PonerOpcion('var_e3a','2')">2: De 11 a 20 cuadras</span></li>
<li id='var_e3a__3'><span onclick="PonerOpcion('var_e3a','3')">3: Más de 20 cuadras</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E4</span>
<span class='pre_texto' id='pre_E4'>¿El establecimiento al que asiste actualmente es.... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e4' name='var_e4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e4");' onKeyPress='PresionTeclaEnVariable("var_e4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e4",event);' ></span>
</td><td colspan=3><li id='var_e4__1'><span onclick="PonerOpcion('var_e4','1')">1: estatal/ publico?</span></li>
<li id='var_e4__2'><span onclick="PonerOpcion('var_e4','2')">2: privado religioso?</span> <span class='opc_aclaracion'>cualquier credo</span></li>
<li id='var_e4__3'><span onclick="PonerOpcion('var_e4','3')">3: privado no religioso?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E6</span>
<span class='pre_texto' id='pre_E6'>¿Qué nivel esta cursando actualmente? <span class='pre_aclaracion'>E-S con indagación</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e6' name='var_e6' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e6");' onKeyPress='PresionTeclaEnVariable("var_e6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e6",event);' ></span>
</td><td colspan=3><li id='var_e6__16'><span onclick="PonerOpcion('var_e6','16','pre_M1')">16: Jardín Maternal - 45 días a 2 años</span> <span class='texto_salto' id='var_e6.16.salto'> &#8631; M1</span>
</li>
<li id='var_e6__17'><span onclick="PonerOpcion('var_e6','17','pre_M1')">17: Jardín Maternal - Sala de 3 años</span> <span class='texto_salto' id='var_e6.17.salto'> &#8631; M1</span>
</li>
<li id='var_e6__18'><span onclick="PonerOpcion('var_e6','18','pre_M1')">18: Jardín Maternal - Sala de 4 años</span> <span class='texto_salto' id='var_e6.18.salto'> &#8631; M1</span>
</li>
<li id='var_e6__2'><span onclick="PonerOpcion('var_e6','2','pre_M1')">2: Jardín Maternal - Sala de 5 años</span> <span class='texto_salto' id='var_e6.2.salto'> &#8631; M1</span>
</li>
<li id='var_e6__3'><span onclick="PonerOpcion('var_e6','3')">3: Primario Común</span></li>
<li id='var_e6__7'><span onclick="PonerOpcion('var_e6','7')">7: Secundario/ medio Común</span></li>
<li id='var_e6__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e6','11')">11: Polimodal</span></li>
<li id='var_e6__5'><span onclick="PonerOpcion('var_e6','5')">5: Primario especial</span></li>
<li id='var_e6__6'><span onclick="PonerOpcion('var_e6','6')">6: Otras escuelas especiales</span></li>
<li id='var_e6__15'><span onclick="PonerOpcion('var_e6','15')">15: Primario adultos</span></li>
<li id='var_e6__10'><span onclick="PonerOpcion('var_e6','10')">10: Secundario / Medio adultos</span></li>
<li id='var_e6__12'><span onclick="PonerOpcion('var_e6','12')">12: Terciario / Superior no universitario</span></li>
<li id='var_e6__13'><span onclick="PonerOpcion('var_e6','13')">13: Universitario</span></li>
<li id='var_e6__14' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e6','14')">14: Postgrado</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E8</span>
<span class='pre_texto' id='pre_E8'>¿Cuál es el grado/ año que está cursando actualmente? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e8' name='var_e8' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e8");' onKeyPress='PresionTeclaEnVariable("var_e8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e8",event);' ></span>
 <span class='texto_salto' id='var_e8.salto'> &#8631; TE</span>
</td><td colspan=3><li id='var_e8__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','1')">1: 1</span></li>
<li id='var_e8__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','2')">2: 2</span></li>
<li id='var_e8__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','3')">3: 3</span></li>
<li id='var_e8__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','4')">4: 4</span></li>
<li id='var_e8__5' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','5')">5: 5</span></li>
<li id='var_e8__6' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','6')">6: 6</span></li>
<li id='var_e8__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','7')">7: 7</span></li>
<li id='var_e8__8' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','8')">8: 8</span></li>
<li id='var_e8__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','9')">9: 9</span></li>
<li id='var_e8__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e8','11')">11: CBC</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para personas que no asisten pero si asistieron<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E9</span>
<span class='pre_texto' id='pre_E9'>¿Qué edad tenía cuando dejó los estudios? Si no recuerda la edad, ¿en qué año?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Edad<td colspan=1><span class='respuesta'  title='anios'><input id='var_e9_edad' name='var_e9_edad' type='number'  class='input_anios' onblur='ValidarOpcion("var_e9_edad");' onKeyPress='PresionTeclaEnVariable("var_e9_edad",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e9_edad",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>Año<td colspan=1><span class='respuesta'  title='anio'><input id='var_e9_anio' name='var_e9_anio' type='number'  class='input_anio' onblur='ValidarOpcion("var_e9_anio");' onKeyPress='PresionTeclaEnVariable("var_e9_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e9_anio",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E10</span>
<span class='pre_texto' id='pre_E10'>¿El último establecimiento educativo al que concurrió era... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e10' name='var_e10' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e10");' onKeyPress='PresionTeclaEnVariable("var_e10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e10",event);' ></span>
</td><td colspan=3><li id='var_e10__1'><span onclick="PonerOpcion('var_e10','1')">1: estatal/ público?</span></li>
<li id='var_e10__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e10','2')">2: privado?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E12</span>
<span class='pre_texto' id='pre_E12'>¿Cuál es el nivel más alto que curso? <span class='pre_aclaracion'>E-S con indagación</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e12' name='var_e12' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e12");' onKeyPress='PresionTeclaEnVariable("var_e12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e12",event);' ></span>
</td><td colspan=3><li id='var_e12__16'><span onclick="PonerOpcion('var_e12','16','pre_E11')">16: Jardín Maternal - 45 días a 2 años</span> <span class='texto_salto' id='var_e12.16.salto'> &#8631; E11</span>
</li>
<li id='var_e12__17'><span onclick="PonerOpcion('var_e12','17','pre_E11')">17: Jardín Maternal - Sala de 3 años</span> <span class='texto_salto' id='var_e12.17.salto'> &#8631; E11</span>
</li>
<li id='var_e12__18'><span onclick="PonerOpcion('var_e12','18','pre_E11')">18: Jardín Maternal - Sala de 4 años</span> <span class='texto_salto' id='var_e12.18.salto'> &#8631; E11</span>
</li>
<li id='var_e12__2'><span onclick="PonerOpcion('var_e12','2','pre_E11')">2: Jardín Maternal - Sala de 5 años</span> <span class='texto_salto' id='var_e12.2.salto'> &#8631; E11</span>
</li>
<li id='var_e12__3'><span onclick="PonerOpcion('var_e12','3')">3: Primario Común</span></li>
<li id='var_e12__4'><span onclick="PonerOpcion('var_e12','4')">4: De primero a noveno año</span></li>
<li id='var_e12__7'><span onclick="PonerOpcion('var_e12','7')">7: Secundario/ medio Común</span></li>
<li id='var_e12__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e12','11')">11: Polimodal</span></li>
<li id='var_e12__5'><span onclick="PonerOpcion('var_e12','5')">5: Primario especial</span></li>
<li id='var_e12__6'><span onclick="PonerOpcion('var_e12','6')">6: Otras escuelas especiales</span></li>
<li id='var_e12__15'><span onclick="PonerOpcion('var_e12','15')">15: Primario adultos</span></li>
<li id='var_e12__10'><span onclick="PonerOpcion('var_e12','10')">10: Secundario / Medio adultos</span></li>
<li id='var_e12__12'><span onclick="PonerOpcion('var_e12','12')">12: Terciario / Superior no universitario</span></li>
<li id='var_e12__13'><span onclick="PonerOpcion('var_e12','13')">13: Universitario</span></li>
<li id='var_e12__14' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e12','14')">14: Postgrado</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E13</span>
<span class='pre_texto' id='pre_E13'>¿Completo ese nivel?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e13' name='var_e13' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e13");' onKeyPress='PresionTeclaEnVariable("var_e13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e13",event);' ></span>
</td><td colspan=3><li id='var_e13__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e13','1','pre_E11')">1: Sí</span> <span class='texto_salto' id='var_e13.1.salto'> &#8631; E11</span>
</li>
<li id='var_e13__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e13','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E14</span>
<span class='pre_texto' id='pre_E14'>¿Cuál es el grado/ año que aprobó en ese nivel? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e14' name='var_e14' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e14");' onKeyPress='PresionTeclaEnVariable("var_e14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e14",event);' ></span>
</td><td colspan=3><li id='var_e14__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','1')">1: 1</span></li>
<li id='var_e14__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','2')">2: 2</span></li>
<li id='var_e14__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','3')">3: 3</span></li>
<li id='var_e14__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','4')">4: 4</span></li>
<li id='var_e14__5' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','5')">5: 5</span></li>
<li id='var_e14__6' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','6')">6: 6</span></li>
<li id='var_e14__7' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','7')">7: 7</span></li>
<li id='var_e14__8' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','8')">8: 8</span></li>
<li id='var_e14__9' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','9')">9: 9</span></li>
<li id='var_e14__10' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','10')">10: Ninguno</span></li>
<li id='var_e14__11' style='white-space:nowrap;'><span onclick="PonerOpcion('var_e14','11')">11: CBC</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E11</span>
<span class='pre_texto' id='pre_E11'>¿Por qué dejó de estudiar?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_1' name='var_e11_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_1");' onKeyPress='PresionTeclaEnVariable("var_e11_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_1",event);' ></span>
</td><td colspan=3><li id='var_e11_1__1'><span onclick="PonerOpcion('var_e11_1','1')">1: Termino los estudios</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_2' name='var_e11_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_2");' onKeyPress='PresionTeclaEnVariable("var_e11_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_2",event);' ></span>
</td><td colspan=3><li id='var_e11_2__2'><span onclick="PonerOpcion('var_e11_2','2')">2: Casamiento, embarazo, cuidado de hijos</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_3' name='var_e11_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_3");' onKeyPress='PresionTeclaEnVariable("var_e11_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_3",event);' ></span>
</td><td colspan=3><li id='var_e11_3__3'><span onclick="PonerOpcion('var_e11_3','3')">3: Por trabajo o problemas económicos</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_4' name='var_e11_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_4");' onKeyPress='PresionTeclaEnVariable("var_e11_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_4",event);' ></span>
</td><td colspan=3><li id='var_e11_4__4'><span onclick="PonerOpcion('var_e11_4','4')">4: Lo resultaba difícil, le costaba estudiar</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_5' name='var_e11_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_5");' onKeyPress='PresionTeclaEnVariable("var_e11_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_5",event);' ></span>
</td><td colspan=3><li id='var_e11_5__5'><span onclick="PonerOpcion('var_e11_5','5')">5: Por el costo de la movilidad, del transporte</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_6' name='var_e11_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_6");' onKeyPress='PresionTeclaEnVariable("var_e11_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_6",event);' ></span>
</td><td colspan=3><li id='var_e11_6__6'><span onclick="PonerOpcion('var_e11_6','6')">6: Por el costo de la cuota o los gastos de la escuela</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_7' name='var_e11_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_7");' onKeyPress='PresionTeclaEnVariable("var_e11_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_7",event);' ></span>
</td><td colspan=3><li id='var_e11_7__7'><span onclick="PonerOpcion('var_e11_7','7')">7: No había escuela en la zona, no había vacantes</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_8' name='var_e11_8' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_8");' onKeyPress='PresionTeclaEnVariable("var_e11_8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_8",event);' ></span>
</td><td colspan=3><li id='var_e11_8__8'><span onclick="PonerOpcion('var_e11_8','8')">8: Enfermedad, accidente, discapacidad</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_9' name='var_e11_9' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_9");' onKeyPress='PresionTeclaEnVariable("var_e11_9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_9",event);' ></span>
</td><td colspan=3><li id='var_e11_9__9'><span onclick="PonerOpcion('var_e11_9','9')">9: No le gustaba, no tenía interés de estudiar</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_10' name='var_e11_10' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_10");' onKeyPress='PresionTeclaEnVariable("var_e11_10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_10",event);' ></span>
</td><td colspan=3><li id='var_e11_10__10'><span onclick="PonerOpcion('var_e11_10','10')">10: Tuvo que cuidar a algún miembro del hogar</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_11' name='var_e11_11' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_11");' onKeyPress='PresionTeclaEnVariable("var_e11_11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_11",event);' ></span>
</td><td colspan=3><li id='var_e11_11__11'><span onclick="PonerOpcion('var_e11_11','11')">11: La familia no lo mandó. Problemas familiares</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_12' name='var_e11_12' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_12");' onKeyPress='PresionTeclaEnVariable("var_e11_12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_12",event);' ></span>
</td><td colspan=3><li id='var_e11_12__12'><span onclick="PonerOpcion('var_e11_12','12')">12: Problemas con la escuela</span> <span class='opc_aclaracion'>repitencia, expulsión, peleas, etc</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_13' name='var_e11_13' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_13");' onKeyPress='PresionTeclaEnVariable("var_e11_13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_13",event);' ></span>
</td><td colspan=3><li id='var_e11_13__13'><span onclick="PonerOpcion('var_e11_13','13')">13: Inasistencias. Quedó libre</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_14' name='var_e11_14' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_14");' onKeyPress='PresionTeclaEnVariable("var_e11_14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_14",event);' ></span>
</td><td colspan=3><li id='var_e11_14__14'><span onclick="PonerOpcion('var_e11_14','14')">14: Migración</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e11_15' name='var_e11_15' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e11_15");' onKeyPress='PresionTeclaEnVariable("var_e11_15",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_15",event);' ></span>
</td><td colspan=3><li id='var_e11_15__15'><span onclick="PonerOpcion('var_e11_15','15')">15: Algún otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_e11_15_otro' name='var_e11_15_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_e11_15_otro");' onKeyPress='PresionTeclaEnVariable("var_e11_15_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11_15_otro",event);' ></span>
</td><td colspan=0></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E11a</span>
<span class='pre_texto' id='pre_E11a'>¿Cual es la mas importante?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e11a' name='var_e11a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e11a");' onKeyPress='PresionTeclaEnVariable("var_e11a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e11a",event);' ></span>
 <span class='texto_salto' id='var_e11a.salto'> &#8631; TE</span>
</td><td colspan=3><li id='var_e11a__1'><span onclick="PonerOpcion('var_e11a','1')">1: Termino los estudios</span></li>
<li id='var_e11a__2'><span onclick="PonerOpcion('var_e11a','2')">2: Casamiento, embarazo, cuidado de hijos</span></li>
<li id='var_e11a__3'><span onclick="PonerOpcion('var_e11a','3')">3: Por trabajo o problemas económicos</span></li>
<li id='var_e11a__4'><span onclick="PonerOpcion('var_e11a','4')">4: Lo resultaba difícil, le costaba estudiar</span></li>
<li id='var_e11a__5'><span onclick="PonerOpcion('var_e11a','5')">5: Por el costo de la movilidad, del transporte</span></li>
<li id='var_e11a__6'><span onclick="PonerOpcion('var_e11a','6')">6: Por el costo de la cuota o los gastos de la escuela</span></li>
<li id='var_e11a__7'><span onclick="PonerOpcion('var_e11a','7')">7: No había escuela en la zona, no había vacantes</span></li>
<li id='var_e11a__8'><span onclick="PonerOpcion('var_e11a','8')">8: Enfermedad, accidente, discapacidad</span></li>
<li id='var_e11a__9'><span onclick="PonerOpcion('var_e11a','9')">9: No le gustaba, no tenía interés de estudiar</span></li>
<li id='var_e11a__10'><span onclick="PonerOpcion('var_e11a','10')">10: Tuvo que cuidar a algún miembro del hogar</span></li>
<li id='var_e11a__11'><span onclick="PonerOpcion('var_e11a','11')">11: La familia no lo mandó. Problemas familiares</span></li>
<li id='var_e11a__12'><span onclick="PonerOpcion('var_e11a','12')">12: Problemas con la escuela</span> <span class='opc_aclaracion'>repitencia, expulsión, peleas, etc</span></li>
<li id='var_e11a__13'><span onclick="PonerOpcion('var_e11a','13')">13: Inasistencias. Quedó libre</span></li>
<li id='var_e11a__14'><span onclick="PonerOpcion('var_e11a','14')">14: Migración</span></li>
<li id='var_e11a__15'><span onclick="PonerOpcion('var_e11a','15')">15: Algún otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>TE</span>
<span class='pre_texto' id='pre_TE'>Considerando su trayectoria en el sistema educativo ¿se dio alguna de las siguientes situaciones?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>¿Repitió algún grado o año de estudio?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_te_1' name='var_te_1' type='text'  class='input_si_no' onblur='ValidarOpcion("var_te_1");' onKeyPress='PresionTeclaEnVariable("var_te_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_te_1",event);' ></span>
</td><td colspan=3><li id='var_te_1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_te_1','1')">1: Sí</span></li>
<li id='var_te_1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_te_1','2')">2: No</span></li>
</td></tr>
<tr><td colspan=3>¿Abandonó los estudios por un tiempo y los retomó posteriormente?<td colspan=1><span class='respuesta'  title='si_no'><input id='var_te_2' name='var_te_2' type='text'  class='input_si_no' onblur='ValidarOpcion("var_te_2");' onKeyPress='PresionTeclaEnVariable("var_te_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_te_2",event);' ></span>
 <span class='texto_salto' id='var_te_2.salto'> &#8631; M1</span>
</td><td colspan=3><li id='var_te_2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_te_2','1')">1: Sí</span></li>
<li id='var_te_2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_te_2','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para personas que nunca asistieron<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E15</span>
<span class='pre_texto' id='pre_E15'>¿Por qué motivo no empezó la escuela primaria? <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_1' name='var_e15_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_1");' onKeyPress='PresionTeclaEnVariable("var_e15_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_1",event);' ></span>
</td><td colspan=3><li id='var_e15_1__1'><span onclick="PonerOpcion('var_e15_1','1')">1: No había vacantes, no había escuelas en la zona</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_2' name='var_e15_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_2");' onKeyPress='PresionTeclaEnVariable("var_e15_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_2",event);' ></span>
</td><td colspan=3><li id='var_e15_2__2'><span onclick="PonerOpcion('var_e15_2','2')">2: Costo movilidad, problemas de transporte</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_3' name='var_e15_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_3");' onKeyPress='PresionTeclaEnVariable("var_e15_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_3",event);' ></span>
</td><td colspan=3><li id='var_e15_3__3'><span onclick="PonerOpcion('var_e15_3','3')">3: Estaba enfermo o discapacitado</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_4' name='var_e15_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_4");' onKeyPress='PresionTeclaEnVariable("var_e15_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_4",event);' ></span>
</td><td colspan=3><li id='var_e15_4__4'><span onclick="PonerOpcion('var_e15_4','4')">4: Tenia que trabajar, ayudar en la casa</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_5' name='var_e15_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_5");' onKeyPress='PresionTeclaEnVariable("var_e15_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_5",event);' ></span>
</td><td colspan=3><li id='var_e15_5__5'><span onclick="PonerOpcion('var_e15_5','5')">5: Otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_e15_5_otro' name='var_e15_5_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_e15_5_otro");' onKeyPress='PresionTeclaEnVariable("var_e15_5_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_5_otro",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_6' name='var_e15_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_6");' onKeyPress='PresionTeclaEnVariable("var_e15_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_6",event);' ></span>
</td><td colspan=3><li id='var_e15_6__6'><span onclick="PonerOpcion('var_e15_6','6')">6: Menor de 5 años</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_e15_7' name='var_e15_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_e15_7");' onKeyPress='PresionTeclaEnVariable("var_e15_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15_7",event);' ></span>
</td><td colspan=3><li id='var_e15_7__7'><span onclick="PonerOpcion('var_e15_7','7')">7: La familia no lo mandó. Problemas familiares</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>E15a</span>
<span class='pre_texto' id='pre_E15a'>¿Cual es la mas importante?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_e15a' name='var_e15a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_e15a");' onKeyPress='PresionTeclaEnVariable("var_e15a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_e15a",event);' ></span>
 <span class='texto_salto' id='var_e15a.salto'> &#8631; M1</span>
</td><td colspan=3><li id='var_e15a__1'><span onclick="PonerOpcion('var_e15a','1')">1: No había vacantes, no había escuelas en la zona</span></li>
<li id='var_e15a__2'><span onclick="PonerOpcion('var_e15a','2')">2: Costo movilidad, problemas de transporte</span></li>
<li id='var_e15a__3'><span onclick="PonerOpcion('var_e15a','3')">3: Estaba enfermo o discapacitado</span></li>
<li id='var_e15a__4'><span onclick="PonerOpcion('var_e15a','4')">4: Tenia que trabajar, ayudar en la casa</span></li>
<li id='var_e15a__5'><span onclick="PonerOpcion('var_e15a','5')">5: Otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
<li id='var_e15a__6'><span onclick="PonerOpcion('var_e15a','6')">6: Menor de 5 años</span></li>
<li id='var_e15a__7'><span onclick="PonerOpcion('var_e15a','7')">7: La familia no lo mandó. Problemas familiares</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para personas menores de 3 años<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Migraciones - Para todas las personas<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>M1</span>
<span class='pre_texto' id='pre_M1'>¿Dónde nació? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_m1' name='var_m1' type='number'  class='input_opciones' onblur='ValidarOpcion("var_m1");' onKeyPress='PresionTeclaEnVariable("var_m1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1",event);' ></span>
</td><td colspan=3><li id='var_m1__1'><span onclick="PonerOpcion('var_m1','1','pre_M1a')">1: En esta ciudad</span> <span class='texto_salto' id='var_m1.1.salto'> &#8631; M1a</span>
</li>
<li id='var_m1__2'><span onclick="PonerOpcion('var_m1','2')">2: En la pcia. de Buenos Aires</span> <span class='opc_aclaracion'>especificar partido/ localidad</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>partido/loc.<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1_esp2' name='var_m1_esp2' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1_esp2");' onKeyPress='PresionTeclaEnVariable("var_m1_esp2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1_esp2",event);' ></span>
 <span class='texto_salto' id='var_m1_esp2.salto'> &#8631; M1a</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m1__3'><span onclick="PonerOpcion('var_m1','3')">3: En otra provincia</span> <span class='opc_aclaracion'>especificar provincia</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>provincia<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1_esp3' name='var_m1_esp3' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1_esp3");' onKeyPress='PresionTeclaEnVariable("var_m1_esp3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1_esp3",event);' ></span>
 <span class='texto_salto' id='var_m1_esp3.salto'> &#8631; M1a</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m1__4'><span onclick="PonerOpcion('var_m1','4')">4: En otro país</span> <span class='opc_aclaracion'>especificar país</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>país<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1_esp4' name='var_m1_esp4' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1_esp4");' onKeyPress='PresionTeclaEnVariable("var_m1_esp4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1_esp4",event);' ></span>
</td><td colspan=1></td></tr>
<tr><td colspan=4 class=sangria><td colspan=1>¿En qué año llegó al país?<td colspan=2><span class='respuesta'  title='anio'><input id='var_m1_anio' name='var_m1_anio' type='number'  class='input_anio' onblur='ValidarOpcion("var_m1_anio");' onKeyPress='PresionTeclaEnVariable("var_m1_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1_anio",event);' ></span>
 <span class='texto_salto' id='var_m1_anio.salto'> &#8631; M3</span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>M1a</span>
<span class='pre_texto' id='pre_M1a'>¿Dónde vivía su madre cuando usted nació? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_m1a' name='var_m1a' type='number'  class='input_opciones' onblur='ValidarOpcion("var_m1a");' onKeyPress='PresionTeclaEnVariable("var_m1a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1a",event);' ></span>
</td><td colspan=3><li id='var_m1a__1'><span onclick="PonerOpcion('var_m1a','1')">1: En esta ciudad</span></li>
<li id='var_m1a__2'><span onclick="PonerOpcion('var_m1a','2')">2: En la pcia. de Buenos Aires</span> <span class='opc_aclaracion'>especificar partido/ localidad</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>partido/loc.<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1a_esp2' name='var_m1a_esp2' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1a_esp2");' onKeyPress='PresionTeclaEnVariable("var_m1a_esp2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1a_esp2",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m1a__3'><span onclick="PonerOpcion('var_m1a','3')">3: En otra provincia</span> <span class='opc_aclaracion'>especificar provincia</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>provincia<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1a_esp3' name='var_m1a_esp3' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1a_esp3");' onKeyPress='PresionTeclaEnVariable("var_m1a_esp3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1a_esp3",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m1a__4'><span onclick="PonerOpcion('var_m1a','4')">4: En otro país</span> <span class='opc_aclaracion'>especificar país</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>país<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m1a_esp4' name='var_m1a_esp4' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m1a_esp4");' onKeyPress='PresionTeclaEnVariable("var_m1a_esp4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m1a_esp4",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>M3</span>
<span class='pre_texto' id='pre_M3'>¿Desde qué año vive en forma continua en esta ciudad?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_m3' name='var_m3' type='number'  class='input_opciones' onblur='ValidarOpcion("var_m3");' onKeyPress='PresionTeclaEnVariable("var_m3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m3",event);' ></span>
</td><td colspan=3><li id='var_m3__1'><span onclick="PonerOpcion('var_m3','1','pre_SN1')">1: Desde que nació</span> <span class='texto_salto' id='var_m3.1.salto'> &#8631; SN1</span>
</li>
<li id='var_m3__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_m3','2')">2: Año</span> <span class='opc_aclaracion'>especifique</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='anio'><input id='var_m3_anio' name='var_m3_anio' type='number'  class='input_anio' onblur='ValidarOpcion("var_m3_anio");' onKeyPress='PresionTeclaEnVariable("var_m3_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m3_anio",event);' ></span>
 <span class='texto_salto' id='var_m3_anio.salto'> &#8631; M4</span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>M4</span>
<span class='pre_texto' id='pre_M4'>¿Dónde vivía antes de ese año? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_m4' name='var_m4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_m4");' onKeyPress='PresionTeclaEnVariable("var_m4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m4",event);' ></span>
</td><td colspan=3><li id='var_m4__1'><span onclick="PonerOpcion('var_m4','1')">1: En la pcia. de Buenos Aires</span> <span class='opc_aclaracion'>especificar partido/ localidad</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>partido/loc.<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m4_esp1' name='var_m4_esp1' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m4_esp1");' onKeyPress='PresionTeclaEnVariable("var_m4_esp1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m4_esp1",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m4__2'><span onclick="PonerOpcion('var_m4','2')">2: En otra provincia</span> <span class='opc_aclaracion'>especificar provincia</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>provincia<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m4_esp2' name='var_m4_esp2' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m4_esp2");' onKeyPress='PresionTeclaEnVariable("var_m4_esp2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m4_esp2",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_m4__3'><span onclick="PonerOpcion('var_m4','3')">3: En otro país</span> <span class='opc_aclaracion'>especificar país</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>país<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_m4_esp3' name='var_m4_esp3' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_m4_esp3");' onKeyPress='PresionTeclaEnVariable("var_m4_esp3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m4_esp3",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>M5</span>
<span class='pre_texto' id='pre_M5'>¿Cuál fue el motivo por el que vino a vivir a esta ciudad? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_m5' name='var_m5' type='number'  class='input_opciones' onblur='ValidarOpcion("var_m5");' onKeyPress='PresionTeclaEnVariable("var_m5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_m5",event);' ></span>
</td><td colspan=3><li id='var_m5__1'><span onclick="PonerOpcion('var_m5','1')">1: Razones laborales</span></li>
<li id='var_m5__2'><span onclick="PonerOpcion('var_m5','2')">2: Acompañar o reunirse con su familia</span></li>
<li id='var_m5__3'><span onclick="PonerOpcion('var_m5','3')">3: Otras causas personales</span> <span class='opc_aclaracion'>por estudio, por casamiento, por separación, etc.</span></li>
<li id='var_m5__4'><span onclick="PonerOpcion('var_m5','4')">4: Causas no personales</span> <span class='opc_aclaracion'>razones políticas, sociales, religiosas, étnicas, etc.</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Salud - Para todas las personas<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN1</span>
<span class='pre_texto' id='pre_SN1'>¿Esta afiliado a... <span class='pre_aclaracion'>G-M. Siga leyendo aun cuando obtenga una respuesta positiva</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_1' name='var_sn1_1' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_1");' onKeyPress='PresionTeclaEnVariable("var_sn1_1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_1",event);' ></span>
</td><td colspan=3><li id='var_sn1_1__1'><span onclick="PonerOpcion('var_sn1_1','1')">1: una obra social?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn1_1_esp' name='var_sn1_1_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn1_1_esp");' onKeyPress='PresionTeclaEnVariable("var_sn1_1_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_1_esp",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_7' name='var_sn1_7' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_7");' onKeyPress='PresionTeclaEnVariable("var_sn1_7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_7",event);' ></span>
</td><td colspan=3><li id='var_sn1_7__7'><span onclick="PonerOpcion('var_sn1_7','7')">7: una prepaga o mutual vía obra social?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn1_7_esp' name='var_sn1_7_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn1_7_esp");' onKeyPress='PresionTeclaEnVariable("var_sn1_7_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_7_esp",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_2' name='var_sn1_2' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_2");' onKeyPress='PresionTeclaEnVariable("var_sn1_2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_2",event);' ></span>
</td><td colspan=3><li id='var_sn1_2__2'><span onclick="PonerOpcion('var_sn1_2','2')">2: una mutual?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn1_2_esp' name='var_sn1_2_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn1_2_esp");' onKeyPress='PresionTeclaEnVariable("var_sn1_2_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_2_esp",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_3' name='var_sn1_3' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_3");' onKeyPress='PresionTeclaEnVariable("var_sn1_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_3",event);' ></span>
</td><td colspan=3><li id='var_sn1_3__3'><span onclick="PonerOpcion('var_sn1_3','3')">3: un plan de medicina prepaga?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn1_3_esp' name='var_sn1_3_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn1_3_esp");' onKeyPress='PresionTeclaEnVariable("var_sn1_3_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_3_esp",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_4' name='var_sn1_4' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_4");' onKeyPress='PresionTeclaEnVariable("var_sn1_4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_4",event);' ></span>
</td><td colspan=3><li id='var_sn1_4__4'><span onclick="PonerOpcion('var_sn1_4','4')">4: un sistema de emergencias medicas?</span></li>
</td></tr>
<tr><td colspan=5 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn1_4_esp' name='var_sn1_4_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn1_4_esp");' onKeyPress='PresionTeclaEnVariable("var_sn1_4_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_4_esp",event);' ></span>
</td><td colspan=0></td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_5' name='var_sn1_5' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_5");' onKeyPress='PresionTeclaEnVariable("var_sn1_5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_5",event);' ></span>
</td><td colspan=3><li id='var_sn1_5__5'><span onclick="PonerOpcion('var_sn1_5','5')">5: el plan de médicos de cabecera del GCBA?</span></li>
</td></tr>
<tr class='fila_subpregunta_multiple'><td colspan=1 class=sangria><td colspan=3><td colspan=1><span class='respuesta'  title='marcar'><input id='var_sn1_6' name='var_sn1_6' type='number'  class='input_marcar' onblur='ValidarOpcion("var_sn1_6");' onKeyPress='PresionTeclaEnVariable("var_sn1_6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn1_6",event);' ></span>
</td><td colspan=3><li id='var_sn1_6__6'><span onclick="PonerOpcion('var_sn1_6','6')">6: No tiene afiliación</span> <span class='opc_aclaracion'>NO LEER</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN2</span>
<span class='pre_texto' id='pre_SN2'>¿En los últimos 30 días realizó consultas con un médico clínico o un especialista como cirujano, traumatólogo, ginecólogo, oculista, etc?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn2' name='var_sn2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn2");' onKeyPress='PresionTeclaEnVariable("var_sn2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn2",event);' ></span>
</td><td colspan=3><li id='var_sn2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn2','1')">1: Sí</span> <span class='opc_aclaracion'>Cuantas?</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>Cuantas?<td colspan=2><span class='respuesta'  title='numeros'><input id='var_sn2_cant' name='var_sn2_cant' type='number'  class='input_numeros' onblur='ValidarOpcion("var_sn2_cant");' onKeyPress='PresionTeclaEnVariable("var_sn2_cant",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn2_cant",event);' ></span>
 <span class='texto_salto' id='var_sn2_cant.salto'> &#8631; SN4</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn2','2','pre_SN3')">2: No</span> <span class='texto_salto' id='var_sn2.2.salto'> &#8631; SN3</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN3</span>
<span class='pre_texto' id='pre_SN3'>¿Cuánto tiempo hace que consultó con un médico clínico o un especialista como cirujano, traumatólogo, ginecólogo, oculista, etc?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn3' name='var_sn3' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn3");' onKeyPress='PresionTeclaEnVariable("var_sn3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn3",event);' ></span>
</td><td colspan=3><li id='var_sn3__1'><span onclick="PonerOpcion('var_sn3','1')">1: Más de 1 mes pero menos de 6 meses</span></li>
<li id='var_sn3__2'><span onclick="PonerOpcion('var_sn3','2')">2: Hace mas de 6 meses pero menos de 1 año</span></li>
<li id='var_sn3__3'><span onclick="PonerOpcion('var_sn3','3')">3: De 1 a 2 años</span></li>
<li id='var_sn3__4'><span onclick="PonerOpcion('var_sn3','4')">4: Más de 2 años</span></li>
<li id='var_sn3__5'><span onclick="PonerOpcion('var_sn3','5','pre_SN6')">5: Nunca consultó</span> <span class='texto_salto' id='var_sn3.5.salto'> &#8631; SN6</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN4</span>
<span class='pre_texto' id='pre_SN4'>¿Cuál fue el motivo de la consulta? <span class='pre_aclaracion'>G-S De la ultima consulta si hizo más de una</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn4' name='var_sn4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn4");' onKeyPress='PresionTeclaEnVariable("var_sn4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn4",event);' ></span>
</td><td colspan=3><li id='var_sn4__1'><span onclick="PonerOpcion('var_sn4','1')">1: Problema de salud o enfermedad</span></li>
<li id='var_sn4__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn4','2')">2: Accidente</span> <span class='opc_aclaracion'>del hogar, de transito</span></li>
<li id='var_sn4__3'><span onclick="PonerOpcion('var_sn4','3')">3: Control de salud o prevención</span></li>
<li id='var_sn4__4'><span onclick="PonerOpcion('var_sn4','4')">4: Otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn4_esp' name='var_sn4_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn4_esp");' onKeyPress='PresionTeclaEnVariable("var_sn4_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn4_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn4__6'><span onclick="PonerOpcion('var_sn4','6')">6: Por la gripe</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN5</span>
<span class='pre_texto' id='pre_SN5'>¿Dónde realizo la consulta? <span class='pre_aclaracion'>G-S De la ultima consulta si hizo más de una</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn5' name='var_sn5' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn5");' onKeyPress='PresionTeclaEnVariable("var_sn5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn5",event);' ></span>
</td><td colspan=3><li id='var_sn5__1'><span onclick="PonerOpcion('var_sn5','1')">1: En un centro de salud o sala de salud</span> <span class='opc_aclaracion'>publico</span></li>
<li id='var_sn5__2'><span onclick="PonerOpcion('var_sn5','2')">2: En un consultorio de un hospital publico</span></li>
<li id='var_sn5__3'><span onclick="PonerOpcion('var_sn5','3')">3: En la sala de guardia de un hospital publico</span></li>
<li id='var_sn5__4'><span onclick="PonerOpcion('var_sn5','4')">4: En un consultorio del P. Medicos de cabecera</span></li>
<li id='var_sn5__5'><span onclick="PonerOpcion('var_sn5','5')">5: En un establecimiento de obra social</span></li>
<li id='var_sn5__6'><span onclick="PonerOpcion('var_sn5','6')">6: En un establecimiento privado</span></li>
<li id='var_sn5__7'><span onclick="PonerOpcion('var_sn5','7')">7: En un consultorio particular</span></li>
<li id='var_sn5__8'><span onclick="PonerOpcion('var_sn5','8')">8: En su domicilio</span></li>
<li id='var_sn5__9'><span onclick="PonerOpcion('var_sn5','9')">9: En otro lugar</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn5_esp' name='var_sn5_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn5_esp");' onKeyPress='PresionTeclaEnVariable("var_sn5_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn5_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN6</span>
<span class='pre_texto' id='pre_SN6'>En los últimos 30 días, ¿Realizó consultas con el dentista?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn6' name='var_sn6' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn6");' onKeyPress='PresionTeclaEnVariable("var_sn6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn6",event);' ></span>
</td><td colspan=3><li id='var_sn6__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn6','1')">1: Sí</span> <span class='opc_aclaracion'>cuantas</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>cuantas<td colspan=2><span class='respuesta'  title='numeros'><input id='var_sn6_cant' name='var_sn6_cant' type='number'  class='input_numeros' onblur='ValidarOpcion("var_sn6_cant");' onKeyPress='PresionTeclaEnVariable("var_sn6_cant",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn6_cant",event);' ></span>
 <span class='texto_salto' id='var_sn6_cant.salto'> &#8631; SN7</span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn6__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn6','2','pre_SN8')">2: No</span> <span class='texto_salto' id='var_sn6.2.salto'> &#8631; SN8</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN7</span>
<span class='pre_texto' id='pre_SN7'>¿Cuál fue el motivo de la consulta? <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn7' name='var_sn7' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn7");' onKeyPress='PresionTeclaEnVariable("var_sn7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn7",event);' ></span>
</td><td colspan=3><li id='var_sn7__1'><span onclick="PonerOpcion('var_sn7','1')">1: Por prevención</span></li>
<li id='var_sn7__2'><span onclick="PonerOpcion('var_sn7','2')">2: Por una urgencia</span></li>
<li id='var_sn7__3'><span onclick="PonerOpcion('var_sn7','3')">3: Por un tratamiento en curso</span></li>
<li id='var_sn7__4'><span onclick="PonerOpcion('var_sn7','4')">4: Por otro motivo</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn7_esp' name='var_sn7_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn7_esp");' onKeyPress='PresionTeclaEnVariable("var_sn7_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn7_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN8</span>
<span class='pre_texto' id='pre_SN8'>¿En los últimos 30 días, realizó estudios de laboratorio como análisis de sangre, orina o estudios por imágenes como radiografías o ecografías, etc?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn8' name='var_sn8' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn8");' onKeyPress='PresionTeclaEnVariable("var_sn8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn8",event);' ></span>
</td><td colspan=3><li id='var_sn8__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn8','1')">1: Sí</span> <span class='opc_aclaracion'>que estudios?</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>que estudios?<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn8_esp' name='var_sn8_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn8_esp");' onKeyPress='PresionTeclaEnVariable("var_sn8_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn8_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn8__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn8','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN9</span>
<span class='pre_texto' id='pre_SN9'>En los últimos 30 días ¿Usó medicamentos, incluyendo aspirinas, digestivos, vitaminas, etc?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn9' name='var_sn9' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn9");' onKeyPress='PresionTeclaEnVariable("var_sn9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn9",event);' ></span>
</td><td colspan=3><li id='var_sn9__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn9','1','pre_SN10')">1: Sí</span> <span class='texto_salto' id='var_sn9.1.salto'> &#8631; SN10</span>
</li>
<li id='var_sn9__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn9','2','pre_SN11')">2: No</span> <span class='texto_salto' id='var_sn9.2.salto'> &#8631; SN11</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN10</span>
<span class='pre_texto' id='pre_SN10'>¿Qué tipo de medicamentos usó en los últimos 30 días?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>Para el dolor en general <span class='opc_aclaracion'>de cabeza, musculares, menstural, etc</span><td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10a' name='var_sn10a' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10a");' onKeyPress='PresionTeclaEnVariable("var_sn10a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10a",event);' ></span>
</td><td colspan=3><li id='var_sn10a__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10a','1')">1: Sí</span></li>
<li id='var_sn10a__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10a','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para la tos, resfrío o gripe<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10b' name='var_sn10b' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10b");' onKeyPress='PresionTeclaEnVariable("var_sn10b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10b",event);' ></span>
</td><td colspan=3><li id='var_sn10b__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10b','1')">1: Sí</span></li>
<li id='var_sn10b__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10b','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para la alergia o asma<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10c' name='var_sn10c' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10c");' onKeyPress='PresionTeclaEnVariable("var_sn10c",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10c",event);' ></span>
</td><td colspan=3><li id='var_sn10c__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10c','1')">1: Sí</span></li>
<li id='var_sn10c__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10c','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para problemas gastrointestinales <span class='opc_aclaracion'>laxantes, digestivos, antiacidos, etc</span><td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10d' name='var_sn10d' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10d");' onKeyPress='PresionTeclaEnVariable("var_sn10d",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10d",event);' ></span>
</td><td colspan=3><li id='var_sn10d__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10d','1')">1: Sí</span></li>
<li id='var_sn10d__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10d','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Antibióticos<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10e' name='var_sn10e' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10e");' onKeyPress='PresionTeclaEnVariable("var_sn10e",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10e",event);' ></span>
</td><td colspan=3><li id='var_sn10e__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10e','1')">1: Sí</span></li>
<li id='var_sn10e__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10e','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para la presión alta o hipertensión<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10f' name='var_sn10f' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10f");' onKeyPress='PresionTeclaEnVariable("var_sn10f",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10f",event);' ></span>
</td><td colspan=3><li id='var_sn10f__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10f','1')">1: Sí</span></li>
<li id='var_sn10f__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10f','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para el corazón<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10g' name='var_sn10g' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10g");' onKeyPress='PresionTeclaEnVariable("var_sn10g",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10g",event);' ></span>
</td><td colspan=3><li id='var_sn10g__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10g','1')">1: Sí</span></li>
<li id='var_sn10g__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10g','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para el colesterol alto<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10h' name='var_sn10h' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10h");' onKeyPress='PresionTeclaEnVariable("var_sn10h",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10h",event);' ></span>
</td><td colspan=3><li id='var_sn10h__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10h','1')">1: Sí</span></li>
<li id='var_sn10h__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10h','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Para la depresión, ansiedad, estrés, insomnio<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10i' name='var_sn10i' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10i");' onKeyPress='PresionTeclaEnVariable("var_sn10i",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10i",event);' ></span>
</td><td colspan=3><li id='var_sn10i__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10i','1')">1: Sí</span></li>
<li id='var_sn10i__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10i','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Otros <span class='opc_aclaracion'>especifique</span><td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn10j' name='var_sn10j' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn10j");' onKeyPress='PresionTeclaEnVariable("var_sn10j",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10j",event);' ></span>
</td><td colspan=3><li id='var_sn10j__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10j','1')">1: Sí</span></li>
<li id='var_sn10j__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn10j','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1>especifique<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn10_j_esp' name='var_sn10_j_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn10_j_esp");' onKeyPress='PresionTeclaEnVariable("var_sn10_j_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn10_j_esp",event);' ></span>
</td><td colspan=4></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN11</span>
<span class='pre_texto' id='pre_SN11'>En los últimos 12 meses, ¿Estuvo internado/a?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn11' name='var_sn11' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn11");' onKeyPress='PresionTeclaEnVariable("var_sn11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn11",event);' ></span>
</td><td colspan=3><li id='var_sn11__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn11','1','pre_SN12')">1: Sí</span> <span class='texto_salto' id='var_sn11.1.salto'> &#8631; SN12</span>
</li>
<li id='var_sn11__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn11','2','pre_SN15')">2: No</span> <span class='texto_salto' id='var_sn11.2.salto'> &#8631; SN15</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN12</span>
<span class='pre_texto' id='pre_SN12'>¿Cuánto tiempo estuvo internado?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn12' name='var_sn12' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn12");' onKeyPress='PresionTeclaEnVariable("var_sn12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn12",event);' ></span>
</td><td colspan=3><li id='var_sn12__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn12','1')">1: Una noche</span></li>
<li id='var_sn12__2'><span onclick="PonerOpcion('var_sn12','2')">2: Mas de una noche</span> <span class='opc_aclaracion'>¿cuántas?</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>¿cuántas?<td colspan=2><span class='respuesta'  title='numeros'><input id='var_sn12_esp' name='var_sn12_esp' type='number'  class='input_numeros' onblur='ValidarOpcion("var_sn12_esp");' onKeyPress='PresionTeclaEnVariable("var_sn12_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn12_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn12__98'><span onclick="PonerOpcion('var_sn12','98')">98: Si estuvo internado menos de una noche consigne 98</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN13</span>
<span class='pre_texto' id='pre_SN13'>¿Cuál fue el motivo de la última internación? <span class='pre_aclaracion'>E-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn13' name='var_sn13' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn13");' onKeyPress='PresionTeclaEnVariable("var_sn13",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn13",event);' ></span>
</td><td colspan=3><li id='var_sn13__1'><span onclick="PonerOpcion('var_sn13','1')">1: Estudios o tratamiento de enfermedad sin intervención quirúrgica</span></li>
<li id='var_sn13__2'><span onclick="PonerOpcion('var_sn13','2')">2: Estudios o tratamiento de enfermedad con intervención quirúrgica</span></li>
<li id='var_sn13__3'><span onclick="PonerOpcion('var_sn13','3')">3: Atención del embarazo, parto o puerperio</span></li>
<li id='var_sn13__4'><span onclick="PonerOpcion('var_sn13','4')">4: Accidente, lesión</span> <span class='opc_aclaracion'>del hogar, de tránsito</span></li>
<li id='var_sn13__5' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn13','5')">5: Otros</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn13_otro' name='var_sn13_otro' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn13_otro");' onKeyPress='PresionTeclaEnVariable("var_sn13_otro",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn13_otro",event);' ></span>
</td><td colspan=1></td></tr>
</table>
<li id='var_sn13__6'><span onclick="PonerOpcion('var_sn13','6')">6: Por infección respiratoria</span> <span class='opc_aclaracion'>gripe, neumonía, bronquiolitis</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN14</span>
<span class='pre_texto' id='pre_SN14'>¿Estuvo internado/a en... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn14' name='var_sn14' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn14");' onKeyPress='PresionTeclaEnVariable("var_sn14",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn14",event);' ></span>
</td><td colspan=3><li id='var_sn14__1'><span onclick="PonerOpcion('var_sn14','1')">1: un establecimiento de obra social?</span></li>
<li id='var_sn14__2'><span onclick="PonerOpcion('var_sn14','2')">2: un establecimiento privado?</span></li>
<li id='var_sn14__3'><span onclick="PonerOpcion('var_sn14','3')">3: un hospital publico?</span></li>
<li id='var_sn14__4'><span onclick="PonerOpcion('var_sn14','4')">4: en otro lugar?</span> <span class='opc_aclaracion'>especificar</span></li>
<table><tr><td colspan=4 class=sangria><td colspan=1>especificar<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn14_esp' name='var_sn14_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn14_esp");' onKeyPress='PresionTeclaEnVariable("var_sn14_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn14_esp",event);' ></span>
</td><td colspan=1></td></tr>
</table>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN15</span>
<span class='pre_texto' id='pre_SN15'>¿Alguna vez un medico le diagnostico a usted una enfermedad que se extiende en el tiempo o que requiere tratamiento como las que se mencionan a contin <span class='pre_aclaracion'>G-M</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=1 class=sangria><td colspan=3>Alergia<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15a' name='var_sn15a' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15a");' onKeyPress='PresionTeclaEnVariable("var_sn15a",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15a",event);' ></span>
</td><td colspan=3><li id='var_sn15a__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15a','1')">1: Sí</span></li>
<li id='var_sn15a__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15a','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Artritis/ reumatismo<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15b' name='var_sn15b' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15b");' onKeyPress='PresionTeclaEnVariable("var_sn15b",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15b",event);' ></span>
</td><td colspan=3><li id='var_sn15b__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15b','1')">1: Sí</span></li>
<li id='var_sn15b__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15b','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Presión alta<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15c' name='var_sn15c' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15c");' onKeyPress='PresionTeclaEnVariable("var_sn15c",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15c",event);' ></span>
</td><td colspan=3><li id='var_sn15c__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15c','1')">1: Sí</span></li>
<li id='var_sn15c__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15c','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Infarto de miocardio<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15d' name='var_sn15d' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15d");' onKeyPress='PresionTeclaEnVariable("var_sn15d",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15d",event);' ></span>
</td><td colspan=3><li id='var_sn15d__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15d','1')">1: Sí</span></li>
<li id='var_sn15d__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15d','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Otras enfermedades del corazón o arteriales<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15e' name='var_sn15e' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15e");' onKeyPress='PresionTeclaEnVariable("var_sn15e",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15e",event);' ></span>
</td><td colspan=3><li id='var_sn15e__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15e','1')">1: Sí</span></li>
<li id='var_sn15e__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15e','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Enfisema o bronquitis crónica<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15f' name='var_sn15f' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15f");' onKeyPress='PresionTeclaEnVariable("var_sn15f",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15f",event);' ></span>
</td><td colspan=3><li id='var_sn15f__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15f','1')">1: Sí</span></li>
<li id='var_sn15f__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15f','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Asma<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15g' name='var_sn15g' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15g");' onKeyPress='PresionTeclaEnVariable("var_sn15g",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15g",event);' ></span>
</td><td colspan=3><li id='var_sn15g__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15g','1')">1: Sí</span></li>
<li id='var_sn15g__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15g','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Diabetes<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15h' name='var_sn15h' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15h");' onKeyPress='PresionTeclaEnVariable("var_sn15h",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15h",event);' ></span>
</td><td colspan=3><li id='var_sn15h__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15h','1')">1: Sí</span></li>
<li id='var_sn15h__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15h','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Enfermedades del hígado o vesícula biliar<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15i' name='var_sn15i' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15i");' onKeyPress='PresionTeclaEnVariable("var_sn15i",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15i",event);' ></span>
</td><td colspan=3><li id='var_sn15i__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15i','1')">1: Sí</span></li>
<li id='var_sn15i__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15i','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Gastritis/ úlcera<td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15j' name='var_sn15j' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15j");' onKeyPress='PresionTeclaEnVariable("var_sn15j",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15j",event);' ></span>
</td><td colspan=3><li id='var_sn15j__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15j','1')">1: Sí</span></li>
<li id='var_sn15j__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15j','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=3>Otra <span class='opc_aclaracion'>¿Cuál?</span><td colspan=1><span class='respuesta'  title='si_no'><input id='var_sn15k' name='var_sn15k' type='text'  class='input_si_no' onblur='ValidarOpcion("var_sn15k");' onKeyPress='PresionTeclaEnVariable("var_sn15k",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15k",event);' ></span>
</td><td colspan=3><li id='var_sn15k__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15k','1')">1: Sí</span></li>
<li id='var_sn15k__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn15k','2')">2: No</span></li>
</td></tr>
<tr><td colspan=1 class=sangria><td colspan=1>¿Cuál?<td colspan=2><span class='respuesta'  title='texto_libre'><input id='var_sn15k_esp' name='var_sn15k_esp' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_sn15k_esp");' onKeyPress='PresionTeclaEnVariable("var_sn15k_esp",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn15k_esp",event);' ></span>
</td><td colspan=4></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>SN16</span>
<span class='pre_texto' id='pre_SN16'>En líneas generales, ¿El estado de salud de _________ es... <span class='pre_aclaracion'>G-S</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_sn16' name='var_sn16' type='number'  class='input_opciones' onblur='ValidarOpcion("var_sn16");' onKeyPress='PresionTeclaEnVariable("var_sn16",event);' onKeyDown='PresionOtraTeclaEnVariable("var_sn16",event);' ></span>
</td><td colspan=3><li id='var_sn16__1'><span onclick="PonerOpcion('var_sn16','1')">1: excelente?</span></li>
<li id='var_sn16__2'><span onclick="PonerOpcion('var_sn16','2')">2: muy bueno?</span></li>
<li id='var_sn16__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn16','3')">3: bueno?</span></li>
<li id='var_sn16__4' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn16','4')">4: regular?</span></li>
<li id='var_sn16__5' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn16','5')">5: malo?</span></li>
<li id='var_sn16__6' style='white-space:nowrap;'><span onclick="PonerOpcion('var_sn16','6')">6: muy malo?</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>FILTRO_3</span>
<span class='pre_texto' id='pre_FILTRO_3'>CONFRONTE EDAD</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Mujeres menores de 14 años y TODOS los varones<td colspan=1><span class='respuesta'  title='filtro'><input id='var_filtro_3' name='var_filtro_3' type='text'  class='input_filtro' onblur='ValidarOpcion("var_filtro_3");' onKeyPress='PresionTeclaEnVariable("var_filtro_3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_filtro_3",event);' ></span>
 <span class='texto_salto' id='var_filtro_3.salto'> &#8631; MD1</span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Para mujeres de 14 años o más<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>S28</span>
<span class='pre_texto' id='pre_S28'>¿Tiene o tuvo hijos o hijas nacidos vivos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_s28' name='var_s28' type='number'  class='input_opciones' onblur='ValidarOpcion("var_s28");' onKeyPress='PresionTeclaEnVariable("var_s28",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s28",event);' ></span>
</td><td colspan=3><li id='var_s28__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_s28','1')">1: Sí</span></li>
<li id='var_s28__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_s28','2','pre_MD1')">2: No</span> <span class='texto_salto' id='var_s28.2.salto'> &#8631; MD1</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>S29</span>
<span class='pre_texto' id='pre_S29'>¿Cuántos hijos o hijas nacidos vivos tuvo en total?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_s29' name='var_s29' type='number'  class='input_numeros' onblur='ValidarOpcion("var_s29");' onKeyPress='PresionTeclaEnVariable("var_s29",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s29",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>S30</span>
<span class='pre_texto' id='pre_S30'>¿Cuántos hijos o hijas están actualmente vivos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='numeros'><input id='var_s30' name='var_s30' type='number'  class='input_numeros' onblur='ValidarOpcion("var_s30");' onKeyPress='PresionTeclaEnVariable("var_s30",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s30",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>S31</span>
<span class='pre_texto' id='pre_S31'>Año y mes de nacimiento del último hijo/a nacido vivo/a</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3>Año<td colspan=1><span class='respuesta'  title='anio'><input id='var_s31_anio' name='var_s31_anio' type='number'  class='input_anio' onblur='ValidarOpcion("var_s31_anio");' onKeyPress='PresionTeclaEnVariable("var_s31_anio",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s31_anio",event);' ></span>
</td><td colspan=3></td></tr>
<tr><td colspan=3>Mes<td colspan=1><span class='respuesta'  title='meses'><input id='var_s31_mes' name='var_s31_mes' type='number'  class='input_meses' onblur='ValidarOpcion("var_s31_mes");' onKeyPress='PresionTeclaEnVariable("var_s31_mes",event);' onKeyDown='PresionOtraTeclaEnVariable("var_s31_mes",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Identificación<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD1</span>
<span class='pre_texto' id='pre_MD1'>¿Tiene Ud. alguna dificultad de largo plazo para caminar, subir o bajar escalones?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md1' name='var_md1' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md1");' onKeyPress='PresionTeclaEnVariable("var_md1",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md1",event);' ></span>
</td><td colspan=3><li id='var_md1__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md1','1')">1: Sí</span></li>
<li id='var_md1__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md1','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD2</span>
<span class='pre_texto' id='pre_MD2'>¿Tiene Ud. alguna dificultad de largo plazo para mover uno o los dos brazos o las manos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md2' name='var_md2' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md2");' onKeyPress='PresionTeclaEnVariable("var_md2",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md2",event);' ></span>
</td><td colspan=3><li id='var_md2__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md2','1')">1: Sí</span></li>
<li id='var_md2__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md2','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD3</span>
<span class='pre_texto' id='pre_MD3'>¿Tiene Ud. alguna dificultad de largo plazo para agarrar objetos y/o sostener peso con una o las dos manos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md3' name='var_md3' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md3");' onKeyPress='PresionTeclaEnVariable("var_md3",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md3",event);' ></span>
</td><td colspan=3><li id='var_md3__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md3','1')">1: Sí</span></li>
<li id='var_md3__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md3','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD4</span>
<span class='pre_texto' id='pre_MD4'>¿Tiene Ud. alguna dificultad de largo plazo para levantarse, acostarse, mantenerse de pie o sentado?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md4' name='var_md4' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md4");' onKeyPress='PresionTeclaEnVariable("var_md4",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md4",event);' ></span>
</td><td colspan=3><li id='var_md4__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md4','1')">1: Sí</span></li>
<li id='var_md4__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md4','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD5</span>
<span class='pre_texto' id='pre_MD5'>¿Tiene Ud. alguna dificultad de largo plazo para ver, aún con anteojos o lentes puestos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md5' name='var_md5' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md5");' onKeyPress='PresionTeclaEnVariable("var_md5",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md5",event);' ></span>
</td><td colspan=3><li id='var_md5__1'><span onclick="PonerOpcion('var_md5','1')">1: Sí, es ciego</span></li>
<li id='var_md5__2'><span onclick="PonerOpcion('var_md5','2')">2: Sí, tiene disminución visual</span></li>
<li id='var_md5__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md5','3')">3: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD6</span>
<span class='pre_texto' id='pre_MD6'>¿Tiene Ud. alguna dificultad de largo plazo para oir aún usando audífonos o aparatos?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md6' name='var_md6' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md6");' onKeyPress='PresionTeclaEnVariable("var_md6",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md6",event);' ></span>
</td><td colspan=3><li id='var_md6__1'><span onclick="PonerOpcion('var_md6','1')">1: Sí, es sordo</span></li>
<li id='var_md6__2'><span onclick="PonerOpcion('var_md6','2')">2: Sí, tiene disminución auditiva</span></li>
<li id='var_md6__3' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md6','3')">3: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD7</span>
<span class='pre_texto' id='pre_MD7'>¿Tiene Ud. alguna dificultad de largo plazo para hablar o comunicarse, aún usando lengua de señas? <span class='pre_aclaracion'>Entender lo que dice otra persona o que otra persona entienda lo que Ud. está diciendo</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md7' name='var_md7' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md7");' onKeyPress='PresionTeclaEnVariable("var_md7",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md7",event);' ></span>
</td><td colspan=3><li id='var_md7__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md7','1')">1: Sí</span></li>
<li id='var_md7__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md7','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD8</span>
<span class='pre_texto' id='pre_MD8'>¿Tiene Ud. alguna dificultad de largo plazo para entender o aprender indicaciones sencillas? <span class='pre_aclaracion'>Memorizar, comprender, reproducir y/o ejecutar indicaciones de distinta índole, por ejemplo, como llegar a un lugar nuevo.) (Se incluyen personas con síndrome de down o deficiencias mentales o intelectuales</span></span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md8' name='var_md8' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md8");' onKeyPress='PresionTeclaEnVariable("var_md8",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md8",event);' ></span>
</td><td colspan=3><li id='var_md8__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md8','1')">1: Sí</span></li>
<li id='var_md8__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md8','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD9</span>
<span class='pre_texto' id='pre_MD9'>¿Tiene Ud. alguna dificultad de largo plazo para concentrarse y/o recordar cosas que le interesan?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md9' name='var_md9' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md9");' onKeyPress='PresionTeclaEnVariable("var_md9",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md9",event);' ></span>
</td><td colspan=3><li id='var_md9__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md9','1')">1: Sí</span></li>
<li id='var_md9__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md9','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD10</span>
<span class='pre_texto' id='pre_MD10'>¿Tiene Ud. alguna dificultad de largo plazo para atender por si mismo su cuidado personal, como levantarse o vestirse o comer?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md10' name='var_md10' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md10");' onKeyPress='PresionTeclaEnVariable("var_md10",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md10",event);' ></span>
</td><td colspan=3><li id='var_md10__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md10','1')">1: Sí</span></li>
<li id='var_md10__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md10','2')">2: No</span></li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD11</span>
<span class='pre_texto' id='pre_MD11'>¿Tiene Ud. alguna dificultad de largo plazo para realizar actividades que no le pregunté?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='opciones'><input id='var_md11' name='var_md11' type='number'  class='input_opciones' onblur='ValidarOpcion("var_md11");' onKeyPress='PresionTeclaEnVariable("var_md11",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md11",event);' ></span>
</td><td colspan=3><li id='var_md11__1' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md11','1','pre_MD12')">1: Sí</span> <span class='texto_salto' id='var_md11.1.salto'> &#8631; MD12</span>
</li>
<li id='var_md11__2' style='white-space:nowrap;'><span onclick="PonerOpcion('var_md11','2','pre_Fin')">2: No</span> <span class='texto_salto' id='var_md11.2.salto'> &#8631; Fin</span>
</li>
</td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_pre'>MD12</span>
<span class='pre_texto' id='pre_MD12'>¿Cuál?</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='texto_libre'><input id='var_md12' name='var_md12' type='text'  class='input_texto_libre' onblur='ValidarOpcion("var_md12");' onKeyPress='PresionTeclaEnVariable("var_md12",event);' onKeyDown='PresionOtraTeclaEnVariable("var_md12",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_OBS'>Observaciones</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup><tr><td colspan=3><td colspan=1><span class='respuesta'  title='observaciones'><input id='var_obs' name='var_obs' type='text'  class='input_observaciones' onblur='ValidarOpcion("var_obs");' onKeyPress='PresionTeclaEnVariable("var_obs",event);' onKeyDown='PresionOtraTeclaEnVariable("var_obs",event);' ></span>
</td><td colspan=3></td></tr>
</table>
<tr class='fila_pregunta'>
<td>
<span class='pre_texto' id='pre_Fin'>Fin del formulario</span>
<td><table id='interna_opciones'><colgroup><col><col><col><col><col><col><col><col></colgroup></table>
<tr class='fila_pregunta'>
<td colspan=2 class='cel_aclara'>
Fin de Cuestionario Individual	</table><input type='button' onclick='VolverDelFormulario();' value='Volver'>
	<script type="text/javascript">
	DesplegarVariableFormulario({"formulario":"I1","matriz":null});
	window.onunload=function(){ GuardarElFormulario(); /* alert('guardado 1'); */ }
	window.onbeforeunload=function(){ 
		if(GuardarElFormulario()){
			return "El formulario tiene modificaciones. Se perderan al cerrar. ¿Desea cerrar?";
		}
	}
	</script>
	

</body></html>