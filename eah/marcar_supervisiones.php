<?php
include "lo_necesario.php";
IniciarSesion();
if(@$_REQUEST['todo']){
	$parametros=json_decode($_REQUEST['todo']);
	$via_ajax=true;
}else{
	$parametros=json_decode($_REQUEST['cual']);
	$via_ajax=false;
}
$dominio=$parametros[0];
$lote=$parametros[1];
if($dominio!='c'){
	$str="No se puede marcar supervisiones para el dominio $dominio";
}elseif(!is_numeric($lote)){
	$str="Lote $lote tiene que ser numérico";
}else{
	try{
		$db->ejecutar("select marcar_tem11_a_supervisar($lote)");
		if($via_ajax){
			echo RespuestaEnviar(true,'ok');
			die();
		}
		$str=<<<HTML
			Listo<br>
<script>
history.go(-1);
</script>
HTML;
	}catch(Exception $e){
		$str="Hubo un error marcando superviones para el lote $lote.<br>";
		$str.="Posiblemente este queriendo asignarle una supervisi&oacute;n a una encuesta ya embolsada.<br>";
		$str.=$e->getMessage();
	}
}
if($via_ajax){
	echo RespuestaEnviar(false,$str);
}else{
	echo EnviarStrAlCliente($str);
}
?>