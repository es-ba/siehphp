<?php
// V 2.33
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('empav31.manifest');
    echo $contenido;
}
?>