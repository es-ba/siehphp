<html>
<head>
<title></title>
</head>
<body>

<?php
echo "<br>   Message Sent OK</p>\n";
require_once('../class.phpmailer.php');

//require_once "../../../ajus/lo_imprescindible.php";
//include("class.smtp.php"); // optional, gets called from within class.phpmailer.php if not already loaded
echo "<br>   Message Sent OK</p>\n";
$mail = new PHPMailer(true); // the true param means it will throw exceptions on errors, which we need to catch
 
$mail->IsSMTP(); // telling the class to use SMTP

try {
  $mail->Host       = "smtp.buenosaires.gob.ar"; // SMTP server
  $mail->SMTPDebug  = 2;                     // enables SMTP debug information (for testing)
  $mail->SMTPAuth   = true;                  // enable SMTP authentication
  $mail->Host       = "smtp.buenosaires.gob.ar"; // sets the SMTP server
  $mail->Port       = 25;                    // set the SMTP port for the GMAIL server
  $mail->Username   = "alejandromunoz@buenosaires.gob.ar"; // SMTP account username
  $mail->Password   = "mu3690al";        // SMTP account password
  $mail->AddReplyTo('desarrollo_estadistica@buenosaires.gob.ar', "mio");
  $mail->AddAddress('negroalejandro@hotmail.com',"mio" );
  $mail->SetFrom('alejandromunoz@buenosaires.gob.ar', "mio");
  $mail->Subject = 'PHPMailer Test Subject via mail(), advanced';
  $mail->AltBody = 'To view the message, please use an HTML compatible email viewer!'; // optional - MsgHTML will create an alternate automatically
  $mail->MsgHTML(file_get_contents('contents.html'));
  $mail->AddAttachment('images/phpmailer.gif');      // attachment
  $mail->AddAttachment('images/phpmailer_mini.gif'); // attachment

  $mail->Send();
  echo "Message Sent OK</p>\n";
} catch (phpmailerException $e) {
  echo $e->errorMessage(); //Pretty error messages from PHPMailer
} catch (Exception $e) {
  echo $e->getMessage(); //Boring error messages from anything else!
}
?>

</body>
</html>