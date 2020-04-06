<?php
// UTF8-SÍ
/* Para los registros directos de LOGS y otros procedimientos donde la respuesta tenga que ser inmediata y sin pasar por el framework
 * Por ahora solo se usa en:
 * - Registro de las pantallas login de navegadores que no son compatibles
 */
if(isset($_REQUEST['control_compatibiliad_pre_login'])){
    $incompatibilidad=$_REQUEST['registro_incompatibilidad'];
    if(isset($_REQUEST['html'])){
        $incompatibilidad.="\nFALLA en soporte AJAX";
        echo "<HTML><BODY><DIV>Navegador no soportado</DIV><PRE>\n";
        echo htmlspecialchars($incompatibilidad,ENT_NOQUOTES)."\n</PRE></BODY></HTML>";
    }else{
        echo "soportado";
    }
    if($_REQUEST['registro_incompatibilidad']){
        date_default_timezone_set('America/Argentina/Buenos_Aires');
        $ahora=new DateTime();
        $registro="\n###### ".$ahora->format('Y-m-d H:i:s')." addr ".$_SERVER["REMOTE_ADDR"]." local ".$_REQUEST["LOCAL_ADDR"]." UA ".$HTTP_USER_AGENT."\n";
        $registro.=$incompatibilidad;
        file_put_contents('../logs/pre_login_incompatibilidades.txt',$registro,FILE_APPEND);
    }
}

?>