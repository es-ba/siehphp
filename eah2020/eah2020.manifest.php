<?php
// v 2.43
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('eah2020.manifest');
    echo $contenido;
}
?>