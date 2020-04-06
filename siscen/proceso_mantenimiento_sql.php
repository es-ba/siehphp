<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_mantenimiento_sql extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(   
            'titulo'=>'de la base de datos',
            'permisos'=>array('grupo'=>'programador'),
            'para_produccion'=>true,
            'submenu'=>'mantenimiento',
            'parametros'=>array(
                'tra_sql'=>array('label'=>'sql'),
            ),
            'boton'=>array('id'=>'ejecutar'),
            'script_arranque'=><<<JS
                conF5correrEjecutar(function(){proceso_formulario_boton_ejecutar('mantenimiento_sql','ejecutar',['tra_sql'],null,null,false)});
JS
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        $sql=$this->argumentos->tra_sql;
        if(strpos($sql,';')!==false){
            return new Respuesta_Negativa("no se pueden ejecutar varias sentencias");
        }
        if(strtolower(substr($sql,0,6)!='select')){
            return new Respuesta_Negativa("por ahora solo select");
        }
        $ahora=new DateTime();
        file_put_contents('guardar_sql.sql',"-- ".$ahora->format('Y-m-d H:i:s')."\n",FILE_APPEND);
        file_put_contents('guardar_sql.sql',$sql.";\n\n",FILE_APPEND);
        $sentencia=$this->db->ejecutar_sql(new Sql($sql));
        $filas=$sentencia->rowCount();
        $datos=$sentencia->fetchAll(PDO::FETCH_ASSOC);
        $rta=array('filas'=>$filas,'datos'=>$datos);
        return new Respuesta_Positiva($rta);
    }
}
?>