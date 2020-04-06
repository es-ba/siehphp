<?php
//UTF-8:SÍ
require "lo_imprescindible.php";

abstract class Filtro{
    public static $nombres_simples=false;
    public static $parametro_numero=1;
    public static $true="true";
    const IS_NOT_NULL='as$adfs####asfdjk ~!!! asfaaa##AD#@#!AAA???>,,,,??>';
    var $where="";
    var $and_where="";
    var $where_posterior="";
    var $and_where_posterior="";
    var $parametros=array();
    function __construct(){
        if(empieza_con($this->and_where," and ")){
            $this->where=quitar_prefijo($this->and_where," and ");
        }else{
            $this->where=self::$true;
        }
        if(empieza_con($this->and_where_posterior," and ")){
            $this->where_posterior=quitar_prefijo($this->and_where_posterior," and ");
        }else{
            $this->where_posterior=self::$true;
        }
    }
    function nombre_de_parametro($para_campo){
        return ':'.(self::$nombres_simples?'p':substr(strtr($para_campo,' :,*/=+-<>";().{}![]%$#\\\'?','__________________________'),0,30)).
            (self::$nombres_simples===null?'':self::$parametro_numero++);
    }
}

class Expresion_Literal{
    function __construct($expresion){
        $this->expresion=$expresion;
    }
    function obtener(){
        return $this->expresion;
    }
}

class Filtro_Basico extends Filtro{
    function __construct($pares_campo_valor_que_seran_tratados_como_un_and_de_igualdades, $esta_tov=null){
        if(!is_array_o_stdclass($pares_campo_valor_que_seran_tratados_como_un_and_de_igualdades)){
            throw new Exception_Tedede("el constructor de ".get_class($this)." tiene que recibir un arreglo o un StdClass");
        }
        foreach($pares_campo_valor_que_seran_tratados_como_un_and_de_igualdades as $campo=>$valor){
            if($esta_tov && !$esta_tov->existe_campo($campo) && (!$esta_tov->campos_lookup || !isset($esta_tov->campos_lookup[$campo])) && (!$esta_tov->campos_lookup_nombres || !isset($esta_tov->campos_lookup_nombres[$campo]))){
                throw new Exception_Tedede("no existe el campo $campo en ".get_class($esta_tov)." para el filtro ".json_encode($pares_campo_valor_que_seran_tratados_como_un_and_de_igualdades));
            }
            $this->que_where=$esta_tov==null?'and_where':'and_'.$esta_tov->en_que_where_va_el_campo_y_cual_campo($campo);
            $nombre_parametro=$this->nombre_de_parametro($campo);
            $this->agregar_parametro($campo,$nombre_parametro,$valor,$esta_tov);
        } 
        $this->armar_los_where();
        parent::__construct();
    }
    function armar_los_where(){
    }
    function agregar_parametro($campo,$nombre_parametro,$valor,$esta_tov){
        if($valor === null){
            $this->{$this->que_where}.=" and $campo is null";
        }else if($valor === Filtro::IS_NOT_NULL){
            $this->{$this->que_where}.=" and $campo is not null";
        }else if($valor instanceof Expresion_Literal){
            $this->{$this->que_where}.=" and $campo {$valor->obtener()}";
        }else{
            $this->{$this->que_where}.=" and $campo=$nombre_parametro";
            $this->guardar_valor_parametro($campo,$nombre_parametro,$valor,$esta_tov);
        }
        $this->pares_puros[$campo]=$valor;
    }
    function guardar_valor_parametro($campo,$nombre_parametro,$valor,$esta_tov){
        $considero_true=array('T'=>true,'t'=>true,'1'=>true,'s'=>true,'S'=>true,'Y'=>true,'V'=>true,'v'=>true,'y'=>true);
        if($esta_tov && $esta_tov->existe_campo($campo) && $esta_tov->campos[$campo]->es_booleano()){
            $this->parametros[$nombre_parametro]=isset($considero_true[substr(trim($valor),0,1)]);
        }else{
            $this->parametros[$nombre_parametro]=$valor;
        }
    }
}

/*
class Filtro_Tabla extends Filtro_Basico{
    function __construct($tabla, $esta_tov=null){
        if($filtro_o_pares instanceof Filtro){
            foreach($filtro_o_pares as $campo=>$valor){
                $this->{$campo}=$valor;
            }
        }else{
            parent::__construct($filtro_o_pares, $esta_tov);
        }
    }
}
*/

