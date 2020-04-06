<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_relpan extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Paneles',
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_periodo'));
        //$this->salida->enviar('','',array('id'=>'div_grupo'));
        enviar_grilla($this->salida,'relpan',array('periodo'=>$tra_periodo),'div_periodo');
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>