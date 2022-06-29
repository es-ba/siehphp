<?php
// /home/desadmin/yeah/alserver_eah2018_capa/eah2018/configuracion_local.php     
$esta_es_la_base_en_produccion=false;
$esta_es_la_base_de_capacitacion=true;
$loguear_ultimos_debug_trace=1;
$loguear_excepciones_hasta='2022-10-30';

$pdo_log_sql_hasta_fecha='2022-10-30';

global $parametros_db,$color_de_fondo_de_la_aplicacion,$ICON_APP,$detenido,$revisando_metadatos,$img_de_fondo_de_la_aplicacion,$CARGA_CAPACITACION,$user_auto_login;

$revisando_metadatos=true;
$user_auto_login='emilio';
$CARGA_CAPACITACION=true;

$ICON_APP='../eah2022/eah2022_icon_capa.png';

// $detenido=($_SERVER["REMOTE_ADDR"]=='10.32.72.153'?false:"DETENIDO. Adaptando las supervisiones");
$detenido=false;
$img_de_fondo_de_la_aplicacion='../tedede/capacitacion.png';

$debug_via_notepadPP=true;

$parametros_db->user='tedede_php';
$parametros_db->pass='44php55';
$parametros_db->base_de_datos='eah2022_capa_db';
$parametros_db->host='localhost';
$parametros_db->port='54312';

?>