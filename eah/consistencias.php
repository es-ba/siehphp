<?php
include "lo_necesario.php";
IniciarSesion();

$todo=@json_decode($_REQUEST['todo'],true);
$paso=0;
$encuesta=null;

$mostrando_progreso=!$todo;
$cual=@$_REQUEST['cual'];
if($cual && $cual[0]=='['){
	$cual=json_decode($cual);
	$cual=$cual[0];
}

$and_cual="";
$and_encuesta="";

if($mostrando_progreso){
	$str=<<<HTML
	<h2>Compilador de consistencias</h2>
HTML;
	$str_script=<<<JS
	<script>
		/*Y_LUEGO*/
		/*FUNCION*/
	</script>
JS;
}else{
	$cual=@$todo['cual']?:null;
	if($cual){
		$and_cual=' and con_con='.$db->quote($cual);
	}
	$encuesta=@$todo['encuesta']?:null;
	if($encuesta){
		try{
			$rta=correr_consistencias(array('encuesta'=>$encuesta));
			echo RespuestaEnviar(true,$rta);
		}catch(Exception $e){
			echo RespuestaEnviar(false,"error al correr las consistencias: ".$e->getMessage());
		}
		die();
	}
}

function Mostrar_Progreso_o_procesar($titulo, $receptaculo='innerText', $tipica_funcion_luego=false){
global $str,$str_script,$mostrando_progreso,$todo,$paso,$cual;
	if($mostrando_progreso){
		$paso++;
		$titulo_escapado=json_encode($titulo);
		$cual_escapado=json_encode($cual);
		$str.="<p>$titulo <span id=$titulo_escapado></span></p>\n";
		$tipica_funcion_luego=$tipica_funcion_luego?:<<<JS
			var ele=elemento_existente($titulo_escapado);
			ele.textContent='...';
			Enviar('consistencias.php', {que:$titulo_escapado, cual:$cual_escapado}
				, function(mensaje){
					ele.$receptaculo=mensaje;
					/*Y_LUEGO*/
				}
				, function(mensaje){
					ele.textContent=mensaje;
					ele.style.backgroundColor='Orange';
				}
				, true
			);
JS;
		$str_script=str_replace("/*Y_LUEGO*/","setTimeout('proceso_paso{$paso}();',100);",$str_script);
		$str_script=str_replace("/*FUNCION*/", <<<JS
			function proceso_paso{$paso}(){
				$tipica_funcion_luego
			}
			/*FUNCION*/
JS
		, $str_script);
		return false; // no debo procesar, estoy mostrando la página que muestra progreso
	}
	if($todo['que']===$titulo){
		return true; // es lo que quiero procesar
	}else{
		return false; // estoy procesando pero no esto
	}
}

