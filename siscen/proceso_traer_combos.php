<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_traer_combos extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(   
            'titulo'=>'Traer combos filtrados',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_campo_origen'=>array('label'=>'nombre del campo de origen'),
                'tra_valor'=>array('label'=>'valor del campo de origen'),
                'tra_cuales'=>array('label'=>'combos a completar'),
            )
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        $rta=array();
        if($this->argumentos->tra_campo_origen !='tra_proy'){
            return new Respuesta_Negativa('Comportamiento no implementado, el campo debe referirse al proyecto');
        }
        $tabla_req = $this->nuevo_objeto('Tabla_requerimientos');
        foreach($this->argumentos->tra_cuales as $cual){ //ejemplo $cual = 'tra_req' tra_campo_origen = 'tra_proy' y tra_valor = 'EAH'
            if ($cual!='tra_req'){
                return new Respuesta_Negativa('Comportamiento no implementado, el campo debe referirse al requerimiento');
            }
            $opciones=array();
            $tabla_req->leer_varios(array(
                'req_proy'=>$this->argumentos->tra_valor
            ));
            while($tabla_req->obtener_leido()){
                $opciones[$tabla_req->datos->req_req]=array(
                $tabla_req->datos->req_req,
                $tabla_req->datos->req_titulo
                );
            }
            
            $rta['tra_req']=Armador_de_salida::tabla_opciones_para_combo($opciones,'tra_req','');
        }
        return new Respuesta_Positiva($rta);
    }
}
?>