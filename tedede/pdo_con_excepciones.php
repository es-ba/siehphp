<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "comunes.php";

global $db,$parametros_db;
$db=new PDO_con_excepciones("pgsql:dbname={$parametros_db->base_de_datos};host={$parametros_db->host};port={$parametros_db->port}", 
        $parametros_db->user, $parametros_db->pass);
$db->log_hasta=@$pdo_log_sql_hasta_fecha?:false;
if($parametros_db->search_path){
    $db->ejecutar("set search_path = {$parametros_db->search_path}");
}
$maquina_ipl=isset($_SERVER['SERVER_ADDR'])?'i'.diferencia_ips($_SERVER['SERVER_ADDR'],$_SERVER['REMOTE_ADDR']):'local ';
$GLOBALS['NOMBRE_DB']=$parametros_db->host.'_'.$parametros_db->base_de_datos;
$db->ejecutar("set application_name = 'i".$maquina_ipl." ".(@$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"]?:'!LOG')."'");
        
class Atributos_columnas {
    public $entrecomillar=FALSE;
    public $valor_por_defecto=NULL;
    public $es_pk=FALSE;
    public $validart='';
    public $largo_texto;
    public $tipo_texto=false;
    public $tipo_entero=false;
}

interface Sqlsable{
    function obtener_sqls();
}

class Sql implements Sqlsable{
    public /*!string*/ $sql;
    public /*!array*/ $parametros;
    function __construct($sql_string,$parametros=array()){
        if(substr($sql_string,0,3)==UTF8_BOM){
            $sql_string=substr($sql_string,3);
        }
        $this->sql=$sql_string;
        $this->parametros=$parametros;
    }
    function obtener_sqls(){
        return array($this);
    }
    public function getIterator(){
        return obtener_sqls();
    }
}

class Sqls implements Sqlsable, IteratorAggregate{
    private /*!array of Sql*/ $sqls=array();
    function __construct($sentencias_planas=false){
        if($sentencias_planas){
            foreach($sentencias_planas as $sentencia){
                $this->agregar(new Sql($sentencia));
            }
        }
    }
    public function agregar(Sqlsable $sqls){
        array_append($this->sqls,$sqls->obtener_sqls());
    }
    public function poner_antes(Sqlsable $sqls){
        $arr=$sqls->obtener_sqls();
        array_append($arr,$this->sqls);
        $this->sqls=$arr;
    }
    function obtener_sqls(){
        return $this->sqls;
    }
    public function getIterator() {
        return new ArrayIterator($this->sqls);
    }
}

class NingunSql implements Sqlsable{
    function obtener_sqls(){
        return array();
    }
}

function assert_nombre_sql_valido($nombre_de_objeto,$tipo='comun'){
}

class Sql_Restriccion extends Sql{
    function __construct($esquema,$tabla,$nombre_constraint,$sql_string){
        assert_nombre_sql_valido($esquema);
        assert_nombre_sql_valido($tabla);
        assert_nombre_sql_valido($nombre_constraint, 'para entrecomillar');
        parent::__construct(
            'alter table '.$esquema.'.'.$tabla.' add constraint "'.$nombre_constraint.'" '.$sql_string,
            array()
        );
    }
    function obtener_sqls(){
        return array($this);
    }
    public function getIterator(){
        return obtener_sqls();
    }
}

class PDO_con_excepciones_sin_cache extends PDO{
    var $log_err="../logs/sql_errores.sql";
    var $log_todo="../logs/sql_todo.sql";
    var $log_hasta=false; 
    var $log_res=false;        // resultados
    var $log_callstack=false;  // llamadas a función
    //var $log_parametros_separados=false; // si muestra la llamada con los parámetros separados
    var $log_parametros_separados=true; // si muestra la llamada con los parámetros separados
    private $comenzo;
    private $es_postgres=false;
    var $ultima_consulta;
    function __construct($dsn, $username, $password){
        $this->es_postgres=substr($dsn,0,5)=='pgsql';
        parent::__construct($dsn, $username, $password);
    }
    function no_implementado(){
        throw new Exception('Nuestra PDO debe usarse con las nuevas funciones');
    }
    function query(){ return $this->no_implementado(); }
    function prepare($statement, $driver_options = array()){ return $this->no_implementado(); }
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
    function quote($nombre,$tipo='dato'){
        if($tipo=='dato'){
            if($nombre===true){
                return 'true';
            }else if($nombre===false){
                return 'false';
            }else if($nombre===null){
                return 'null';
            }
        }else if(!is_string($nombre)){
            // solo exijo que sea string si es una tabla, campo o cualquier cosa distinta de un dato
            Loguear('2012-01-26',var_export($nombre));
            throw new Exception_Tedede("quote espera que ".json_encode($nombre)." sea is_string");
        }
        if($tipo=='campo' || $tipo=='tabla'){
            if($this->es_postgres){
                return '"'.str_replace('"','""',$nombre).'"';
            }else{
                throw new Exception("quote no conoce el tipo de base de datos para $nombre $tipo");
            }
        }else if($tipo=='dato'){
            if(is_array($nombre)){
                throw new Exception_Tedede("Encontre un arreglo como parametro de quote ".var_export($nombre,true));
            }
            if(is_object($nombre)){
                throw new Exception_Tedede("parametro de quote invalido ".var_export($nombre,true));
            }
            return parent::quote($nombre);
        }else{
            throw new Exception_Tedede("quote no conoce el tipo de base de datos para $nombre $tipo");
            // esto todavía no lo pensamos, creo que conviene poner un nombre en castellano para el tipo
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
    function ejecutar_sql(Sql $sql){
        return $this->ejecutar($sql->sql, $sql->parametros);
    }
    function ejecutar_sqls(Sqlsable $sqls){
        foreach($sqls->obtener_sqls() as $sql){
            $this->ejecutar_sql($sql);
        }
    }
    function ejecutar($sentencia_a_ejecutar,$parametros=FALSE){
        global $esta_es_la_base_en_produccion, $log;
        if(is_array($sentencia_a_ejecutar) && $sentencia_a_ejecutar['sql'] && !$parametros){
            $parametros=$sentencia_a_ejecutar['params'];
            $sentencia_a_ejecutar=$sentencia_a_ejecutar['sql'];
        }
        if($sentencia_a_ejecutar instanceof Sql){
            $sql=$sentencia_a_ejecutar;
            $sentencia_a_ejecutar=$sql->sql;
            $parametros=$sql->parametros;
        }
        $this->comenzo=new DateTime();
        $this->loguear_sentencia($this->log_todo,$sentencia_a_ejecutar,$parametros,false);
        if($parametros){
            $this->ultima_consulta=parent::prepare($sentencia_a_ejecutar);
            if(!$this->ultima_consulta){
                $this->loguear_sentencia($this->log_err,$sentencia_a_ejecutar,$parametros,$this->errorInfo());
                $mensaje_a_lanzar=$this->errorInfo();
                throw new Exception($mensaje_a_lanzar[2]);
            }
            foreach($parametros as $k=>$v){
                if($v===null){
                    $tipo=PDO::PARAM_NULL;
                }else if($v===false or $v===true){
                    $tipo=PDO::PARAM_BOOL;
                }else if(is_integer($v)){
                    $tipo=PDO::PARAM_INT;
                }else if(is_float($v)){
                    $tipo=PDO::PARAM_STR;
                }else if(is_array($v)){
                    throw new Exception_Tedede("No probamos todavia como funciona con 'array' el ejecutar pdo para el parametro $k");
                }else{
                    $tipo=PDO::PARAM_STR;
                }
                if(!$k){
                    throw new Exception_Tedede("Detectado un parámetro sin nombre");
                }
                $this->ultima_consulta->bindValue($k,$v,$tipo);
            }
            // $resultado=$this->ultima_consulta->execute($parametros);
            $resultado=$this->ultima_consulta->execute();
        }else{
            if(!is_string($sentencia_a_ejecutar)){
                throw new Exception_Tedede("Parametro invalido para query en ejecutar");
            }
            $this->ultima_consulta=parent::query($sentencia_a_ejecutar);
            $resultado=true;
        }
        if(!$resultado || !$this->ultima_consulta){
            $this->loguear_sentencia($this->log_err,$sentencia_a_ejecutar,$parametros,$this->errorInfo());
            $mensaje_a_lanzar=$this->errorInfo();
            throw new Exception($mensaje_a_lanzar[2]);
            // throw new Exception(var_export($mensaje_a_lanzar,true));
        }
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
            case 'un objeto':
                $rta=$this->ultima_consulta->fetch(PDO::FETCH_OBJ);
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
    function preguntar_objeto($sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros=FALSE){
        return $this->preguntar_interna('un objeto',$sentencia_select_a_ejecutar_que_tiene_una_sola_columna,$parametros);
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
    function existe_columna($esquema, $tabla, $columna){
        $cursor=$this->ejecutar(<<<SQL
            SELECT * 
                FROM information_schema.columns 
                WHERE table_schema='$esquema' 
                    AND table_name='$tabla'
                    AND column_name='$columna'
SQL
        );
        return !!$cursor->fetchObject();
    }
    function dame_atributos_columna($esquema, $tabla, $columna, $modo='PANIC'){
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
        if($fila->data_type=='character varying' || $fila->data_type=='text'){
            $atr->tipo_texto=TRUE;
            $atr->largo_texto=$fila->character_maximum_length;
            
        }
        
         if($fila->data_type=='integer'){
            
            $atr->tipo_entero=TRUE;
           //echo "HOLA MUNDO";
         }
        if($fila->data_type=='character varying' || $fila->data_type=='text' || $fila->data_type=="timestamp without time zone"){
            $atr->entrecomillar=TRUE;
        }
        if($fila->column_default!==NULL){
            $defecto=$fila->column_default;
            $cuatro_puntos=strpos($defecto,'::');
            if($cuatro_puntos!==FALSE){
                $defecto=substr($fila->column_default,0,$cuatro_puntos);
            }
            if($defecto!="''" && empieza_con($defecto,"'")){
                $defecto=str_replace("''","\'",$defecto);
            }
            if($defecto!="now()" && $defecto!="ope_actual()"){
                ob_start();
                $atr->valor_por_defecto=eval("return {$defecto};");
                $la_salida_del_ob=ob_get_clean();
                if($la_salida_del_ob && $modo=='PANIC'){
                    throw new Exception_Tedede("dame_atributos_columna no puede evaluar la expresion por defecto de la columna $esquema.$tabla.$columna que en la base es: $defecto");
                }
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
        $cursor=$this->ejecutar(<<<SQL
            SELECT tc.constraint_name, check_clause, substring(check_clause, '''(\w+)''') as validart
              FROM information_schema.table_constraints tc,
                   information_schema.check_constraints cc
              WHERE tc.constraint_type='CHECK'
                AND tc.table_schema='$esquema'
                AND tc.table_name='$tabla'
                AND tc.constraint_name=cc.constraint_name
                AND tc.constraint_name like 'texto invalido en $columna %'
SQL
            );
        if($fila=$cursor->fetchObject()){
            $atr->validart=$fila->validart;
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
    function dame_arreglo_campos($esquema,$tabla,$asociativo=false){
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
            if($asociativo){
                $arr[$fila->column_name]=$fila;
            }else{
                $arr[]=$fila->column_name;
            }
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
            if(!$str){
                throw new Exception_Tedede("en dame_orden_total no hay campos en la tabla $esquema.$tabla");
            }
        }
        return $str;
    }
    function nombre_fk($esquema,$tabla,$esquema_hija,$tabla_hija){
        $cursor=$this->ejecutar(<<<SQL
            SELECT madre.constraint_name as nombre_fk
                FROM information_schema.table_constraints hija,
                    information_schema.constraint_table_usage madre
                WHERE   madre.table_schema='$esquema' 
                    AND madre.table_name='$tabla'
                    AND madre.table_catalog=hija.table_catalog
                    AND madre.constraint_name=hija.constraint_name
                    AND hija.constraint_type='FOREIGN KEY'
                    AND hija.table_name='$tabla_hija'
                    AND hija.table_schema='$esquema_hija'
SQL
        );
        if($fila=$cursor->fetchObject()){
            return $fila->nombre_fk;
        }
        return false;
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
        if(!isset($this->existe_tabla_tablas)){
            $this->existe_tabla_tablas=$this->preguntar("select 1 from information_schema.tables where table_name='tablas' and table_schema='$esquema'");
        }
        if($this->existe_tabla_tablas){
            return $this->preguntar("select tab_prefijo_campos from {$esquema}.tablas where tab_tab='{$tabla}'");
        }else{
            $nombre_primer_campo=$this->preguntar(<<<SQL
                SELECT column_name
                    FROM information_schema.columns 
                    WHERE table_schema='$esquema' 
                        AND table_name='$tabla'
                    ORDER BY ordinal_position
                    LIMIT 1
SQL
            );
            $pos_raya=strpos($nombre_primer_campo,'_');
            if($pos_raya>0){
                return substr($nombre_primer_campo,0,$pos_raya+1);
            }
        }
        return "";
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
    function nombre_fk($esquema,$tabla,$esquema_hija,$tabla_hija){
        return $this->via_cache("nombre_fk('$esquema','$tabla','$esquema_hija','$tabla_hija')");
    }
    function dependientes_fk($esquema,$tabla){
        return $this->via_cache("dependientes_fk('$esquema','$tabla')");
    }
    function campos_union_fk($esquema,$nombre_fk){
        return $this->via_cache("campos_union_fk('$esquema','$nombre_fk')");
    }
    function existe_columna($esquema, $tabla, $columna){
        return $this->via_cache("existe_columna('$esquema','$tabla','$columna')");
    }
    function dame_atributos_columna($esquema, $tabla, $columna, $modo='PANIC'){
        return $this->via_cache("dame_atributos_columna('$esquema','$tabla','$columna','$modo')");
    }
    function campos_pk($esquema,$tabla){
        return $this->via_cache("campos_pk('$esquema','$tabla')");
    }
    function dame_la_pk($esquema,$tabla){
        return $this->via_cache("dame_la_pk('$esquema','$tabla')");
    }
    function dame_arreglo_campos($esquema,$tabla,$asociativo=false){
        return $this->via_cache("dame_arreglo_campos('$esquema','$tabla',".($asociativo?'true':'false').")");
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