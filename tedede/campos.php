<?php
//UTF-8:SÍ
/*
Soporte para las tablas de la base de datos.

*/
require_once "lo_imprescindible.php";
require_once "comunes.php";
require_once "para_parametros_con_nombre.php";
require_once "pdo_con_excepciones.php";
require_once "esquemas.php";

class Campo{
    function __construct($parametros_opcionales){
        foreach($parametros_opcionales as $param=>$valor){
            $this->{$param}=$valor;
        }
    }
    function sql_tipo_creacion(){
        return $this->sql_tipo_basico().
            ($this->not_null?' not null':'').
            (isset($this->def)?' default '.$this->expresion_default():'');
    }
    function expresion_default(){
        if(is_array($this->def)){
            if(isset($this->def['funcion'])){
                return $this->def['funcion'];
            }
        }
        return $this->def===false?'false':($this->def===true?'true':"'".$this->def."'");
    }
    function sql_modificacion_tipo(){
        return 'type '.$this->sql_tipo_basico();
    }
    function sql_modificacion_nulleable(){
        return $this->not_null?'set not null':'drop not null';
    }
    function sql_modificacion_default(){
        return isset($this->def)?' set default '.$this->expresion_default():' drop default';
    }
    function es_numerico(){
        return false;
    }
    function es_booleano(){
        return false;
    }
}

class Campo_texto extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null,'largo'=>'infinito', 'not_null'=>false, 'def'=>null,'def_calculado'=>null,'validart'=>null)
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        if($this->largo=='infinito'){
            return 'text';
        }else{
            return 'varchar('.$this->largo.')';
        }
    }
}

class Campo_enumerado extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>'optativo','elementos'=>null,'def'=>null,'largo'=>array('def'=>50),'not_null'=>null,'validart'=>array('validar'=>'is_string'))
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        return 'varchar('.$this->largo.')';
    }
}

class Campo_entero extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>array('validar'=>'is_numeric'),'def_calculado'=>null,'bytes'=>array('def'=>''))
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        if($this->bytes){
            return 'int'.$this->bytes;
        }
        return 'integer'.$this->bytes;
    }
    function es_numerico(){
        return true;
    }
}

class Campo_decimal extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>array('validar'=>'is_numeric'),'def_calculado'=>null,'bytes'=>array('def'=>''),'decilames'=>null)
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        return 'numeric';
    }
    function es_numerico(){
        return true;
    }
}

class Campo_real extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>array('validar'=>'is_numeric'),'def_calculado'=>null,'bytes'=>array('def'=>''),'decilames'=>null)
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        return 'double precision';
    }
    function es_numerico(){
        return true;
    }
}

class Campo_logico extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>array('validar'=>'is_bool'))
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        return 'boolean';
    }
    function es_booleano(){
        return true;
    }
}

class Campo_solo_true extends Campo_logico{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null,'def'=>true)
        );
        $parametros->not_null=false;
        return parent::__construct((array)$parametros);
    }
}

class Campo_timestamp extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>null)
        );
        return parent::__construct((array)$parametros);
    }
    function sql_tipo_basico(){
        return 'timestamp';
    }
}

class Campo_fecha extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>null)
        );
        return parent::__construct((array)$parametros);
    }
    function sql_tipo_basico(){
        return 'date';
    }
}

class Campo_serial extends Campo_entero{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null,'not_null'=>false,'bytes'=>array('def'=>''))
        );
        parent::__construct((array)$parametros);
    }
    function sql_tipo_basico(){
        return 'serial'.$this->bytes;
    }
    function es_numerico(){
        return true;
    }
}
class Campo_sino_dom extends Campo_texto{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null,'largo'=>1, 'not_null'=>false, 'def'=>null,'def_calculado'=>null)
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
            return 'cvp.sino_dom';
    }

}
class Campo_bentero extends Campo{
    function __construct($parametros){
        controlar_parametros($parametros,
            array('tipo'=>null, 'not_null'=>false, 'def'=>array('validar'=>'is_numeric'),'def_calculado'=>null,'bytes'=>array('def'=>''))
        );
        return parent::__construct($parametros);
    }
    function sql_tipo_basico(){
        return 'bigint'.$this->bytes;
    }
    function es_numerico(){
        return true;
    }
}

?>