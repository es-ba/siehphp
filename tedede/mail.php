<?php
require("../tercera/PHPMailer_v5.1/class.phpmailer.php");

function enviarMail($dirEnviarA,$propietario,$texto, $subject){

    $mail = new phpmailer();

    $mail->IsSMTP();
    $mail->From     = "desarrollo_estadistica@buenosaires.gob.ar";
    $mail->FromName = "Desarrollo Estadística";
    $mail->Username = "desarrollo_estadistica@buenosaires.gob.ar";
    $mail->Host     = "smtp.buenosaires.gob.ar";
    $mail->Mailer   = "smtp";
    $mail->Password ="Ax2486Xa";
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