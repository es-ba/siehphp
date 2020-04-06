<?php 

include "lo_necesario.php";

IniciarSesion();

$parametros=json_decode($_REQUEST['todo'],TRUE);
$encuesta=$parametros['encuesta']+0;
$nhogar=(@$parametros['nhogar']+0);
$miembro=(@$parametros['miembro']+0);
$relacion=(@$parametros['relacion']+0);
$ex_miembro=(@$parametros['ex_miembro']+0);
$formulario=(@$parametros['formulario']);

if(Puede('eliminar','formularios')){
	$param_sql=array(':encuesta'=>$encuesta);
	$param_sql[':nhogar']=$nhogar;
	$param_sql[':miembro']=$miembro;
	$and_especifico = '';
	$tipo_miembro="miembro";
	
	if($formulario=='un'){
		$param_sql[':relacion']=$relacion;
		$and_especifico=' and relacion=:relacion';
		$array_formularios=array('un');
	}elseif($formulario=='ex'){
		$param_sql[':miembro']=$ex_miembro;
		$miembro=$ex_miembro;
		$tipo_miembro="ex_miembro";
		$array_formularios=array('ex');
	}elseif($formulario=='md'){
		$array_formularios=array('md');
	}elseif($formulario=='i1'){
		$array_formularios=array('un','i1');
	}elseif($formulario == 'fam'){
		//$tipo_miembro="p0";
		$array_formularios=array('un','md','i1','fam');
	}
	
	$db->beginTransaction();
	
	foreach($array_formularios as $sufijo_tabla){
	
	if($sufijo_tabla == 'fam'){
		$tipo_miembro="p0";
	}
	$db->ejecutar(<<<SQL
		delete from eah{$annio2d}_{$sufijo_tabla} where nenc=:encuesta and nhogar=:nhogar and $tipo_miembro=:miembro $and_especifico
SQL
	,$param_sql);
	}
		
	$db->commit();
	echo RespuestaEnviar(true,"formulario $sufijo_tabla del hogar $nhogar, miembro $miembro de la $encuesta ha sido borrado");
}else{
	echo RespuestaEnviar(false,'no tiene permiso para eliminar formularios');
}
	


?>