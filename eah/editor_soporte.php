<?php 
include "lo_necesario.php";

IniciarSesion();

try{

	$parametros=json_decode($_REQUEST['todo'],true);
	$nombre_grilla=$parametros['grilla']; 
	$grilla=grilla($nombre_grilla);
	$tabla_q=$db->quote($grilla->nombre_tabla,'tabla'); 

	switch($parametros['accion']){
		case 'agregar registro provisorio':
			$sql1="INSERT INTO $tabla_q (".implode(', ',$grilla->pks());
			$sql2=") VALUES (".implode(', ',$grilla->sql_para_valores_insert_de_la_pk());
			$db->ejecutar($sql1.$sql2.")");
			// break, es correcto que no esté
		case 'leer grilla':
			Loguear(3,var_export($parametros,true));
			$filtro_para_lectura=@$parametros['filtro_para_lectura'];
			Loguear(3,'$filtro_para_lectura '.var_export($filtro_para_lectura,true));
			$datos_tabla=$grilla->obtener_datos($filtro_para_lectura);
			$rta['registros']=$datos_tabla;
			$rta['cantidad_registros']=count($datos_tabla);
			$rta['solo_lectura']=$grilla->campos_solo_lectura();
			$rta['campos_editables']=$grilla->campos_editables($filtro_para_lectura);
			$rta['puede_eliminar']=$grilla->puede_eliminar();
			$rta['puede_insertar']=$grilla->puede_insertar();
			$rta['boton_enviar']=$grilla->boton_enviar();
			$rta['remover_en_nombre_de_campo']=$grilla->remover_en_nombre_de_campo();
			$rta['pks']=$grilla->pks();
			$rta['joins']=$grilla->joins();
			echo RespuestaEnviar(true,$rta);
			break;
		case 'grabar campo':
			Loguear(3,'por grabar campo '.var_export($parametros,true));
			if(!Puede('grabar en',$nombre_grilla)){
				echo RespuestaEnviar(false,"No tiene permisos para modificar la tabla $nombre_grilla");
			}else{
				$campo=$parametros['campo'];
				$campo_q=$db->quote($campo,'campo');
				$sql_params[':nuevo_valor']=$parametros['nuevo_valor'];
				$sql_params[':viejo_valor']=$parametros['viejo_valor'];
				$where_pk=$grilla->clausula_where($parametros['pk'],$sql_params);
				if($nombre_grilla=='bolsas'){
					Loguear('2011-10-07', var_export($parametros['pk'],true));
					$where_pk=str_replace('bolsa=','bolsa_bolsa=',$where_pk);
					$pk="json_encode(array[bolsa_bolsa::text])";
					$tabla_q="bolsas";
				}else{
					$pk="json_encode(array[".implode("::text,",$grilla->pks())."::text])";
				}
				$db->beginTransaction();
				$campos_de_auditoria_para_update=$grilla->campos_de_auditoria_para_update();
				Editor_Grabar_Modificaciones($campo,'U',$parametros['nuevo_valor'],$parametros['viejo_valor']);
				$valores_devueltos=$db->preguntar_array(<<<SQL
					UPDATE $tabla_q SET $campo_q=:nuevo_valor $campos_de_auditoria_para_update 
					    $where_pk and $campo_q is not distinct from :viejo_valor 
						RETURNING $campo_q, 1 as ok, $pk as pk
SQL
					,$sql_params);
				if($valores_devueltos['ok']){
					if($db->ultima_consulta->rowCount()==1){
						$db->commit();
						$rta['valor_grabado']=$valores_devueltos[$campo];
						$rta['pk']=$valores_devueltos['pk'];
						echo RespuestaEnviar(true,$rta);
					}else{
						$db->rollBack();
						$rta['valor_grabado']=$valores_devueltos[$campo];
						$rta['pk']=$valores_devueltos['pk'];
						echo RespuestaEnviar(false,"Error, se han intentado modificar múltiples registros (".$db->ultima_consulta->rowCount()
							.") cuando debió ser uno. grabando {$parametros['nuevo_valor']} en $tabla_q $where_pk");
					}
				}else{
					$db->rollBack();
					unset($sql_params[':nuevo_valor']);
					unset($sql_params[':viejo_valor']);
					$valores_actuales=$db->preguntar_array("SELECT $campo_q as valor_actual, 1 as existe FROM $tabla_q $where_pk",$sql_params);
					if($valores_actuales['existe']){
						echo RespuestaEnviar(false,"el campo no se modificó porque otro usuario lo había modificado antes. El valor actual es='{$valores_actuales['valor_actual']}'. Refresque la pantalla");
					}else{
						echo RespuestaEnviar(false,'el registro ya no está en la base de datos quizás otro usuario lo modificó');
					}
				}
			}
			break;
		case 'eliminar registro':
			Loguear(3,'por eliminar registro '.var_export($parametros,true));
			if(!Puede('eliminar',$nombre_grilla)){
				echo RespuestaEnviar(false,'No tiene permisos para eliminar registros en la tabla $nombre_grilla');
			}else{
				$sql_params=array();
				$where_pk=$grilla->clausula_where($parametros['pk'],$sql_params);
				$log=$db->preguntar_array("SELECT * from $tabla_q $where_pk", $sql_params);
				$db->beginTransaction();
				Editor_Grabar_Modificaciones('*','D',null,json_encode($log));
				$valor_devuelto=$db->preguntar($sql="DELETE FROM $tabla_q $where_pk RETURNING 1",$sql_params);
				if($valor_devuelto){
					$db->commit();
					echo RespuestaEnviar(true,"ok");
				}else{
					$db->rollBack();
					echo RespuestaEnviar(false,"no se eliminó el registro, quizás ya haya sido eliminado por otro usuario");
				}
			}
			break;
		case 'leer anotaciones':
			if($nombre_grilla=='consistencias'){
				$rta=$db->preguntar_tabla_pk(<<<SQL
					SELECT '["'||anocon_con||'"]' as pk, 
						case 
							when max(anocon_momento)=max(case when anocon_autor='$usuario_logueado' then anocon_momento else null end) then ' mia'
							when max(anocon_momento)=max(case when usu_rol='$usuario_rol' then anocon_momento else null end) then ' nuestra'
							else (select anocon_autor from ano_con x where a.anocon_con=x.anocon_con and max(a.anocon_momento)=x.anocon_momento)
						end as mostrar,
						concato(anocon_autor||': '||anocon_anotacion||chr(10)) as title
					  FROM ano_con a inner join usuarios on usu_usu=anocon_autor
					  GROUP BY anocon_con
SQL
				);
				echo RespuestaEnviar(true,$rta);
			}else{
				echo RespuestaEnviar(false,"la tabla $nombre_grilla no tiene definidas anotaciones");
			}
			break;
		case 'abrir detalles y anotaciones':
			if(!($nombre_funcion=$grilla->armar_detalles())){
				echo RespuestaEnviar(false,"la tabla $nombre_grilla no tiene forma de mostrar detalles");
			}else{
				echo RespuestaEnviar(true,$nombre_funcion());
			}
			break;
		case 'anotar consistencia':
			$db->ejecutar(<<<SQL
				INSERT INTO ano_con (anocon_con, anocon_num, anocon_anotacion, anocon_autor)
					SELECT :consistencia, coalesce(max(anocon_num)+1,1), :anotacion, :autor
						FROM ano_con
						WHERE anocon_con=:consistencia_w
SQL
			, array(':consistencia'=>$parametros['consistencia'], ':consistencia_w'=>$parametros['consistencia'], ':anotacion'=>$parametros['anotacion'], ':autor'=>$usuario_logueado)
			);
			echo RespuestaEnviar(true,"");
			break;
		default:
			echo RespuestaEnviar(false,"Error interno de editor_soporte: no se conoce la accion {$parametros['accion']}");
	}
}catch(Exception $e){
	echo RespuestaEnviar(false,"error en la base de datos: ".$e->getMessage());
}

function Editor_Grabar_Modificaciones($campo,$operacion,$nuevo_valor,$viejo_valor){
global $db,$parametros,$grilla,$usuario_logueado;
	$pk_log=count($parametros['pk'])==1?$parametros['pk'][0]:json_encode($parametros['pk']);
	$db->ejecutar(<<<SQL
		INSERT INTO modificaciones (mod_tabla, mod_operacion, mod_pk, mod_campo, mod_actual, mod_anterior, mod_autor)
			VALUES (:tabla, :operacion, :pk, :campo, :actual, :anterior, :autor)
SQL
	, array(':tabla'=>$grilla->nombre_tabla, ':operacion'=>$operacion, ':pk'=>$pk_log, ':campo'=>$campo
		, ':actual'=>$nuevo_valor, ':anterior'=>$viejo_valor, ':autor'=>$usuario_logueado)
	);
}

?>