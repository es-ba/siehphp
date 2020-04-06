<?php
//No cambiar a UTF8
$esta_es_la_base_en_produccion=false; //no cambiar ac�, cambiarlo en configuracion_local.php

date_default_timezone_set("America/Buenos_Aires"); 

include "PDO_con_excepciones.php";
include "json_dumper.php";
include "comunes.php";
include "sesiones.php";
include "permisos.php";
include "grillas_yeah.php";
include "grilla_tabulados.php";
include "consistencias_soporte.php";
include "es_chrome.php";

define('PREFIJO_ID_VARIABLE',"var_");
define('PREFIJO_ID_PREGUNTA',"pre_");
define('SEPARADOR_VARIABLE_OPCION',"__");

$time_out_interactivo=45;
$limit_ins_inconsistencias=" LIMIT 100001"; // m�xima cantidad de inconsistencias generadas. 

$campos_datos_personales=array('nombre','apellido','interno','mail');

$campos_identificacion_completa_encuesta=array(
	  'encuesta'  =>array('ancho'=>90 , 'leyenda'=>utf8_encode('N� de encuesta'))
	, 'id_proc'   =>array('ancho'=>70 , 'leyenda'=>utf8_encode('ID de procesamiento'))
	, 'nhogar'    =>array('ancho'=>40 , 'leyenda'=>utf8_encode('Hogar n�'))
);
//kzk
$campos_identificacion_reabrir_encuesta=array(
	  'encuesta'  =>array('ancho'=>90 , 'leyenda'=>utf8_encode('N� de encuesta'))
	, 'id_proc'   =>array('ancho'=>70 , 'leyenda'=>utf8_encode('ID de procesamiento'))
	
);

$campos_identificacion_reabrir_encuesta_lista_despleglable = array('','reingreso','analisis de ingreso','procesamiento'); 



//kzk



//$user = 'yeahphp';
//$pass = '123yeah321';
$user = 'yeahowner';
$pass = 'laclave';
$base_de_datos = 'yeah_db';
$host = 'server_yeah_db';

$de_baja_por=FALSE; // Para dar de baja la entrada de los usuarios poner una leyenda en esta variable 
// EN configuracion_local.php
$ahora=new DateTime();
$hoy=new DateTime($ahora->format('Y-m-d'));

include "configuracion_local.php"; /*ATENCION
Si no existe cre� en tu m�quina un archivo con tres l�neas:
<?php
// NO SUBIR AL SVN. ESTO ES LO QUE PUEDE ESTAR DISTINTO EN CADA M�QUINA. EN ESPECIAL EN PRODUCCI�N
?>
y no lo subas al SVN!!!!
*/

if($de_baja_por){
	echo "<H1> El sistema fue suspendido momentaneamente por: $de_baja_por </h1>";
	die();
}
// Inidicalizamos la base de datos: 
try{
	$db=new PDO_con_excepciones("pgsql:dbname=$base_de_datos;host=$host", $user, $pass);
	// $db->ejecutar("SET search_path TO yeah_pr_2011, yeah, comun;")->execute();
    $db->log_hasta=@$GLOBALS['pdo_log_sql_hasta_fecha'];
}catch(Exception $e){
	file_put_contents("no_hay_base.txt",var_export($e,true));
	echo "<H1>La base fue dada de baja por mantenimiento no programado. Consultar</h1>";
	die();
}

$annio2d="11";

$tabla_de['S1']['']='viv_s1a1';
$tabla_de['A1']['']='viv_s1a1';
$tabla_de['A1']['X']='ex';
$tabla_de['S1']['P']='fam';
$tabla_de['I1']['']='i1';
$tabla_de['I1']['U']='un';
$tabla_de['MD']['']='md';


$formulario_matriz_a_tabla=array(
	'A1-'=>array(
		'sufijo_tabla'=>'viv_s1a1'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar')
	)
	, 'S1-'=>array(
		'sufijo_tabla'=>'viv_s1a1'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar')
	)
	, 'S1-P'=>array(
		'sufijo_tabla'=>'fam'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar','p0'=>'miembro')
	)
	, 'I1-'=>array(
		'sufijo_tabla'=>'i1'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar','miembro'=>'miembro')
	)
	, 'MD-'=>array(
		'sufijo_tabla'=>'md'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar','miembro'=>'miembro')
	)
	, 'A1-X'=>array(
		'sufijo_tabla'=>'ex'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar','ex_miembro'=>'ex_miembro')
	)
	, 'I1-U'=>array(
		'sufijo_tabla'=>'un'
		, 'campos_pk'=>array('nenc'=>'encuesta','nhogar'=>'nhogar','miembro'=>'miembro','relacion'=>'relacion')
	)
);

