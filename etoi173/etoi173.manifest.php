<?php
// v 2.43
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('etoi173.manifest');
    echo $contenido;
}
?>