if(Mostrar_Progreso_o_procesar('Regenerando consistencias')){
	try{
		$empezo=time();
		if($cual){
			$where_sele="WHERE con_con=".$db->quote($cual);
			$where_blanqueo=$where_sele;
		}else{
			$where_sele="WHERE con_activa";
			$where_blanqueo="";
		}
		$db->ejecutar(<<<SQL
			UPDATE consistencias SET con_valida=false, con_error_compilacion=null, con_junta=null, con_expresion_sql=null $where_blanqueo
SQL
		);
		$cursor=$db->ejecutar(<<<SQL
			SELECT con_con, con_precondicion, con_postcondicion, con_rel, con_rev, con_junta, con_expresion_sql
			    , con_ignorar_nulls
				, max(convar_orden) as max_var_orden
				, max(case coalesce(mat_tabla_destino,for_tabla_destino,'_viv_s1a1')
						when '_viv_s1a1' then 1
						when '_fam' then 2
						when '_i1' then 3
						else 0 end) num_tabla_hasta_i1
				, sum(case coalesce(mat_tabla_destino,for_tabla_destino) when '_md' then 1 else 0 end) as con_tabla_md
				, sum(case coalesce(mat_tabla_destino,for_tabla_destino) when '_un' then 1 else 0 end) as con_tabla_un
				, sum(case coalesce(mat_tabla_destino,for_tabla_destino) when '_ex' then 1 else 0 end) as con_tabla_ex
				, convar_enc
			  FROM consistencias left join con_var on con_con=convar_con and convar_enc='EAH20{$annio2d}'
				left join formularios on for_enc='EAH20{$annio2d}' and for_for=convar_for
				left join matrices on mat_enc='EAH20{$annio2d}' and mat_for=convar_for and mat_mat=convar_mat
			  $where_sele
			  GROUP BY convar_enc, con_con, con_precondicion, con_postcondicion, con_rel, con_rev, con_junta, con_expresion_sql, con_ignorar_nulls
			  ORDER BY con_con
SQL
		);
		$cant_validas=0;
		$cant_invalidas=0;
		$cant_con_error=0;
		$con_con='';
		while($fila=$cursor->fetchObject() and time()<$empezo+$time_out_interactivo){
			$con_con=$fila->con_con;
			$poner_junta=null;
			$poner_error_compilacion=null;
			$poner_expresion_sql=null;
			$poner_clausula_from=null;
			$poner_error_compilacion=null;
			$cant_tablas_especiales=($fila->con_tabla_ex>0?1:0)+($fila->con_tabla_md>0?1:0)+($fila->con_tabla_un>0?1:0);
			/*
			if($fila->min_format==='' || !$a_tabla_min || !$a_tabla_max){
				$poner_error_compilacion='¡Hay variables incorrectas!';
				$poner_valida=false;
			
			}else 
			*/
			if($fila->con_tabla_ex>0 && $fila->num_tabla_hasta_i1>1){
				$poner_error_compilacion="No se pueden mezclar variables de la matriz de ex miembros con datos de miembros";
				$poner_valida=false;
			}else if($fila->con_tabla_ex>0 && $fila->con_tabla_md>0){
				$poner_error_compilacion="No se pueden mezclar variables de la matriz de ex miembros con el modulo de discapacidad";
				$poner_valida=false;
			}else if($fila->con_tabla_ex>0 && $fila->con_tabla_un>0){
				$poner_error_compilacion="No se pueden mezclar variables de la matriz de ex miembros con la matriz de uniones";
				$poner_valida=false;
			}else if($fila->con_tabla_md>0 && $fila->con_tabla_un>0){
				$poner_error_compilacion="No se pueden mezclar variables del modulo de discapacidad con la matriz de uniones";
				$poner_valida=false;
			}else{
				if($fila->con_rel=='=>'){
					if(!$fila->con_precondicion){
						$poner_expresion_sql="({$fila->con_postcondicion}) is not true";
					}else{
						$poner_expresion_sql="({$fila->con_precondicion}) and ({$fila->con_postcondicion}) is not true";
					}
				}else{
					$poner_expresion_sql="({$fila->con_precondicion}) is true is distinct from (({$fila->con_postcondicion}) is true)";
				}
				$poner_expresion_sql=strtolower($poner_expresion_sql);
				if(strpos($poner_expresion_sql,"'")!==false){
					$poner_error_compilacion='¡La expresión tiene apostrofes!';
					$poner_valida=false;
					$poner_expresion_sql="";
				}else{
					$join_hogar1=" inner join (select nenc,nhogar,v2,v2_esp,v4,v5,v5_esp,v6,v7,v12 from eah{$annio2d}_viv_s1a1 where nhogar=1) ah1 on ah1.nenc = t.encues)";
					$poner_clausula_from=" ((select encues, estado, replica from tem{$annio2d}) t inner join (select nenc,participacion,entrea,razon1,razon2_1,razon2_2,razon2_3,razon2_4,razon2_5,razon2_6,razon2_7,razon2_8,razon2_9,razon3,nhogar,miembro,v1,total_h,total_m,c_enc,n_enc,c_recu,n_recu,c_recep,n_recep,c_sup,n_sup,respond,nombrer,f_realiz_o,h1,h2,h2_esp,h3,h4,h4_tipot,h4_tel,h20_1,h20_2,h20_4,h20_5,h20_6,h20_7,h20_8,h20_10,h20_15,h20_11,h20_12,h20_13,h20_16,h20_17,h20_18,h20_19,h20_20,h20_14,h20_esp,h20_99,x5,x5_tot,h30_tv,h30_hf,h30_la,h30_vi,h30_ac,h30_dvd,h30_mo,h30_pc,h30_in,obs,usuario,log,tipo_h,encreali,f_realiz,telefono,s1a1_obs from eah{$annio2d}_viv_s1a1) a on a.nenc = t.encues and a.entrea not in (2,95)$join_hogar1";
					$poner_junta="s1a1";
					if($fila->num_tabla_hasta_i1>1){
						$poner_clausula_from.=" inner join eah{$annio2d}_fam f on a.nenc=f.nenc and a.nhogar=f.nhogar";
						$poner_junta="fam";
					}
					if($fila->num_tabla_hasta_i1>2){
						$poner_clausula_from.=" inner join eah{$annio2d}_i1 i on f.nenc=i.nenc and f.nhogar=i.nhogar and f.p0=i.miembro and (participacion=1 or (participacion>1 and p7<>3))";
						$poner_junta="i1";
					}
					if($fila->con_tabla_ex>0){
						$poner_clausula_from.=" inner join eah{$annio2d}_ex e on e.nenc=a.nenc and e.nhogar=a.nhogar ";
						$poner_junta="ex";
					}
					if($fila->con_tabla_md>0){
						$poner_clausula_from.=" inner join eah{$annio2d}_md d on ";
						if($fila->num_tabla_hasta_i1>1){
							$poner_clausula_from.="d.nenc=f.nenc and d.nhogar=f.nhogar and d.miembro=f.p0 and d.razon_no_realizada is null";
							
						}else{
							$poner_clausula_from.="d.nenc=a.nenc and d.nhogar=a.nhogar and d.razon_no_realizada is null";
						}
						$poner_junta="md";
					}
					if($fila->con_tabla_un>0){
						$poner_clausula_from.=" inner join eah{$annio2d}_un u on ";
						if($fila->num_tabla_hasta_i1>1){
							$poner_clausula_from.="u.nenc=f.nenc and u.nhogar=f.nhogar and u.miembro=f.p0";
						}else{
							$poner_clausula_from.="u.nenc=a.nenc and u.nhogar=a.nhogar";
						}
						$poner_junta="un";
					}
					$poner_valida=null;
				}
				$poner_expresion_sql=Acomodar_Expresion($poner_expresion_sql,$fila->con_ignorar_nulls);
			}
			$db->beginTransaction();
			$db->ejecutar(<<<SQL
				UPDATE consistencias 
					SET con_valida=:con_valida, con_junta=:con_junta, con_clausula_from=:con_clausula_from
						, con_expresion_sql=:con_expresion_sql 
						, con_error_compilacion=:con_error_compilacion
						, con_ultima_variable=(select var_var from variables where var_enc=:var_enc and var_orden=:var_orden)
					WHERE con_con=:con_con
SQL
				,array(':con_valida'=>$poner_valida
					, ':con_junta'=>$poner_junta
					, ':con_clausula_from'=>$poner_clausula_from
					, ':con_expresion_sql'=>$poner_expresion_sql
					, ':con_error_compilacion'=>$poner_error_compilacion
					, ':con_con'=>$fila->con_con
					, ':var_enc'=>$fila->convar_enc
					, ':var_orden'=>$fila->max_var_orden)
			);
			if($db->ultima_consulta->rowCount()==1){
				$db->commit();
				if($poner_valida===false){
					$cant_invalidas++;
				}else{
					$cant_validas++;
				}
			}else{
				$db->rollBack();
				$cant_con_error++;
				throw new Exception("ERRORES: varios updates (".$db->ultima_consulta->rowCount().") armando consistencias para ,array(':con_valida'=>$poner_valida, ':con_junta'=>$poner_junta, ':con_expresion_sql'=>$poner_expresion_sql, ':con_con'=>$fila->con_con));");
			}
		}
		if(!$fila){
			$hasta="todas";
		}else{
			$hasta="hasta $con_con";
		}
		echo RespuestaEnviar(true,"procesadas $hasta. $cant_validas procesadas, $cant_invalidas no contempladas con los métodos actuales, $cant_con_error con error. Demoro ".(time()-$empezo));
	}catch(Exception $e){
		echo RespuestaEnviar(false,"Error: ".$e->getMessage());
	}
}

