<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "respuestas.php";

define('PROCESO_INTERNO','!proceso interno!');

abstract class Procesos extends Contexto{
    public $parametros;
    private $definicion_parametros=array();
    final protected function parametros_aceptados($definicion_parametros){
        $this->definicion_parametros=array_merge($definicion_parametros,$this->definicion_parametros);
    }
    final protected function definir_parametros($parametros){
        controlar_parametros($parametros, $this->definicion_parametros);
        $this->parametros=$parametros;
    }
    function __construct($parametros){
        $this->parametros_aceptados(array(
            'titulo'=>array('obligatorio'=>true, 'validar'=>'is_string'),
            'permisos'=>null,
            'submenu'=>null,
            'para_produccion'=>false,
            'de_instalacion'=>array('validar'=>'is_bool','def'=>false),
            'no_en_produccion'=>false,
            'icon_app'=>null,
            // 'cookies'=>array('validar'=>'is_array'), MEJOR NO QUE ES UN LIO
            'en_construccion'=>array('validar'=>'is_bool','def'=>false),
            'bitacora'=>array('def'=>false, 'validar'=>'is_bool'),
            'opcion_node'=>array('validar'=>'is_bool','def'=>false)
        ));
        $this->definir_parametros($parametros);
    }
    function post_constructor(){
    }
    function los_csss(){
        return array();
    }
    function ignorar_csss_de_la_aplicacion_en_modo($modo_hacer){
        return false;
    }
    abstract function correr();
}

class Proceso_Generico extends Procesos{
    var $funcion_correr;
    function __construct($parametros){
        $this->parametros_aceptados(array(
            'funcion'=>array('obligatorio'=>true, 'validar'=>array('instanceof'=>'Closure')),
            'html_title'=>null
        ));
        parent::__construct($parametros);
    }
    function correr(){
        $correr=$this->parametros->funcion;
        $correr($this);
    }
}


?>