function EnviarStrAlCliente($contenido, $parametros=array()){
global $esta_es_la_base_en_produccion,$leyenda_en_prueba,$color_fondo;
	$que_hacer_al_tocar_el_logo="";
	if(Puede('cualquier cosa')){
		$display_borrar_todo='display';
	}else{
		$display_borrar_todo='none';
	}
	$avisarle_al_ipad_que_es_ipad="";
	if($esta_es_la_base_en_produccion){
		$color_fondo="";
		$leyenda_en_prueba="";
	}else{
		$color_fondo=@$color_fondo?:"style='background-color:#FFE2E2'";
		$leyenda_en_prueba=@$leyenda_en_prueba?:"<span style='position:absolute; top:40px; left:350px; font-size:300%; font-family: arial; font-weight:bold; color:Red'>EN&nbsp;PRUEBA</span>";
		if(isset($parametros['para ipad'])?$parametros['para ipad']:$_SESSION["ipad"]){
			$leyenda_en_prueba.="<img src=imagenes/tilde.png>";
			$avisarle_al_ipad_que_es_ipad=<<<HTML
<script>
	soy_un_ipad=true;
</script>
HTML;
		}
	}
	if(Puede('programador')){
		$que_hacer_al_tocar_el_logo=<<<HTML
			onclick='Mostrar_Errores_Provisorios_En("Errores_Provisorios")'
HTML;
	}
	$return_en_vez_de_echo=@$parametros['return en vez de echo'];
	if(@$parametros['borrar localStorage']){
		$borrar_si_corresponde_localStorage=<<<HTML
	<script>
		Borrar_LocalStorage(true);
	</script>
HTML;
	}else{
		$borrar_si_corresponde_localStorage='';
	}
	if(isset($parametros['casos de prueba'])){
		$casos_de_prueba=$parametros['casos de prueba'];
	}else{
		$casos_de_prueba='';
	}
	if($casos_de_prueba && isset($_REQUEST['probar'])){
		$script_casos_de_prueba="<script language='JavaScript' src='casos_prueba.js'></script><script language='JavaScript' src='$casos_de_prueba'></script>";
		$iniciar_casos_de_prueba="<div style='position:fixed; top:0; left:0; background-color:orange; index:100'>PARA PRUEBAS</div>";
		$iniciar_casos_de_prueba.="<script language='JavaScript'>\n probar_todo();\n</script>";
		$manifiesto='';
	}else{
		$script_casos_de_prueba="";
		$iniciar_casos_de_prueba="";
		$manifiesto="";
		if(@$parametros['para ipad']){
		   $manifiesto="manifest='manifiesto.manifest'";
		}
	}
	$otros_metas="";
	if(@$parametros['para ipad']){
		$otros_metas.="<meta name='viewport' content='user-scalable=no, width=device-width' />\n";
	}
	$str=(@$parametros['sin doctype']?"":"<!DOCTYPE HTML>\n");
	$str.=
	<<<HTML
<html $manifiesto lang="es-es">
<head>
	<meta charset="UTF-8">
	$otros_metas
	<script language="JavaScript" src="comunes.js"> </script>
	<script language="JavaScript" src="encuesta.js"> </script>
	<script language="JavaScript" src="gen/estructura_yeah.js"> </script>
	<script language='JavaScript' src='editor.js'></script>
	$script_casos_de_prueba
	<link rel="stylesheet" href="yeah.css" type="text/css" title="main" charset="utf-8">
	<link rel="stylesheet" href="ipad.css" type="text/css" title="main" charset="utf-8">
    <link rel="apple-touch-icon" href="imagenes/eah_icon.gif"/>
	<link rel="icon" type="image/gif" href="imagenes/eah_icon.gif" />
</head>
<body $color_fondo>
<table class=no_imprimir><tr>
	<td $que_hacer_al_tocar_el_logo >
	<a href='index.php'><img src='imagenes/logo_prototipo.png' title="Ir al Menu"></a></td>
	<td>
	<div id=div_para_portapapeles style="visibility:hidden; position:absolute; left:730px; top:20px;">
	<textarea id=para_portapapeles style="width:3px; color:white; background-color:white"></textarea>
	Exportado<img src=imagenes/mini_confirmado.png>
	<td>$leyenda_en_prueba
</table>
$avisarle_al_ipad_que_es_ipad
$borrar_si_corresponde_localStorage
$contenido
$iniciar_casos_de_prueba
</body></html>
HTML;
	if($return_en_vez_de_echo){
		return $str;
	}else{
		header("Content-Type:text/html");
		header("Cache-Control: no-store, no-cache, must-revalidate");
		header("Cache-Control: post-check=0, pre-check=0", false);
		header("Pragma: no-cache");
		echo $str;
	}	
}

function RespuestaEnviar($ok, $mensaje){
	Loguear(3,"por enviar respuesta: $mensaje");
	$rta=array();
	$rta['ok']=$ok;
	$rta['mensaje']=$mensaje;
	echo json_encode($rta);
}

?>