class Filtro_Normal extends Filtro_Basico{
    function __construct($filtro_o_pares, $esta_tov=null){
        $this->esta_tov=$esta_tov;
        if($filtro_o_pares instanceof Filtro){
            // COPIA DE LOS CAMPOS INTERNOS:
            foreach($filtro_o_pares as $campo=>$valor){
                $this->{$campo}=$valor;
            }
        }elseif($filtro_o_pares instanceof Tablas_o_Vistas){
            // throw new Exception_Tedede("PAPEX");
            $otra_tabla=$filtro_o_pares; 
            $nombre_otra_tabla=$otra_tabla->nombre_tabla_o_vista; 
            if(isset($esta_tov->fks[$nombre_otra_tabla])){
                $definicion_fk=$esta_tov->fks[$nombre_otra_tabla];
                $lado_a_filtrar='campos_origen';
                $lado_a_usar='campos_destino';
            }else if(isset($otra_tabla->fks[$esta_tov->nombre_tabla_o_vista])){
                $definicion_fk=$otra_tabla->fks[$esta_tov->nombre_tabla_o_vista];
                $lado_a_filtrar='campos_destino';
                $lado_a_usar='campos_origen';
            }else{
                throw new Exception_Tedede("no se puede usar {$nombre_otra_tabla} como filtro de la tabla ".$esta_tov->nombre_tabla_o_vista);
            }
            $filtro=array();
            foreach($definicion_fk[$lado_a_usar] as $num=>$campo_origen){
                $campo_destino=$definicion_fk[$lado_a_filtrar][$num];
                $filtro[$campo_destino]=$otra_tabla->datos->{$campo_origen};
            }
            parent::__construct($filtro, $esta_tov);
        }else{
            parent::__construct($filtro_o_pares, $esta_tov);
        }
    }
    function agregar_parametro($campo,$nombre_parametro,$valor,$esta_tov){
        if(is_string($valor) && (substr($valor,0,1)==='#' /* || substr($valor,0,1)==='·' shift 3 en el teclado español */)){
            $valor=substr($valor,1);
            $regexp_divididor='/([|&()])/';
            $regexp_expresiones_filtro='/^\s*((?P<conector>[|&()])|(?P<nombre>\w*)\s*(?P<negar>!?)((?P<null>(null|vacio|todo))|(?P<posicional>@?)(?P<operador>[=<>~*]+|like|como|fecha) *((?P<variable>#\d+)|(?P<operando>[^&]*)))\s*)$/';
            $porciones=preg_split($regexp_divididor,$valor,-1,PREG_SPLIT_DELIM_CAPTURE|PREG_SPLIT_NO_EMPTY);
            $expresiones='';
            $parentesis_izquierdo_si_fuera_necesario="";
            $parentesis_derecho_si_fuera_necesario="";
            foreach($porciones as $orden=>$porcion){
                if(preg_match($regexp_expresiones_filtro, $porcion, $matches)){
                    if($orden){
                        $nombre_parametro=$this->nombre_de_parametro($campo);
                    }
                    $nombre_campo=@$matches['nombre']?:$campo;
                    if(@$matches['conector']){
                        switch($matches['conector']){
                        case '&': 
                            $expresion=' and ';
                            break;
                        case '|':
                            $parentesis_izquierdo_si_fuera_necesario="(";
                            $parentesis_derecho_si_fuera_necesario=")";
                            $expresion=' or ';
                            break;
                        default:
                            $expresion=$matches['conector'];
                        }
                    }else if(@$matches['operador']){
                        switch($matches['operador']){
                        case 'fecha':
                            $expresion="$nombre_campo >= date_trunc('day',trim($nombre_parametro)::timestamp) and $nombre_campo < date_trunc('day',trim($nombre_parametro)::timestamp) + interval '1 day'";
                            break;
                        case 'como':
                            $expresion="$nombre_campo like $nombre_parametro";
                            break;
                        case '<': 
                        case '>':
                        case '<=': 
                        case '>=':
                            if($this->esta_tov===null || !@$this->esta_tov->campos[$nombre_campo] || !$this->esta_tov->campos[$nombre_campo]->es_numerico()){
                                if($matches['posicional']){
                                    $expresion="$nombre_campo {$matches['operador']} $nombre_parametro";
                                }else{
                                    $expresion="comun.para_ordenar_numeros($nombre_campo::text) {$matches['operador']} comun.para_ordenar_numeros($nombre_parametro::text)";
                                }
                                break;
                            } // ojo sin break para cuando el campo es numérico
                        default:
                            $expresion="$nombre_campo {$matches['operador']} $nombre_parametro";
                        }
                        $this->guardar_valor_parametro($nombre_campo,$nombre_parametro,$matches['operando'],$esta_tov);
                    }else if($matches['null']=='null'){
                        $expresion="$nombre_campo is null";
                    }else if($matches['null']=='todo'){
                        $expresion=self::$true;
                    }else if($matches['null']=='vacio'){
                        $expresion="trim(coalesce($nombre_campo::text,''))=''";
                    }
                    $expresion=((@$matches['negar'])?'not ':'').$expresion;
                    $expresiones.=$expresion;
                }else{
                    throw new Exception_Tedede("Hay un error en el filtro '$valor' en la parte '$porcion'");
                }
            }
            $this->{$this->que_where}.=" and {$parentesis_izquierdo_si_fuera_necesario}$expresiones{$parentesis_derecho_si_fuera_necesario}"; // entre paréntesis si tiene un OR dentro
        }else{
            parent::agregar_parametro($campo,$nombre_parametro,$valor,$esta_tov);
        }
    }
}



