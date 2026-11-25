<?php
//UTF-8:SÍ
// $pdo_log_sql_hasta_fecha='2011-11-09';
if(date("Y-m-d H:i:s")<'2020-04-11 17:30'){
    ini_set('display_errors', 'On');
}

$loguear_ultimos_debug_trace=1;
$loguear_excepciones_hasta='2012-05-05';

// configuracion del SMTP que usa tedede/mail.php
$smtp_host='servidor.smtp.ejemplo';
$smtp_usuario='usuario@ejemplo';
// $smtp_from='remitente@ejemplo';        // opcional, por defecto es $smtp_usuario
$smtp_from_name="Nombre del remitente";   // opcional
$smtp_password='poner_la_clave_aqui';

?>