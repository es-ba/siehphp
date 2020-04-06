<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ingresar_tem extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Ingresar a la TEM de la encuesta',
            'submenu'=>'campo',
            'permisos'=>array('grupo'=>'recepcionista'),
            'para_produccion'=>false,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array('tipo'=>'entero','label'=>'Número de encuesta'),
                'tra_hn' =>array('tipo'=>'entero','label'=>'Número de la calle'),
            ),
            'boton'=>array('id'=>'boton_ingresar_encuesta','value'=>'ingresar','onclick'=>'boton_ingresar_tem()'),
        ));
    }
    function responder(){
        $this->argumentos->tra_ope=$GLOBALS['NOMBRE_APP'];//OJO: Generalizar
        return new Respuesta_Positiva(Proceso_leer_encuesta_a_localStorage::parte_proceso_leer_a_ls_encuesta($this,$this->argumentos));
    }
}

?>