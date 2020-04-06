<?php
  include "lo_necesario.php";
  IniciarSesion();
/*
    <H2>Novedades de la versión de 26/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>
			</ul>
*/  
  $str=<<<HTML
    <H2>Novedades de la versión de 2/11/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se agrega Ctrl-X para exportar directo a Excel (sin tener que copiar y pegar)
			<li>Se agregan los botones para finalizar encuesta y mandar a campo o a procesamiento luego de correr las inconsistencias
			<li>Se diferencia en los remitos la cantidad de hogares de la cantidad de formularios S1
			<li>Se puede acceder a ver las encuestas desde el botón [ i ]
			<li>El sistema ahora tontempla todas los tipos de consistencias cruzadas con variables de varias tablas 
				(menos las mezclas incompatibles, por ejemplo ex-miembros con módulo de discapacidad). 
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Arreglado el Ctrl-C del listado de variables sin ingresar.
			</ul>
    <H2>Novedades de la versión de 31/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Nuevo listado de variables sin ingresar
			<li>Réplica 8 no tiene recuperación.
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Arreglo de los saltos de T45 opc=3, T39_bis y T48
			<li>Se arreglan algunos NS/NC que faltaban
			</ul>
    <H2>Novedades de la versión de 27/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se agrega la fecha de entrega al recuperador
			<li>Permite cambiar datos de la TEM para mantenimiento de la muestra
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Arreglo del filtro 3 del MD.
			<li>Faltaban los campos esp de D8 y D9.
			</ul>
    <H2>Novedades de la versión de 26/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se pasan a entero los campos principales de la TEM. 
			<li>Se aclara en las inconsistenicias en línea si corresponden a un Error o una Advertencia.
			<li>El valor almacenado en las múltiple marcar es un 1 (aunque permite ingresar y visualiza el número de la opción). 
			<li>Se validan los valores válidos de rea y norea.
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Rea=4 pasa a estado 9. 
			<li><span class=opc_nsnc>&nbsp//&nbsp</span> en Form I1. Pregunta U1.
			<li>Arreglado el filtro 1 del MD para los que no asisten pero asistieron.
			<li>Arreglado el filtro del A1 para los hogares>1 en el bloque vivienda
			</ul>
    <H2>Novedades de la versión de 20/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>El supervisor de ingreso puede borrar encuestas
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Corregido el comportamiento de varias variables según lo visto en la capacitación a ingresadores del 19/10
			</ul>
    <H2>Novedades de la versión de 17/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Pantalla para los ingresadores (con ID de procesamiento)	
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Corregidos errores de permisos que no dejaban ingresar a los campos del módulo de seguimiento de las encuestas. 
			</ul>
	<H2>Novedades de la versión de 17/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Impresión de remitos definitiva (con ID de procesamiento)
			</ul>
    <H2>Novedades de la versión de 14/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Impresión de remitos provisoria
			<li>Controla los valores válidos en el campo REA
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>No se veía el piso en las grillas de seguimiento. 
			</ul>
    <H2>Novedades de la versión de 11/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Módulo para asignar bolsas
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>No se podían ingresar los campos Hog y Pobl en las grillas de seguimiento. 
			</ul>
    <H2>Novedades de la versión de 5/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se agrega el exportador. Ctrl-C
			<li>Se agrega la tabla de comunas para asignar recepcionistas, supervisores y subcoordinadores 
				para que el programa haga la asignación automática al cambiar de estado
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Dejó de funcionar F4 (hubo que reinstalar)
			</ul>
    <H2>Novedades de la versión de 3/10/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se agrega la logística de campo, para indicar qué encuestador, supervisor o recuperador tiene cada encuesta, 
				cuál fue el resutlado de su trabajo y en qué estado está la TEM.
			<li>Se agregan 2 ramas a la visualización de encuestas: asignación 
				y estado para poder tener un resumen general del estado del operativo 
				y poder hacer controles individuales.
			<li>Se agrega la tabla de personal de campo para encuestadores, recepcionistas, supervisores, recuperadores y subcoordinadores
			</ul>
    <H2>Novedades de la versión de 28/9/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se incorpora el formulario MD
			<li>Se implementan los filtros
			<li>Permite ver la TEM a partir de 3 ramas posibles de apertura. 
			</ul>
    <H2>Novedades de la versión de 15/9/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Se agregan columnas a la lista de consistencias. <b>Activa</b> para indicar si se va a usar o no. 
				<b>Válida</b> que indica si se ha compilado
			<li>El administrador de consistencias permite compilar y ver los errores de cada una
			</ul>
    <H2>Novedades de la versión de 13/9/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Permite ver la estructura de los formularios
			<li>Hay un módulo provisorio de prueba de ingreso de encuestas
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>El programa no permitía acceder a las anotaciones de las consistencias después de reordenar la tabla. 
			<li>El programa mostraba los botones para borrar aún a en las tablas en que no estaba permitido.
			</ul>
    <H2>Novedades de la versión de 6/9/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Está listo el programa para que los ingresadores prueben
			<li>Se agregan los usuarios para los temáticos y sectorialistas para revisar las consistencias.
			</ul>
    <H2>Novedades de la versión de 2/9/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>El programa permite a los temáticos confirmar el texto de explicación de las consistencias en una columna adhoc 
			<li>Muestra durante 3 segundos con un tilde <img src=imagenes/mini_confirmado.png> la confirmación del dato guardado 
			</ul>
    <H2>Novedades de la versión de 30/8/2011</h2>
		<H3>Nueva funcionalidad</h3>
			<ul>
			<li>Lista de variables involucradas en las consistencias (muestra las que tienen error)
			<li>Permite agregar anotaciones a las consistencias
			</ul>
		<H3>Corrección de errores</h3>
			<ul>
			<li>Al entrar en el campo anotaciones mostraba el signo indicador de error <img src=imagenes/mini_Error.png>
			</ul>
    <H2>Novedades de la versión de 29/8/2011</h2>
		<H3>Se instala la primera versión</h3>
			<ul>
			<li>El sistema permite administrar consistencias (crear nuevas, modificar existentes, dar de baja)
			<li>El sistema muestra la lista de variables que forman parte de los cuestionarios
			<li>Andrea Gil es la primera usuaria
			</ul>
HTML;
  EnviarStrAlCliente($str);
  
?>