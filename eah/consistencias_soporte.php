<?php
function armar_consistencias_detalles(){
global $db,$parametros;
	$consistencia=$parametros['pk'][0];
	$str="";
	$str.="<p>algo</p>";
	//$str.=Incluir_tabla_editor("'ano_con'",'anocon_con='.$db->quote($consistencia));
	$str.="<p>otra cosa</p>";
	Loguear(3,$str);
	return $str;
}

function correr_consistencias($filtro_para_lectura,$opciones=array()){
	try{
		global $db,$annio2d,$time_out_interactivo,$limit_ins_inconsistencias;
		$where_con='WHERE con_activa AND con_valida';
		$where_inc='';
		$inc_con=@$filtro_para_lectura['inc_con'] ?: null;
		$db->where_and($where_con,'con_con',$inc_con,array('no poner nulls en el where'=>true));
		$db->where_and($where_inc,'inc_con',$inc_con,array('no poner nulls en el where'=>true));
		$cursor=$db->ejecutar(<<<SQL
			SELECT *
			  FROM consistencias  
			  $where_con 
			  ORDER BY con_con
SQL
		);
		$inc_nenc=@$filtro_para_lectura['inc_nenc'] ?: @$filtro_para_lectura[1]?:null;
		$inc_nhogar=@$filtro_para_lectura['inc_nhogar'] ?: @$filtro_para_lectura[2]?:null;
		if(!@$opciones['dentro de transaccion']){
			$db->beginTransaction();
		}
		$db->where_and($where_inc,'inc_nenc',$inc_nenc,array('no poner nulls en el where'=>true));
		$db->ejecutar("delete from inconsistencias $where_inc");
		$rta['borradas']=$db->ultima_consulta->rowCount();
		$rta['agregadas']=0;
		$empezo=time();
		while($fila=$cursor->fetchObject() and time()<$empezo+$time_out_interactivo){
			$con_con=$fila->con_con;
			$where="WHERE ({$fila->con_expresion_sql})";
			$db->where_and($where,'a.nenc',$inc_nenc,array('no poner nulls en el where'=>true));
			$muestra=@$filtro_para_lectura['inc_muestra']?:false;
			$db->where_and($where,'a.nhogar',$inc_nhogar,array('no poner nulls en el where'=>true));
			$campos=$db->quote($con_con)." as inc_con, a.nenc as inc_nenc, a.nhogar as inc_nhogar";
			// Loguear('2011-11-09',"************ $con_con -> $empezo = $time_out_interactivo ## ".time()." $where *-*-*-*-*-* ".var_export($filtro_para_lectura,true));
			if($fila->con_junta=='un'){
				$campos.=", u.miembro as miembro, u.relacion as relacion";
			}else{
				if($fila->con_junta=='i1'){
					$campos.=", i.miembro";
				}else if($fila->con_junta=='fam'){
					$campos.=", p0 as miembro";
				}else if($fila->con_junta=='ex'){
					$campos.=", ex_miembro as miembro";
				}else if($fila->con_junta=='md'){
					$campos.=", d.miembro as miembro";
				}else{
					$campos.=", 0 as miembro";
				}
				$campos.=", 0 as relacion";
			}
			$where_convar="WHERE convar_for is not null and convar_enc='EAH20{$annio2d}'";
			$db->where_and($where_convar,'convar_con',$con_con);
			$variables=$db->preguntar_tabla("SELECT convar_var FROM con_var $where_convar");
			$inc_variables="''";
			foreach($variables as $variable){
				$variable_prefijada=$variable['convar_var'];
				$variable_prefijada=preg_replace('/\bh1\b/i','a.h1',$variable_prefijada);
				$variable_prefijada=preg_replace('/\bmiembro\b/i','i.miembro',$variable_prefijada);
				$inc_variables.="||'{$variable['convar_var']}='||coalesce({$variable_prefijada}::text,'')||', '";
			}
			$campos.=','.$inc_variables;
			$campos.=" as inc_variables";
			$campos.=", null, null, current_timestamp, t.estado";
			$sql="SELECT $campos FROM {$fila->con_clausula_from} $where $limit_ins_inconsistencias";
			if($muestra){
				$sql="SELECT * FROM ($sql) x WHERE inc_renglones<=$muestra ORDER BY inc_renglones";
			}
			$db->ejecutar("INSERT INTO inconsistencias $sql");
			$rta['agregadas']+=$db->ultima_consulta->rowCount();
		}
		if(!@$opciones['dentro de transaccion']){
			$db->commit();
		}
		if(@$filtro_para_lectura['inc_nenc']){
			$encuesta_encomillada=$db->quote($filtro_para_lectura['inc_nenc']);
			$rta['no resueltas']=$db->preguntar(<<<SQL
				SELECT count(*) 
					FROM inconsistencias INNER JOIN consistencias ON con_con=inc_con
					WHERE inc_nenc=$encuesta_encomillada 
						AND (con_gravedad<>'Advertencia' 
							OR inc_justificacion is null)
SQL
			);
			$rta['justificadas']=$db->preguntar(<<<SQL
				SELECT count(*) 
					FROM inconsistencias INNER JOIN consistencias ON con_con=inc_con
					WHERE inc_nenc=$encuesta_encomillada 
						AND (con_gravedad='Advertencia' AND inc_justificacion is not null)
SQL
			);
		}
		$rta['ok']=true;
		$rta['corrieron']=$fila?" hasta ".$con_con:" todas";
		$rta['demoro']=time()-$empezo;
		return $rta;
	}catch(Exception $e){
		$rta['error']=$e->getMessage();
		Loguear('2011-10-28','ACA HAY UN ERROR ===>'.var_export($e->getTrace(),true));
		$rta['ok']=false;
		return $rta;
	}
}

function Ignorar_nulls($expresion_sql){
	$operadores_logicos_regexp="or|and|is|end";
	$expresion_sql=preg_replace("#([A-Za-z][A-Za-z_.0-9]*) *($|[-+)<=>,*/!|]| ($operadores_logicos_regexp))#","nulo_a_neutro(\\1)\\2",$expresion_sql);
	$expresion_sql=preg_replace("#nulo_a_neutro\\(($operadores_logicos_regexp|null|not|true)\\)#i","\\1",$expresion_sql);
	return $expresion_sql;
}

function Acomodar_Expresion($expresion_sql,$ignorar_nulls){
	if($ignorar_nulls){
		$expresion_sql=Ignorar_nulls($expresion_sql);
	}
	foreach(array('replica'=>'replica::integer'
				, 'nhogar'=>'a.nhogar'
				, 'h1'=>'a.h1'
				, 'miembro'=>'i.miembro') as $cuando_vea=>$pongo){
		$expresion_sql=preg_replace("/\b{$cuando_vea}\b/i",$pongo,$expresion_sql);
	}
	$expresion_sql=str_replace("|||","||' | '||",$expresion_sql);
	return $expresion_sql;
}
?>