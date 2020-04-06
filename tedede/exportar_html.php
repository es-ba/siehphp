<?php
//UTF-8:SÍ
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
if(isset($_POST['cuadro'])){
    $date_default_timezone_set = date_default_timezone_set('America/Argentina/Buenos_Aires');
    header("Content-type: application/vnd.ms-excel; name='excel'");  
    header("Content-Disposition: filename=datos_exportados.xls");  
    header("Pragma: no-cache");  
    header("Expires: 0");  


    // echo utf8_decode ( $_POST['datos_a_enviar']);
    echo chr(239).chr(187).chr(191);
    echo $_POST['cuadro'];
}
?>