<?php
// V 2.07
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('lamp2015pp.manifest');
    echo $contenido;
}
?>