<?php 

include "lo_necesario.php";

IniciarSesion();

$parametros=json_decode($_REQUEST['todo'],TRUE);
$encuesta=$parametros['encuesta']+0;
$nhogar=(@$parametros['nhogar']+0);

if(Puede('eliminar','encuestas')){
	$param_sql=array(':encuesta'=>$encuesta);
	if($nhogar){
		$and_hogar = "and nhogar=:nhogar";
		$param_sql[':nhogar']=$nhogar;
	}else{
		$and_hogar = "";
	}
	$db->beginTransaction();
	foreach(array('md','un','i1','ex','fam','viv_s1a1') as $sufijo_tabla){
		$db->ejecutar(<<<SQL
			delete from eah{$annio2d}_{$sufijo_tabla} v where nenc=:encuesta $and_hogar 
SQL
		,$param_sql);
	}
	$db->commit();
	echo RespuestaEnviar(true,"encuesta $encuesta borrada");
}else{
	echo RespuestaEnviar(false,'no tiene permiso para eliminar encuestas');
}
	
function recorrer_cargar_encuesta($recorrido, $claves){	
global $db,$rta,$estructura;
	$parametros=array();
	foreach($recorrido['param_sql'] as $campo){
		$parametros[":$campo"]=$claves[$campo];
	}
	$cursor=$db->ejecutar($recorrido['sql'], $parametros);
	// para cada registro:
	while($fila=$cursor->fetchObject()){
		foreach($recorrido['nuevos_parametros'] as $campo_original=>$campo){
			if(is_numeric($campo_original)){
				$campo_original=$campo;
			}
			$claves[$campo]=$fila->{$campo_original};
		}
		// Para cada variable de los formularios que no dependen de los miembros:
		foreach($recorrido['formularios_matrices'] as $formulario=>$matriz){
			$ud=Armar_id_ud($claves,$formulario,$matriz);
			$rta[$ud]=array();
			foreach($estructura['formulario'][$formulario][$matriz] as $variable=>$definicion){
				if(!@$definicion['no_es_variable']){
					$campo=strtolower(substr($variable,strlen(PREFIJO_ID_VARIABLE)));
					$rta[$ud][$variable]=$fila->{$campo};
				}
			}
		}
		foreach($recorrido['hijos'] as $recorrido_hijo){
			recorrer_cargar_encuesta($recorrido_hijo, $claves);
		}
	}
}

function Armar_id_ud($claves,$formulario,$matriz=''){
	$rta=array('encuesta'=>$claves['encuesta'],'nhogar'=>$claves['nhogar'],'formulario'=>$formulario,'matriz'=>$matriz);
	if(@$claves['miembro']){
		$rta['miembro']=$claves['miembro'];
	}
	if(@$claves['ex_miembro']){
		$rta['ex_miembro']=$claves['ex_miembro'];
	}
	if(@$claves['relacion']){
		$rta['relacion']=$claves['relacion'];
	}
	return json_encode($rta);
}

?>