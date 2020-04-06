<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "pdo_con_excepciones.php";
require_once "armador_de_salida.php";

class Contexto{
    public $db;
    public $salida;
    function nuevo_objeto($nombre_clase,$argumento1=null,$argumento2=null){
        // $clase=$nombre_clase.@$this->sufijo_clase;
        $clase=$nombre_clase.'__'.$GLOBALS['nombre_app'];
        if(!class_exists($clase)){
            $clase=$nombre_clase;
        }
        if(!class_exists($clase)){
            throw new Exception_Tedede("Intento de crear un objeto de una clase que no existe $clase");
        }
        $objeto=new $clase($argumento1,$argumento2);
        if($objeto instanceof Contexto){
            $objeto->db=$this->db;
            $objeto->salida=$this->salida;
        }else{
            $objeto->contexto=$this;
        }
        return $objeto;
    }    
}
?>