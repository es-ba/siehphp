<?php
include "lo_necesario.php";

IniciarSesion();
	// echo RespuestaEnviar(true,"se grabo satisfactoriamente por saltear vez");
	// die();
try{
	$sql='';
	$todo=json_decode($_REQUEST['todo'],true);
	Loguear('2011-11-01',var_export($todo,true));
	if(@$todo['poner_fin']){
		$db->ejecutar("SELECT fin_etapa_encuesta(:encuesta,:usuario,:codigo_de_fin)"
			, array(':encuesta'=>$todo['encuesta']
				, ':usuario'=>$usuario_logueado
				, ':codigo_de_fin'=>$todo['poner_fin']
				)
		);
		$rta['ok']=true;
		echo RespuestaEnviar(true,$rta);
		return true;
	}else{
		$db->beginTransaction();
		$pk_ud=$todo['pk_ud'];
		$grabandum=$formulario_matriz_a_tabla[$pk_ud['formulario'].'-'.(@$pk_ud['matriz']?:'')];
		$tabla="eah{$annio2d}_{$grabandum['sufijo_tabla']}";
		$campos_pk=implode(', ',array_keys($grabandum['campos_pk']));
		$valores_pk="";
		$coma="";
		$and="";
		$where_pk="";
		foreach($grabandum['campos_pk'] as $campo_tabla=>$variable){
			$valores_pk.=$coma.$db->quote($pk_ud[$variable]);
			$where_pk.="$and $campo_tabla=".$db->quote($pk_ud[$variable]);
			$coma=", ";
			$and=" and";
		}
		// si no existe el registro hay que crearlo:
		$campos_extra_insertar=", usuario";
		$valores_extra_insertar=", ".$db->quote($usuario_logueado);
		if(!$db->preguntar($sql="select 1 from $tabla where $where_pk")){
			if($grabandum['sufijo_tabla']=='viv_s1a1'){ // OJO Generalizar
				$campos_extra_insertar.=", participacion";
				$valores_extra_insertar.=", ".$db->quote($todo['rta_ud'][PREFIJO_ID_VARIABLE.'participacion']);
			}
			$db->ejecutar($sql="insert into $tabla ($campos_pk $campos_extra_insertar) values ($valores_pk $valores_extra_insertar)");
			$primera='primera';
		}else{
			$primera='segunda';
		}
		$asignaciones="usuario=".$db->quote($usuario_logueado);
		$coma=",";
		foreach($todo['rta_ud'] as $k => $v){
			if($k==PREFIJO_ID_VARIABLE.'T50a'){
				//break; // paramos en esta para ver si grababa. Si, grabo.
			}
			if(substr($k,0,strlen(PREFIJO_ID_VARIABLE))==PREFIJO_ID_VARIABLE){
				$asignaciones.=$coma.substr($k,strlen(PREFIJO_ID_VARIABLE)).'=';
				if($v==="" || $v===null){
					$asignaciones.="null";
				}else{
					$asignaciones.=$db->quote($v);
				}
				$coma=", ";
			}
		}
		$sql="UPDATE $tabla SET $asignaciones WHERE $where_pk";
		$sentencia=$db->ejecutar($sql);
		$filas_grabadas=$sentencia->rowCount();
		/* // por ahora:
		$f=fopen('errores.del.sql.txt','w');
		fwrite($f,"todo bien \n");
		fwrite($f,$sql);
		fwrite($f,"\n ---TODO--- \n");
		fwrite($f,$_REQUEST['todo']);
		fclose($f);
		// fin por ahora; */
		$rta=array();
		if(@$todo['fin_etapa']){
			$rta_cons=correr_consistencias(array('inc_nenc'=>$pk_ud['encuesta']),array('dentro de transaccion'=>true));
			// $rta_cons=array('ok'=>true, 'no resueltas'=>1);
			if(!$rta_cons['ok']){
				echo var_export($rta_cons,true);
			}else{
				if($rta_cons['no resueltas']==0){
					if($rta_cons['justificadas']==0){
						$codigo_de_fin=1;
					}else{
						$codigo_de_fin=2;
					}
				}else{
					$codigo_de_fin=3;
				}
				if($codigo_de_fin){
					$db->ejecutar("SELECT fin_etapa_encuesta(:encuesta,:usuario,:codigo_de_fin) from tem11 where encues=:encues and (fin_ingreso is null or :cod_fin<>3)"
						, array(':encuesta'=>$pk_ud['encuesta']
							, ':encues'=>$pk_ud['encuesta']
							, ':usuario'=>$usuario_logueado
							, ':codigo_de_fin'=>$codigo_de_fin
							, ':cod_fin'=>$codigo_de_fin
							)
					);
				}
				if($codigo_de_fin==1 || $codigo_de_fin==2 || $usuario_rol=='ingresador'){
					$rta['habilitar_boton_mandar_a'][3]=true;
				}else{
					$rta['habilitar_boton_mandar_a'][4]=Puede('finalizar_encuesta','mandar a campo');
					$rta['habilitar_boton_mandar_a'][5]=Puede('finalizar_encuesta','mandar a procesamiento');
					$rta['habilitar_boton_mandar_a'][6]=Puede('finalizar_encuesta','aceptar inconsistentes');
				}
			}
		}
		if($filas_grabadas==1){
			$rta['ok']=true;
			echo RespuestaEnviar(true,$rta);
			$db->commit();
		}else if($filas_grabadas<1){
			echo RespuestaEnviar(false,"Error durante la grabación por $primera vez de la encuesta para la tabla $tabla de clave ".json_encode($todo['pk_ud']));
			$db->rollBack();
		}else{
			echo RespuestaEnviar(false,"Error se intentaron actualizar múltiples registros (".$sentencia->rowCount().") durante la grabación por $primera vez de la encuesta para la tabla $tabla de clave ".json_encode($todo['pk_ud']));
			$db->rollBack();
		}
	}
}catch(Exception $ex){
	/*
	$f=fopen('errores.del.sql.txt','w');
	fwrite($f,$ex->getMessage()."\n");
	fwrite($f,$sql);
	fwrite($f,"\n ---TODO--- \n");
	fwrite($f,$_REQUEST['todo']);
	fclose($f);
	*/
	$db->rollBack();
	echo RespuestaEnviar(false,'Error durante la grabacion. Mensaje db: '.$ex->getMessage().' sql: '.$sql);
}
// Grabación de los estados en la tabla Respuestas
// si sigue andando lento descomentar este if:
// if(false)
{
try{
	$sql='';
	$db->beginTransaction();
	$estados_rta_ud=$todo['estados_rta_ud'];
	$encuesta=$pk_ud['encuesta'];
	$nhogar=$pk_ud['nhogar'];
	$miembro=(@$pk_ud['miembro'])?:(@$pk_ud['p0'])?:0;
	$ex_miembro=(@$pk_ud['ex_miembro'])?:0;
	$relacion=(@$pk_ud['relacion'])?:0;
	foreach($estados_rta_ud as $variable_js=>$estado){
		if(substr($variable_js,0,strlen(PREFIJO_ID_VARIABLE))==PREFIJO_ID_VARIABLE){
			$variable=substr($variable_js,strlen(PREFIJO_ID_VARIABLE));
			$db->ejecutar(<<<SQL
				UPDATE respuestas set res_estado=:estado
				  WHERE res_encuesta=:encuesta
					AND res_hogar=:hogar
					AND res_miembro=:miembro
					AND res_ex_miembro=:ex_miembro
					AND res_relacion=:relacion
					AND res_var=:variable
SQL
			, array(':estado'=>$estado
				, ':encuesta'=>$encuesta
				, ':hogar'=>$nhogar
				, ':miembro'=>$miembro
				, ':relacion'=>$relacion
				, ':ex_miembro'=>$ex_miembro
				, ':variable'=>$variable)
			);
		}
	}
	$db->commit();
}catch(Exception $ex){
	/*
	$f=fopen('errores.del.sql.txt','w');
	fwrite($f,$ex->getMessage()."\n");
	fwrite($f,$sql);
	fwrite($f,"\n ---TODO--- \n");
	fwrite($f,$_REQUEST['todo']);
	fclose($f);
	*/
	$db->rollBack();
	echo RespuestaEnviar(false,'Error durante la grabacion. Mensaje db: '.$ex->getMessage()/*.' sql: '.$sql*/);
}
}
?>