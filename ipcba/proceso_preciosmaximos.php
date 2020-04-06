<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_preciosmaximos extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Precios máximos',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    
    function correr(){
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_periodos->lista_opciones(array(),'periodo');
        parent::correr();
    }

    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_controlatributos'));
        enviar_grilla($this->salida,'vista_precios_maximos_vw',null,'div_controlatributos',array('filtro_manual'=>array('periodo'=>$tra_periodo)));
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>