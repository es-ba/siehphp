<?php
// V 2.38
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('etoi17s2.manifest');
    echo $contenido;
}
?>