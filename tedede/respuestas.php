<?php
//UTF-8:SÍ
//Respuestas al cliente vía AJAX
require_once "lo_imprescindible.php";

class Respuestas{
    var $respuestas=array();
    protected function __construct($positivo,$mensaje_o_datos){
        $this->respuestas['ok']=$positivo;
        $this->respuestas['mensaje']=$mensaje_o_datos;
        Loguear('2012-03-29','Se armó una respuesta '.json_encode($this->respuestas));
    }
    function mandar_todo_al_cliente(){
        echo json_encode($this->respuestas);
    }
    function obtener_mensaje(){
        return $this->respuestas['mensaje'];
    }
    function obtener_valor(){
        return $this->respuestas['ok'];
    }
}

class Respuesta_Positiva extends Respuestas{
    function __construct($datos=array()){
        parent::__construct(true,$datos);
    }
}

class Respuesta_Negativa extends Respuestas{
    function __construct($mensaje){
        parent::__construct(false,$mensaje);
    }
}
?>