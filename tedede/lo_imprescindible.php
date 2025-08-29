<?php
//UTF-8:SÍ
/* 
   incluirlo en todos los archivos .php (pero incluirlo sin especificar la carpeta)
*/
date_default_timezone_set('America/Buenos_Aires');

require_once "../tercera/mersenne_twister.php";
use mersenne_twister\twister;

set_include_path(get_include_path() . PATH_SEPARATOR . dirname(__FILE__));


if(!isset($parametros_db)){
    $parametros_db=(object) array();
}
$parametros_db->user='tedede_php';
$parametros_db->pass='laclave';
$parametros_db->base_de_datos='tedede_db';
$parametros_db->host='server_yeah_db';
if(!isset($parametros_db->search_path)){
    $parametros_db->search_path='';
}
if(!isset($parametros_db->port)){
    $parametros_db->port='5432';
}

$ahora=new DateTime();
$hoy=new DateTime($ahora->format('Y-m-d'));

if(file_exists("../tedede/configuracion_local.php")){    
    echo <<<HTML
    <SPAN style='color:red'><b>
        <BR>Hay que <SPAN style='color:black'><big>SACAR</big></span> de la carpeta tedede el archivo </B><SPAN style='color:black'>configuracion_local.php</span><B>
        <BR>Cada aplicación debe usar su propia configuracion_local.php
        <BR>
        <BR>(recordar que es correcto que configuracion_local.php este ignorada en los commits)
        <BR>
        <BR>
    </b></span>
HTML;
    die();
}

$archivo_configuracion_local=(@$archivo_configuracion_local)?:"../{$GLOBALS['nombre_app']}/configuracion_local.php";

if(!file_exists($archivo_configuracion_local)){
    echo <<<HTML
        <BR>Hay que poner en la carpeta {$GLOBALS['nombre_app']} el archivo <SPAN style='color:red'><B>configuracion_local.php</B></span>
        <BR>Se puede usar como base configuracion_local_ejemplo.php
        <BR>
        <BR>(recordar que es correcto que configuracion_local.php este ignorada en los commits)
        <BR>
        <BR>
HTML;
    die();
}

$loguear_ultimos_debug_trace=0; //no cambiar acá, cambiarlo en configuración local
$loguear_excepciones_hasta='2000-12-01'; // no cambiar acá, cambiarlo en configuración local
Global $esta_es_la_base_en_produccion;
$esta_es_la_base_en_produccion=false;
$ICON_APP="../{$GLOBALS['nombre_app']}/{$GLOBALS['nombre_app']}_icon_desa.png";
$detenido=false;

$GLOBALS['login_dual']=(@$GLOBALS['login_dual'])?:false;

require_once $archivo_configuracion_local;

if($detenido){
    if(is_string($detenido)){
        echo $detenido;
    }else{
        echo "SISTEMA DETENIDO POR MANTENIMIENTO";
    }
    die() ;
}

if(!isset($GLOBALS['esquema_principal'])){
    $GLOBALS['esquema_principal']=$nombre_app;
}

$HTTP_USER_AGENT=((@$HTTP_USER_AGENT_LOCAL)?:@$_SERVER["HTTP_USER_AGENT"])?:'LOCAL_LDC';

$soy_un_ipad=isset($_COOKIE['soy_un_ipad'])?$_COOKIE['soy_un_ipad']!='no':strpos($HTTP_USER_AGENT,'iPad')>0 || strpos($HTTP_USER_AGENT,'Android')>0;

$_SESSION['modo_encuesta']=isset($_SESSION['modo_encuesta'])?$_SESSION['modo_encuesta']:'Completo';

/* modificado como estaba originalmente no como vino desde rama alternativa, hasta revisión */
class Exception_Tedede extends Exception {

}


global $rand_mt;

$rand_mt=new twister(rand(0,65535));

?>