if(Mostrar_Progreso_o_procesar('Probando si las consistencias compilan')){
	try{
		$cursor=$db->ejecutar(<<<SQL
			SELECT *
			  FROM consistencias 
			  WHERE con_activa $and_cual AND (con_valida or con_valida is null)
			  ORDER BY con_con
SQL
		);
		$cant_compilan=0;
		$cant_saltan=0;
		$cant_no_compilan=0;
		$con_con='';
		$empezo=time();
		while($fila=$cursor->fetchObject() and time()<$empezo+$time_out_interactivo){
			$con_con=$fila->con_con;
			$sql="SELECT count(*) FROM {$fila->con_clausula_from} WHERE ({$fila->con_expresion_sql})";
			try{
				$cuantas=$db->preguntar($sql);
				$cant_compilan++;
				if($cuantas){
					$cant_saltan++;
				}
				$poner_valida=true;
				$con_error_compilacion=null;
			}catch(Exception $e){
				$cant_no_compilan++;
				$con_error_compilacion=(@$e->getMessage())?:$con_error_compilacion;
				if(is_array($con_error_compilacion)){
					$con_error_compilacion=(@$con_error_compilacion[2])?:$con_error_compilacion;
				}
				$poner_valida=false;
			}
			$db->beginTransaction();
			$db->ejecutar("UPDATE consistencias SET con_error_compilacion=:con_error_compilacion, con_valida=:con_valida WHERE con_con=:con_con"
				,array(':con_error_compilacion'=>$con_error_compilacion, ':con_valida'=>$poner_valida, ':con_con'=>$fila->con_con));
			if($db->ultima_consulta->rowCount()==1){
				$db->commit();
			}else{
				$db->rollBack();
				throw new Exception("ERRORES: varios updates (".$db->ultima_consulta->rowCount().") armando consistencias para ,array(':con_con'=>$fila->con_con));");
			}
		}
		if(!$fila){
			$hasta="todas";
		}else{
			$hasta="hasta $con_con";
		}
		echo RespuestaEnviar(true,"procesadas $hasta. probadas: $cant_compilan compilan (de esas $cant_saltan saltan) y $cant_no_compilan no compilan. Demoro ".(time()-$empezo));
	}catch(Exception $e){
		Loguear(3,var_export($con_error_compilacion,true));
		echo RespuestaEnviar(false,"Error: procesando {$con_con}".$e->getMessage());
	}
}

