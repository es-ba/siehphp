<?php

$reservadas_js=array('for','var','if','else','end','while');

function entrecomillar_si_es_reservada($campo){
	global $reservadas_js;
	if(in_array($campo,$reservadas_js)){
		return '"'.$campo.'"';
	}
	return $campo;
}

function json_dump($esquema,$tabla,$contexto=array(),$profundidad=0){
	// $str_arr=array();
	$str=''; 
	if(is_array($tabla)){
		$str.="{ json_dumper:1\n";
		$str.=", tablas:\n";
		$str.="  { ";
		$separador="";
		foreach($tabla as $una_tabla){
			$str.=$separador.$una_tabla.":\n".json_dump($esquema,$una_tabla,array(),$profundidad+1);
			$separador="\n  , ";
		}
		$str.="\n  }\n}\n";
	}else{
		global $db;
		$prefijo_campos=$db->dame_prefijo_campos($esquema,$tabla);
		$largo_tab_prefijo_campos=strlen($prefijo_campos);
		$margen=str_repeat("  ",$profundidad*2);
		$orden_total=$db->dame_orden_total($esquema,$tabla);
		$str.=$margen.'[';
		$where='';
		$separador_where='WHERE ';
		foreach($contexto as $campo=>$valor){
			$where.=$separador_where.$campo."='".$valor."'";
			$separador_where=" AND ";
		}
		$cursor=$db->ejecutar("SELECT * FROM $esquema.$tabla $where ORDER BY $orden_total");
		$separador_fila=' ';
		while($fila=$cursor->fetch(PDO::FETCH_ASSOC)){
			$str.=$separador_fila;
			$str.='{';
			$separador_columna=' ';
			foreach($fila as $nombre_columna=>$valor){
				if(!isset($contexto[$nombre_columna])){
					$atributos=$db->dame_atributos_columna($esquema,$tabla,$nombre_columna);
					$nombre_columna=substr($nombre_columna,$largo_tab_prefijo_campos);
					if($valor!==$atributos->valor_por_defecto){
						$str.=$separador_columna.entrecomillar_si_es_reservada($nombre_columna).':';
						if($valor===FALSE){
							$str.='false';
						}else if($valor===TRUE){
							$str.='true';
						}else if($valor===NULL){
							$str.='null';
						}else if($atributos->entrecomillar){
							$str.='"'.str_replace(array("\\",'"',"\n","\r"),array("\\\\",'\"','\n','\r'),$valor).'"';
						}else{
							$str.=$valor;
						}
						$separador_columna=', ';
					}
				}
			}
			$fk_hijas=$db->dependientes_fk($esquema,$tabla);
			foreach($fk_hijas as $fk_hija){
				$tabla_hija=$fk_hija->tabla;
				$campos_join=$db->campos_union_fk($esquema,$fk_hija->nombre_fk);
				$nuevo_contexto=array();
				$pk_de_la_hija=$db->campos_pk($esquema,$fk_hija->tabla);
				$todos_campos_hijo_son_pk=true;
				foreach($campos_join as $campo_join){
					$nuevo_contexto[$campo_join->campo_hija]=$fila[$campo_join->campo_madre];
					if(!in_array($campo_join->campo_hija,$pk_de_la_hija)){
						$todos_campos_hijo_son_pk=false;
					}
				}
				if($todos_campos_hijo_son_pk){
					$dump_hija=json_dump($esquema,$tabla_hija,$nuevo_contexto,$profundidad+1);
					if(strpos($dump_hija,':')>0){
						$str.="\n".$margen."  ".$separador_columna.$tabla_hija.":\n".$dump_hija."\n  ".$margen;
					}
				}
			}
			$str.="}\n".$margen;
			$separador_fila=', ';
		}
		$str.=']';
	}
	// return implode($str_arr);
	return $str;
}

function json_arreglar($json_compatible_js){
    // lo arregla para que sea compatible con PHP
	return preg_replace('/([{,]\s*)(\w+)(\s*:)(\s*([0-9.]+|"[^"]*(\\")*"\s*)\s*|)/', '$1"$2"$3$4', $json_compatible_js);
}

function json_sangrar($json_lineal){
	$str="";
	$nivel=-1;
	$previa_dospuntos=FALSE;
	$entrecomillado=FALSE;
	$escapado=FALSE;
	foreach(str_split($json_lineal) as $letra){
		if($entrecomillado){
			switch($letra){
				case '"':
					$entrecomillado=$escapado;
					$escapado=FALSE;
					break;
				case '\\':
					$escapado=TRUE;
					break;
				default:
					$escapado=FALSE;
			}
			$str.=$letra;
		}else{
			switch($letra){
				case "[":
				case "{":
					$nivel++;
					if($previa_dospuntos){
						$str.="\n".str_repeat("  ",$nivel);
					}
					$str.=$letra.' ';
					break;
				case " ": 
					break;
				case "]":
				case "}":
					$str.="\n".str_repeat("  ",$nivel);
					$str.=$letra;
					$nivel--;
					$previa_dospuntos=FALSE;
					break;
				case ":":
					$str.=$letra.' ';
					$previa_dospuntos=TRUE;
					break;
				case ",":
					$str.="\n".str_repeat("  ",$nivel).$letra.' ';
					$previa_dospuntos=FALSE;
					break;
				case '"':
					$entrecomillado=TRUE;
					$str.=$letra;
					break;
				default:
					$str.=$letra;
					$previa_dospuntos=FALSE;
			}
		}
	}
	return $str;
}