//function separar_filtro($filtro,$esta_tov=null){
//    // Loguear('2012-04-04','Filtro por separar '.json_encode($filtro));
//    }elseif($filtro instanceof Filtro_Voy_Por){
//        $f=null;
//        foreach($filtro->array_de_filtros as $sub_filtro){
//            $g=separar_filtro($sub_filtro,$esta_tov);
//            if($f===null){
//                $f=$g;
//                $f->and_where="({$f->and_where}) ";
//            }else{
//                $f->and_where.=$filtro->conector()." ($g->and_where) ";
//                $f->parametros=array_merge($f->parametros,$g->parametros);
//            }
//        }
//    }else{
//        $filtro=aplanar_filtro($filtro,$esta_tov);
//        $parametros=array();
//        $f=(object)array('parametros'=>'', 'where'=>array(), 'where_posterior'=>array());
//        $f->and_where=array();
//        foreach($filtro as $campo=>$valor){
//            if($esta_tov && !$esta_tov->existe_campo($campo)){
//                throw new Exception_Tedede("no existe el campo $campo en ".get_class($esta_tov)." para el filtro ".json_encode($filtro));
//            }
//            $que_where=$esta_tov==null?'where':$esta_tov->en_que_where_va_el_campo_y_cual_campo($campo);
//            $nombre_parametro=nombre_de_parametro($campo);
//            if($valor === null){
//                $f->{$que_where}[]="$campo is null";
//            }elseif(substr($valor,0,1)==='#' /* || substr($valor,0,1)==='·' shift 3 en el teclado español */){
//                $valor=substr($valor,1);
//                $regexp_divididor='/([|&()])/';
//                $regexp_expresiones_filtro='/^\s*((?P<conector>[|&()])|(?P<nombre>\d*)\s*(?P<negar>!?)((?P<null>(null|vacio))|(?P<posicional>@?)(?P<operador>[=<>~*]+|like) *((?P<variable>#\d+)|(?P<operando>[^&]*)))\s*)$/';
//                $porciones=preg_split($regexp_divididor,$valor,-1,PREG_SPLIT_DELIM_CAPTURE|PREG_SPLIT_NO_EMPTY);
//                $expresiones='';
//                foreach($porciones as $orden=>$porcion){
//                    if(preg_match($regexp_expresiones_filtro, $porcion, $matches)){
//                        if($orden){
//                            $nombre_parametro=nombre_de_parametro($campo);
//                        }
//                        if(@$matches['conector']){
//                            switch($matches['conector']){
//                            case '&': 
//                                $expresion=' and ';
//                                break;
//                            case '|':
//                                $expresion=' or ';
//                                break;
//                            default:
//                                $expresion=$matches['conector'];
//                            }
//                        }else if(@$matches['operador']){
//                            switch($matches['operador']){
//                            case 'como':
//                                $expresion="$campo like $nombre_parametro";
//                                break;
//                            case '<': 
//                            case '>':
//                            case '<=': 
//                            case '>=':
//                                if($esta_tov===null || !$esta_tov->campos[$campo]->es_numerico()){
//                                    if($matches['posicional']){
//                                        $expresion="$campo {$matches['operador']} $nombre_parametro";
//                                    }else{
//                                        $expresion="comun.para_ordenar_numeros($campo::text) {$matches['operador']} comun.para_ordenar_numeros($nombre_parametro::text)";
//                                    }
//                                    break;
//                                } // ojo sin break para cuando el campo es numérico
//                            default:
//                                $expresion="$campo {$matches['operador']} $nombre_parametro";
//                            }
//                            $f->parametros[$nombre_parametro]=$matches['operando'];
//                        }else if($matches['null']=='null'){
//                            $expresion="$campo is null";
//                        }else if($clausula=='vacio'){
//                            $expresion="trim(coalesce($campo::text,''))=''";
//                        }
//                        $expresion=((@$matches['negar'])?'not ':'').$expresion;
//                        $expresiones.=$expresion;
//                    }else{
//                        throw new Exception_Tedede("Hay un error en el filtro '$valor' en la parte '$porcion'");
//                    }
//                }
//                $f->{$que_where}[]="($expresiones)"; // entre paréntesis porque puede tener un OR dentro
//            }else{
//                $f->{$que_where}[]="$campo=$nombre_parametro";
//                $f->parametros[$nombre_parametro]=$valor;
//            }
//        } 
//        $f->and_where=implode(' and ',$f->and_where)?:'true'; //OJO: el TRUE en otras bases de datos puede fallar, EJ MYSQL
//        $f->and_where_posterior=implode(' and ',$f->and_where_posterior)?:'';
//    }
//    return $f;
//}

