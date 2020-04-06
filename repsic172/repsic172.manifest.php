<?php
// V repsic172
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('repsic172.manifest');
    echo $contenido;
}
?>