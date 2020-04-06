<?php
// V empa171
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('empa171.manifest');
    echo $contenido;
}
?>