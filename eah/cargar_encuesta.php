<?php 

include "lo_necesario.php";

IniciarSesion();

$parametros=json_decode($_REQUEST['todo'],TRUE);
if(@$parametros['lote']){
	$para_ipad=true;
	$cursor=$db->ejecutar(<<<SQL
		select encues from tem11 where lote=:lote
SQL
		, array(':lote'=>$parametros['lote'])
	);
	while($fila=$cursor->fetchObject()){
		$lista_de_encuestas_hogares[$fila->encues]=1;
		$lista_de_encuestas[]=$fila->encues;
	}
}else{
	$para_ipad=false;
	$lista_de_encuestas_hogares=array(
		$parametros['encuesta']+0 => (@$parametros['nhogar']+0)?:1
	);
}

if(!$para_ipad){
	$rta=array();
}
$formularios_elegibles=array();

foreach($lista_de_encuestas_hogares as $encuesta=>$nhogar){
  if($para_ipad){
	$con_abrir_encuesta=", :usu_usu::text as usuario_logueado, ''::text as razon_solo_lectura";
  }else{
	$con_abrir_encuesta=", abrir_encuesta(t.encues,(:usu_usu)::text) as razon_solo_lectura";
  }
  $cursor=$db->ejecutar(<<<SQL
	select t.*, v.nenc, v.nhogar, v.entrea $con_abrir_encuesta
	  from tem{$annio2d} t left join eah{$annio2d}_viv_s1a1 v on t.encues=v.nenc and :nhogar=v.nhogar
	  where t.encues=:encuesta 
SQL
					,array(':encuesta'=>$encuesta,':nhogar'=>$nhogar,':usu_usu'=>$usuario_logueado));
  $fila_tem=$cursor->fetchObject();
  if(!$fila_tem){
	$str=<<<HTML
		<h2>No existe la encuesta n&uacute;mero {$encuesta}</h2>
		<br>
		<input type='button' value='Ingresar otra' onclick="IrAPagina('elegir_vivienda.php');">
HTML;
	echo RespuestaEnviar(false,"no existe la encuesta ".htmlentities($encuesta));
  }else{
    if(!$fila_tem->nenc){
		$db->ejecutar(<<<SQL
			insert into eah{$annio2d}_viv_s1a1 (nenc, nhogar, participacion) values (:encuesta,:nhogar,participacion_segun_replica(:replica,20{$annio2d}));
SQL
					,array(':encuesta'=>$encuesta,':nhogar'=>$nhogar,':replica'=>$fila_tem->replica)
		);
	}
	// La encuesta existe
	// Vamos a mandar los datos para cada formulario
	$estructura=json_decode(str_replace(array('var estructura=',';//fin'),array('',''),file_get_contents('gen/estructura_yeah.js')),TRUE);
	$claves['encuesta']=$fila_tem->encues;
	if(!$para_ipad){
		$rta=array('id_proc'=>$fila_tem->id_proc
				, 'tarea_de_etapa'=>'');
	}
	if(!$fila_tem->fin_ingreso && Puede('ingresar encuestas')){
		$rta['tarea_de_etapa']='ingreso';
	}
	$rta['solo_lectura']=$fila_tem->razon_solo_lectura;
	$rta['comenzo_el_ingreso']=$fila_tem->entrea;
	Loguear('2011-10-28','aca tengo RTA '.var_export($rta,true).' -> '.$fila_tem->fin_ingreso .'&&'. Puede('ingresar encuestas').'-'.$usuario_rol);
	$recorrer=array(
		'sql'=><<<SQL
			select * from eah{$annio2d}_viv_s1a1 v 
				where nenc=:encuesta 
				order by nhogar
SQL
		, 'param_sql'=>array('encuesta')
		, 'nuevos_parametros'=>array('nhogar')
		, 'formularios_matrices'=>array('S1'=>'','A1'=>'')
		, 'hijos'=>array(array(
			'sql'=><<<SQL
				select f.*, i.*, t.* from eah{$annio2d}_fam f
					left join eah{$annio2d}_i1 i on i.nenc=f.nenc and i.nhogar=f.nhogar and i.miembro   =f.p0
					left join eah{$annio2d}_md t on t.nenc=f.nenc and t.nhogar=f.nhogar and t.miembro   =f.p0
					where f.nenc=:encuesta and f.nhogar=:nhogar
					order by f.p0
SQL
			, 'param_sql'=>array('encuesta','nhogar')
			, 'nuevos_parametros'=>array('p0'=>'miembro')
			, 'formularios_matrices'=>array('S1'=>'P','I1'=>'','MD'=>'')
			, 'hijos'=>array(array(
				'sql'=><<<SQL
				select f.* from eah{$annio2d}_un f
					where f.nenc=:encuesta and f.nhogar=:nhogar and f.miembro=:miembro
					order by f.relacion
SQL
				, 'param_sql'=>array('encuesta','nhogar','miembro')
				, 'nuevos_parametros'=>array('relacion')
				, 'formularios_matrices'=>array('I1'=>'U')
				, 'hijos'=>array()
			))
		)			
		,array(
			'sql'=><<<SQL
				select f.* from eah{$annio2d}_ex f
					where f.nenc=:encuesta and f.nhogar=:nhogar
					order by f.ex_miembro
SQL
			, 'param_sql'=>array('encuesta','nhogar')
			, 'nuevos_parametros'=>array('ex_miembro')
			, 'formularios_matrices'=>array('A1'=>'X')
			, 'hijos'=>array()
		))
	);
	recorrer_cargar_encuesta($recorrer, $claves);
  }
}
$rta['encuestas_cargadas']=@$lista_de_encuestas;
$rta['formularios_elegibles']=$formularios_elegibles;
file_put_contents('aca.txt',json_encode($rta));
echo RespuestaEnviar(true,$rta);
	
function recorrer_cargar_encuesta($recorrido, $claves){	
global $db,$rta,$estructura,$formularios_elegibles;
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
		foreach($recorrido['formularios_matrices'] as $formulario=>$matriz){
			$ud=Armar_id_ud($claves,$formulario,$matriz);
			$rta[$ud]=array();
			foreach($estructura['formulario'][$formulario][$matriz] as $variable=>$definicion){
				if(!@$definicion['no_es_variable']){
					$campo=strtolower(substr($variable,strlen(PREFIJO_ID_VARIABLE)));
					$rta[$ud][$variable]=@$fila->{$campo};
				}
			}
			$formularios_elegibles[$claves['encuesta']][$ud]=true;
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