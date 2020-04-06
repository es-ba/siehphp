<?php
// V 1.06c
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('pp2012.manifest');
    echo $contenido;
}
?>