function json_generar_insert_aux(&$respuestas, $esquema, $tabla, $datos, $campos_pk_madre=array()){
	global $db;
	if(!isset($respuestas[$tabla])){
		$encabezado_insert='';
		if(count($datos)>0){
			$encabezado_insert.="INSERT INTO {$esquema}.{$tabla} (";
			$encabezado_insert.=$db->dame_los_campos($esquema, $tabla).') VALUES ';
		}
		$respuestas[$tabla]=$encabezado_insert;
	}else{
		if(count($datos)>0){
			$respuestas[$tabla].=", \n";
		}
	}
	$prefijo_campos=$db->dame_prefijo_campos($esquema, $tabla);
	$datos_insert='';
	$separador_linea='';
	$campos_pk=$campos_pk_madre;
	foreach($datos as $linea){
		$separador_campo=$separador_linea.'(';
		foreach($db->dame_arreglo_campos($esquema,$tabla) as $nombre_columna){
			$nombre_campo=substr($nombre_columna,strlen($prefijo_campos));
			$atributos=$db->dame_atributos_columna($esquema,$tabla,$nombre_columna);
			if(array_key_exists($nombre_campo,$linea)){
				$valor=$linea[$nombre_campo];
			}else if(array_key_exists($nombre_campo,$campos_pk_madre)){
				$valor=$campos_pk_madre[$nombre_campo];
			}else{
				$valor=$atributos->valor_por_defecto;
			}
			if($atributos->es_pk){
				$campos_pk[$nombre_campo]=$valor;
			}
			if($valor===NULL){
				$poner='null';
			}else if($valor===FALSE){
				$poner='false';
			}else if($valor===TRUE){
				$poner='true';
			}else if($atributos->entrecomillar){
				$poner="'".str_replace(array("'"),array("''"),$valor)."'";
			}else{
				$poner=$valor;
			}
			$datos_insert.=$separador_campo.$poner;
			$separador_campo=', ';
		}
		$datos_insert.=')';
		$separador_linea=', ';
		$fk_hijas=$db->dependientes_fk($esquema,$tabla);
		foreach($fk_hijas as $fk_hija){
			// echo "<br>{$fk_hija->tabla} es hija de $tabla en la linea ".var_export($linea,TRUE);
			$tabla_hija=$fk_hija->tabla;
			if(array_key_exists($tabla_hija,$linea)){
				$todos_campos_hijo_son_pk=true;
				$campos_join=$db->campos_union_fk($esquema,$fk_hija->nombre_fk);
				$pk_de_la_hija=$db->campos_pk($esquema,$fk_hija->tabla);
				foreach($campos_join as $campo_join){
					if(!in_array($campo_join->campo_hija,$pk_de_la_hija)){
						$todos_campos_hijo_son_pk=false;
					}
				}
				/*
				if($todos_campos_hijo_son_pk){
					$dump_hija=json_dump($esquema,$tabla_hija,$nuevo_contexto,$profundidad+1);
					if(strpos($dump_hija,':')>0){
						$str.="\n".$margen."  ".$separador_columna.$tabla_hija.":\n".$dump_hija."\n  ".$margen;
					}
				}
				*/
				if($todos_campos_hijo_son_pk){
					json_generar_insert_aux($respuestas, $esquema, $tabla_hija, $linea[$tabla_hija],$campos_pk);
				}
			}
		}
	}
	$respuestas[$tabla].=$datos_insert;
}

function json_generar_insert($esquema, $tabla, $json){
	$respuestas=array();
	$datos=json_decode($json,TRUE);
	json_generar_insert_aux($respuestas, $esquema, $tabla, $datos);
	$str=implode(";\n", $respuestas);
	if($str){
		return $str.";\n";
	}
}

function insert_bonito($sentencia_insert){
    $str=preg_replace('/[ \n\r\t]+/', ' ', $sentencia_insert);
    $str=preg_replace('/^[ \n\r\t]+/', '', $str);
    $str=preg_replace('/[ \n\r\t]+$/', '', $str);
	$str=str_replace(array("); ","VALUES","),",") ,"),array(");\n","\nVALUES","),\n","),\n"),$str);
	return $str;
}
?>