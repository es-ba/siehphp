<?php
// V 2.22
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('rpm2016.manifest');
    echo $contenido;
}
?>