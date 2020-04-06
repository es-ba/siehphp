<?php
// V 1.36
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('eah2012.manifest');
    echo $contenido;
}
?>