<?php
// v 3.00
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('same2014.manifest');
    echo $contenido;
}
?>