class Filtro_Que_se_completa_y_pisa extends Filtro_Basico{
    // Cuando en el primero y segundo filtros conectados hay campos en común, se pisan los valores del primero y van los valores del segundo
    var $array_de_filtros;
    function __construct($array_de_filtros,$esta_tov=null){
        $this->array_de_filtros=$array_de_filtros;
        $filtro_comun=array();
        foreach($array_de_filtros as $filtro){
            if($filtro instanceof Filtro){
                throw new Exception_Tedede("No se pueden poner en ".get_class($this)." filtros especiales (de clase Filtro)");
            }else{
                $filtro=new Filtro_Normal($filtro,$esta_tov);
                $filtro_comun=array_merge($filtro_comun,$filtro->pares_puros);
            }
        }
        parent::__construct($filtro_comun,$esta_tov);
    }
}


class Filtro_Conector extends Filtro{
    function __construct($array_de_filtros,$esta_tov=null){
        foreach($array_de_filtros as $subfiltro){
            if(!($subfiltro instanceof Filtro)){
                $subfiltro=new Filtro_Normal($subfiltro,$esta_tov);
            }
            $conector=$this->and_where?" ".$this->conector()." ":' and ';
            $this->and_where.=$conector."({$subfiltro->where})";
            $this->and_where_posterior.=$conector."({$subfiltro->where_posterior})";
            $this->parametros=array_merge((array)$this->parametros,(array)$subfiltro->parametros);
        }
        Filtro::__construct();
    }
    function conector(){
        throw new Exception_Tedede("Falta definir el conector en ".get_class($this));
        // return " ANDOR ";
    }
}

class Filtro_AND extends Filtro_Conector{
    /*
    function __construct($array_de_filtros,$esta_tov=null){
        parent::__construct($array_de_filtros,$esta_tov);
    }
    */
    function conector(){
        return "AND";
    }
}

class Filtro_OR extends Filtro_Conector{
    /*
    function __construct($array_de_filtros,$esta_tov=null){
        parent::__construct($array_de_filtros,$esta_tov);
    }
    */
    function conector(){
        return "OR";
    }
}

class Filtro_Voy_Por extends Filtro_Basico{
    var $pares_de_campos='';
    var $pares_de_parametros='';
    function __construct($componentes_del_voy_por,$esta_tov=null){
        parent::__construct($componentes_del_voy_por,$esta_tov);
    }
    function agregar_parametro($campo,$nombre_parametro,$valor,$esta_tov){
        $coma=$this->pares_de_campos?', ':'';
        $this->pares_de_campos.=$coma.$campo;
        $this->pares_de_parametros.=$coma.$nombre_parametro;
        $this->guardar_valor_parametro($campo,$nombre_parametro,$valor,$esta_tov);
    }
    function armar_los_where(){
        $this->and_where=" and ({$this->pares_de_campos})>({$this->pares_de_parametros})";
    }
}

?>