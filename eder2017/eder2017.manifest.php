<?php
// V 2.37
if(basename($_SERVER["SCRIPT_NAME"])==basename(__FILE__)){
    header("Content-Type:text/cache-manifest");
    $contenido=file_get_contents('eder2017.manifest');
    echo $contenido;
}
?>