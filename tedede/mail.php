<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require_once("../tercera/PHPMailer_v6.9.3/src/Exception.php");
require_once("../tercera/PHPMailer_v6.9.3/src/PHPMailer.php");
require_once("../tercera/PHPMailer_v6.9.3/src/SMTP.php");

/* La configuracion del SMTP se define en el configuracion_local.php de cada aplicacion:
 *   $smtp_host      servidor SMTP
 *   $smtp_usuario   usuario (y direccion remitente, salvo que se defina $smtp_from)
 *   $smtp_password  clave del usuario
 *   $smtp_from      (opcional) direccion remitente, si es distinta de $smtp_usuario
 *   $smtp_from_name (opcional) nombre del remitente
 */
function enviarMail($dirEnviarA,$propietario,$texto, $subject){
    global $smtp_host,$smtp_usuario,$smtp_password,$smtp_from,$smtp_from_name;
    if(!$smtp_host || !$smtp_usuario || !$smtp_password){
        return "falta definir la configuracion del SMTP (smtp_host, smtp_usuario y smtp_password) en configuracion_local.php";
    }

    $mail = new PHPMailer();

    $mail->IsSMTP();
    $mail->From     = $smtp_from?:$smtp_usuario;
    $mail->FromName = $smtp_from_name?:'';
    $mail->Username = $smtp_usuario;
    $mail->Host     = $smtp_host;
    $mail->Mailer   = "smtp";
    $mail->Password = $smtp_password;
    $mail->SMTPAuth = true;

    $mail->Subject = $subject;
    $mail->Body    = $texto;
    $mail->AltBody = $texto;
    $mail->AddAddress($dirEnviarA, $propietario);


    if(!$mail->Send()){
        $mail->ClearAddresses();
        $mail->ClearAttachments();

        return "hubo un error enviando el mensaje a " . $propietario;

    }else{
        $mail->ClearAddresses();
        $mail->ClearAttachments();
        return true;
    }

}
?>