if($cual and Mostrar_Progreso_o_procesar('Datos de la consistencia','innerHTML')){
	try{
		$cursor=$db->ejecutar(<<<SQL
			SELECT *
			  FROM consistencias 
			  WHERE TRUE $and_cual 
SQL
		);
		$str="<table class='editor_tabla'>";
		$grilla=new Grilla_consistencias();
		$filtro_para_lectura="";
		if($fila=$cursor->fetchObject()){
			foreach($grilla->campos_a_listar("") as $campo){
				$titulo=str_replace('_',' ',substr($campo,4));
				$str.="<tr><td style='background-color:#F0E0C0'>$titulo<td style='max-width:600px'>";
				if($campo=='con_error_compilacion'){
					$str.="<pre>{$fila->{$campo}}</pre>";
				}else{
					$str.=htmlspecialchars(@$fila->{$campo});
				}
				$str.="</tr>";
			}
			$str.="</table>";
		}else{
			$str="sin datos";
		}
		echo RespuestaEnviar(true,$str);
	}catch(Exception $e){
		echo RespuestaEnviar(false,"Error: leyendo los datos".$e->getMessage());
	}
}

if(Mostrar_Progreso_o_procesar('Calculando las inconsistencias para todas las encuestas')){
	$rta=correr_consistencias($cual?array('inc_con'=>$cual):array());
	if($rta['ok']){
		echo RespuestaEnviar(true," corrieron {$rta['corrieron']} {$rta['agregadas']} detectadas (antes había {$rta['borradas']}). Demoro ".$rta['demoro']);
	}else{
		echo RespuestaEnviar(false,$rta['error']);
	}
}

if($cual and Mostrar_Progreso_o_procesar('Ejemplo de inconsistencias','innerHTML',
	Incluir_tabla_editor('"inconsistencias"',json_encode(array('inc_con'=>$cual)),'Ejemplo de inconsistencias')
)){
	echo RespuestaEnviar(true,"OK<BR>");
}

if($mostrando_progreso){
	EnviarStrAlCliente($str.$str_script);
}

function abrazar_con_nulo_a_neutro($pedacito_matcheado){
	$palabra=$pedacito_matcheado[1];
	if(!in_array($palabra,array('or','and','is','null','not','true')) /* or strpos($palabra,'.')>0 or preg_match('/^\\d+$/',$palabra)*/ ){
		$palabra="nulo_a_neutro($palabra)";
	}
	//return "{$pedacito_matcheado[1]}$palabra";
	return "$palabra{$pedacito_matcheado[2]}";
}

?>