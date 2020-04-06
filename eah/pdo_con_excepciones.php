<?php

class Atributos_columnas {
	public $entrecomillar=FALSE;
	public $valor_por_defecto=NULL;
	public $es_pk=FALSE;
}

class PDO_con_excepciones_sin_cache extends PDO{
    var $log_err="logs/sql_errores.sql";
    var $log_todo="logs/sql_todo.sql";
    var $log_hasta=false; 
    var $log_res=false;        // resultados
    var $log_callstack=false;  // llamadas a función
	var $log_parametros_separados=false; // si muestra la llamada con los parámetros separados
	private $comenzo;
	private $es_postgres=false;
	var $ultima_consulta;
	function __construct($dsn, $username, $password){
		$this->es_postgres=substr($dsn,0,5)=='pgsql';
		parent::__construct($dsn, $username, $password);
	}
	function no_implementado(){
		// echo var_export(debug_backtrace(),TRUE);
		throw new Exception('Nuestra PDO debe usarse con las nuevas funciones');
	}
	function query(){ return $this->no_implementado(); }
	function prepare(){ return $this->no_implementado(); }
	function info(){
		$str="";
		$attributes = array(
			"AUTOCOMMIT", "ERRMODE", "CASE", "CLIENT_VERSION", "CONNECTION_STATUS",
			"ORACLE_NULLS", "PERSISTENT", "PREFETCH", "SERVER_INFO", "SERVER_VERSION",
			"TIMEOUT"
		);
		foreach ($attributes as $val) {
			$str.="PDO::ATTR_$val: ";
			$str.=@$this->getAttribute(constant("PDO::ATTR_$val")) . "\n";
		}
		return $str;
	}
	function quote($nombre,$tipo='por defecto'){
		if($tipo=='campo' || $tipo=='tabla'){
			if($this->es_postgres){
				return '"'.str_replace('"','""',$nombre).'"';
			}else{
				throw new Exception("quote no conoce el tipo de base de datos para $nombre $tipo");
			}
		}else if($tipo=='por defecto'){
			return parent::quote($nombre);
		}else{
			return parent::quote($nombre,$tipo);
		}
	}
	function loguear_sentencia($archivo,$sentencia_a_ejecutar,$parametros,$error=false){
		global $log;
		if($archivo){
			if(!$error){
				$termino=new DateTime();
				$demoro=$termino->diff($this->comenzo);
				$str_log="\n/* demoro: ".$demoro->format("%H:%I:%S");
			}else{
				$str_log="\n/* *** FALLO ***: ";
			}
			if(is_array($parametros)){
				if($this->log_parametros_separados){
					$str_log.="\n".$sentencia_a_ejecutar."\n"
						.var_export($parametros,TRUE);
				}
				$str_log.="\n*/\n";
				foreach($parametros as $campo=>$valor){
					$sentencia_a_ejecutar=preg_replace("/$campo\\b/",$this->quote($valor),$sentencia_a_ejecutar);
				}
			}else{
				$str_log.="*/";
			}
			$str_log.="\n".$sentencia_a_ejecutar."\n";
			if($error){
				$str_log.="/*".var_export($error,true)."\n*/\n";
				$hasta="2019-11-19";
			}else{
				$hasta=$this->log_hasta;
			}
			Loguear($hasta,$str_log,$archivo,($this->log_callstack?__FILE__:true));
		}
	}
	function loguear_resultado($archivo,$resultado){
		global $log;
		if($archivo && $this->log_res){
			Loguear($this->log_hasta,$resultado,$archivo,false);
		}
	}
	function ejecutar($sentencia_a_ejecutar,$parametros=FALSE){
		global $log;
		$this->comenzo=new DateTime();
		if($parametros){
			$this->ultima_consulta=parent::prepare($sentencia_a_ejecutar);
			if(!$this->ultima_consulta){
				$this->loguear_sentencia($this->log_err,$sentencia_a_ejecutar,$parametros,$this->errorInfo());
				$mensaje_a_lanzar=$this->errorInfo();
				throw new Exception($mensaje_a_lanzar[2]);
			}
			foreach($parametros as $k=>$v){
				if($v===false){
					$parametros[$k]='false';
				}else if($v===true){
					$parametros[$k]='true';
				}
			}
			$resultado=$this->ultima_consulta->execute($parametros);
		}else{
			$this->ultima_consulta=parent::query($sentencia_a_ejecutar);
			$resultado=true;
		}
		if(!$resultado || !$this->ultima_consulta){
			$this->loguear_sentencia($this->log_err,$sentencia_a_ejecutar,$parametros,$this->errorInfo());
			$mensaje_a_lanzar=$this->errorInfo();
			throw new Exception($mensaje_a_lanzar[2]);
			// throw new Exception(var_export($mensaje_a_lanzar,true));
		}
		$this->loguear_sentencia($this->log_todo,$sentencia_a_ejecutar,$parametros,false);
		return $this->ultima_consulta; // no sé si esto genera excepción
	}
	function preguntar_interna($modo,$sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
		global $log;
		$this->ultima_consulta=$this->ejecutar($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
		switch($modo){
			case 'un valor':
				$rta=$this->ultima_consulta->fetchColumn(0);
				$mostrar_en_el_log=$rta;
				break;
			case 'un arreglo':
				$rta=$this->ultima_consulta->fetch(PDO::FETCH_ASSOC);
				$mostrar_en_el_log=var_export($rta,true);
				break;
			case 'una tabla':
				$rta=$this->ultima_consulta->fetchAll(PDO::FETCH_ASSOC);
				$mostrar_en_el_log="Tabla de ".count($rta)." registros";
				break;
			default:
				throw new Exception("db.preguntar_interna no conoce el modo $modo");
		}
		$this->loguear_resultado($this->log_res,"-- obtenido: $mostrar_en_el_log\n");
		return $rta;
	}
	function preguntar($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
		return $this->preguntar_interna('un valor',$sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
	}
	function preguntar_array($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
		return $this->preguntar_interna('un arreglo',$sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
	}
	function preguntar_tabla($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
		return $this->preguntar_interna('una tabla',$sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
	}
	function preguntar_tabla_pk($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
		$datos_tabla=$this->preguntar_tabla($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
		$nueva_tabla=array();
		foreach($datos_tabla as $fila){
			$pk=$fila['pk'];
			unset($fila['pk']);
			$nueva_tabla[$pk]=$fila;
		}
		return $nueva_tabla;
	}
	function where_and(&$REF_expresion_where,$variable,$valor,$opciones=array()){
		if(isset($valor) && (!@$opciones['no poner nulls en el where'] || $valor!==null)){
			if($REF_expresion_where){
				$REF_expresion_where.=' AND ';
			}else{
				$REF_expresion_where.=' WHERE ';
			}
			$REF_expresion_where.=$variable;
			if($valor===null){
				$REF_expresion_where.=' is null';
			}else{
				$relacion=@$opciones['relacion']?:'=';
				$REF_expresion_where.=$relacion.$this->quote($valor);
			}
		}
	}
	function dame_atributos_columna($esquema, $tabla, $columna){
		$cursor=$this->ejecutar(<<<SQL
			SELECT * 
				FROM information_schema.columns 
				WHERE table_schema='$esquema' 
					AND table_name='$tabla'
					AND column_name='$columna'
SQL
		);
		if(!$fila=$cursor->fetchObject()){
			throw new Exception("no existe la columna $columna en la tabla $esquema.$tabla");
		}
		$atr=new Atributos_columnas();
		if($fila->data_type=='character varying' || $fila->data_type=='text' || $fila->data_type=="timestamp without time zone"){
			$atr->entrecomillar=TRUE;
		}
		if($fila->column_default!==NULL){
			$defecto=$fila->column_default;
			$cuatro_puntos=strpos($defecto,'::');
			if($cuatro_puntos!==FALSE){
				$defecto=substr($fila->column_default,0,$cuatro_puntos);
			}
			$defecto=str_replace("''","\'",$defecto);
			if($defecto!="now()"){
				$atr->valor_por_defecto=eval("return {$defecto};");
			}
		}
		$cursor=$this->ejecutar(<<<SQL
			SELECT 1
				FROM information_schema.table_constraints tc,
					information_schema.key_column_usage ccu
				WHERE tc.table_catalog=ccu.table_catalog
					AND tc.table_schema=ccu.table_schema
					AND tc.table_name=ccu.table_name
					AND tc.constraint_name=ccu.constraint_name
					AND tc.constraint_type='PRIMARY KEY'
					AND tc.table_schema='$esquema'
					AND tc.table_name='$tabla'
					AND ccu.column_name='$columna'
				ORDER BY ccu.ordinal_position
SQL
			);
		if($cursor->fetchObject()){
			$atr->es_pk=TRUE;
		}
		return $atr;
	}
	function campos_pk($esquema,$tabla){
		$cursor=$this->ejecutar(<<<SQL
			SELECT column_name
				FROM information_schema.table_constraints tc,
					information_schema.key_column_usage ccu
				WHERE tc.table_catalog=ccu.table_catalog
					AND tc.table_schema=ccu.table_schema
					AND tc.table_name=ccu.table_name
					AND tc.constraint_name=ccu.constraint_name
					AND tc.constraint_type='PRIMARY KEY'
					AND tc.table_schema='$esquema'
					AND tc.table_name='$tabla'
				ORDER BY ccu.ordinal_position
SQL
			);
		$arr=array();
		while($fila=$cursor->fetchObject()){
			$arr[]=$fila->column_name;
		}
		return $arr;
	}
	function dame_la_pk($esquema,$tabla){
		$str='';
		$separador='';
		foreach($this->campos_pk($esquema,$tabla) as $campo){
			$str.=$separador.$campo;
			$separador=', ';
		}
		return $str;
	}
	function dame_arreglo_campos($esquema,$tabla){
		$cursor=$this->ejecutar(<<<SQL
			SELECT * 
				FROM information_schema.columns 
				WHERE table_schema='$esquema' 
					AND table_name='$tabla'
				ORDER BY ordinal_position
SQL
		);
		$arr=array();
		while($fila=$cursor->fetchObject()){
			$arr[]=$fila->column_name;
		}
		return $arr;
	}
	function dame_los_campos($esquema,$tabla){
		return implode(', ',$this->dame_arreglo_campos($esquema,$tabla));
	}
	function dame_orden_total($esquema,$tabla){
		$str=$this->dame_la_pk($esquema,$tabla);
		if(!$str){
			$str=$this->dame_los_campos($esquema,$tabla);
		}
		return $str;
	}
	function dependientes_fk($esquema,$tabla){
		$cursor=$this->ejecutar(<<<SQL
			SELECT hija.table_name as tabla, madre.constraint_name as nombre_fk
				FROM information_schema.table_constraints hija,
					information_schema.constraint_table_usage madre
				WHERE   madre.table_schema='$esquema' 
					AND madre.table_name='$tabla'
					AND madre.table_catalog=hija.table_catalog
					AND madre.table_schema=hija.table_schema
					AND madre.constraint_name=hija.constraint_name
					AND hija.constraint_type='FOREIGN KEY'
SQL
		);
		$arr=array();
		while($fila=$cursor->fetchObject()){
			$arr[]=$fila;
		}
		return $arr;
	}
	function campos_union_fk($esquema,$nombre_fk){
		$cursor=$this->ejecutar(<<<SQL
			SELECT madre.column_name as campo_madre, hija.column_name as campo_hija
				FROM information_schema.referential_constraints fk,
					information_schema.key_column_usage madre,
					information_schema.key_column_usage hija
				WHERE   fk.constraint_schema='$esquema' 
					AND fk.constraint_name='$nombre_fk'
					AND madre.constraint_catalog=fk.constraint_catalog
					AND madre.constraint_schema=fk.constraint_schema
					AND madre.constraint_name=fk.unique_constraint_name
					AND hija.constraint_catalog=fk.constraint_catalog
					AND hija.constraint_schema=fk.constraint_schema
					AND hija.constraint_name=fk.constraint_name
					AND madre.ordinal_position=hija.ordinal_position
SQL
		);
		// puede fallar si la FK está desordenada respecto a la clave
		$arr=array();
		while($fila=$cursor->fetchObject()){
			$arr[]=$fila;
		}
		return $arr;
	}
	function dame_prefijo_campos($esquema,$tabla){
		return $this->preguntar("select tab_prefijo_campos from {$esquema}.tablas where tab_tab='{$tabla}'");
	}
}

class PDO_con_excepciones extends PDO_con_excepciones_sin_cache{
	private $cache=array();
	function __construct($dsn, $username, $password){
		parent::__construct($dsn, $username, $password);
	}
	function via_cache($que){
		if(isset($this->cache[$que])){
			$rta=$this->cache[$que];
		}else{
			$rta=eval('return parent::'.$que.';');
			$this->cache[$que]=$rta;
		}
		return $rta;
	}
	function dependientes_fk($esquema,$tabla){
		return $this->via_cache("dependientes_fk('$esquema','$tabla')");
	}
	function campos_union_fk($esquema,$nombre_fk){
		return $this->via_cache("campos_union_fk('$esquema','$nombre_fk')");
	}
	function dame_atributos_columna($esquema, $tabla, $columna){
		return $this->via_cache("dame_atributos_columna('$esquema','$tabla','$columna')");
	}
	function campos_pk($esquema,$tabla){
		return $this->via_cache("campos_pk('$esquema','$tabla')");
	}
	function dame_la_pk($esquema,$tabla){
		return $this->via_cache("dame_la_pk('$esquema','$tabla')");
	}
	function dame_arreglo_campos($esquema,$tabla){
		return $this->via_cache("dame_arreglo_campos('$esquema','$tabla')");
	}
	function dame_los_campos($esquema,$tabla){
		return $this->via_cache("dame_los_campos('$esquema','$tabla')");
	}
	function dame_orden_total($esquema,$tabla){
		return $this->via_cache("dame_orden_total('$esquema','$tabla')");
	}
	function dame_prefijo_campos($esquema,$tabla){
		return $this->via_cache("dame_prefijo_campos('$esquema','$tabla')");
	}
	function limpiar_cache(){
		$this->cache=array();
	}
}

?>