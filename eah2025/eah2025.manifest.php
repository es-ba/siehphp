<?php
// v 3.00
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('eah2025.manifest');
    echo $contenido;
}
?>