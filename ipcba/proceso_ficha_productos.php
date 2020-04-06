<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ficha_producto extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Ficha de producto',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'analista_cuadros'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_producto'=>array('tipo'=>'texto','label'=>'Producto'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    function responder(){
        $tra_producto=$this->argumentos->tra_producto;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_productos'));
        $this->salida->enviar('','',array('id'=>'div_especificaciones'));
        $this->salida->enviar('','',array('id'=>'div_atributos'));
        $this->salida->enviar('','',array('id'=>'div_espcom'));
        $this->salida->enviar('','',array('id'=>'div_divisiones'));
        $this->salida->enviar('','',array('id'=>'div_formularios'));
        $this->salida->enviar('','',array('id'=>'div_controlrango'));
        enviar_grilla($this->salida,'productos',array('producto'=>$tra_producto),'div_productos');
        enviar_grilla($this->salida,'especificaciones',array('producto'=>$tra_producto),'div_especificaciones');
        enviar_grilla($this->salida,'prodatr',array('producto'=>$tra_producto),'div_atributos');
        enviar_grilla($this->salida,'prodespecificacioncompleta',array('producto'=>$tra_producto),'div_espcom');
        enviar_grilla($this->salida,'proddiv',array('producto'=>$tra_producto),'div_divisiones');
        enviar_grilla($this->salida,'prodformularios',array('producto'=>$tra_producto),'div_formularios');
        enviar_grilla($this->salida,'prodcontrolrangos',array('producto'=>$tra_producto),'div_controlrango');
        //$this->salida->enviar('próximamente habrá más datos del producto...');
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>