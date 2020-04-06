<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ficha_verificar_recepcion extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Ficha verificar recepción',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'recepcionista','grupo1'=>'jefe_campo','grupo1'=>'coordinador'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>false,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
                 'tra_informante'=>array('tipo'=>'entero','label'=>'Informante'),
                 'tra_visita'=>array('tipo'=>'entero','label'=>'Visita'),
                 'tra_formulario'=>array('tipo'=>'entero','label'=>'Formulario'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $tra_informante=$this->argumentos->tra_informante;
        $tra_visita=$this->argumentos->tra_visita;
        $tra_formulario=$this->argumentos->tra_formulario;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_controlnormalizables')); //atributos normalizables sin dato
        $this->salida->enviar('','',array('id'=>'div_controlatributos'));     //atributos fuera de rango
        $this->salida->enviar('','',array('id'=>'div_respuestasinprecios'));  //respuesta efectiva sin precios
        $this->salida->enviar('','',array('id'=>'div_controlvigencias'));     //control de las vigencias
        $this->salida->enviar('','',array('id'=>'div_controlrangos'));        //precios fuera de rango
        enviar_grilla($this->salida,'vista_control_normalizables_sindato',null,'div_controlnormalizables',array('filtro_manual'=>array('periodo'=>$tra_periodo,'informante'=>$tra_informante,'visita'=>$tra_visita,'formulario'=>$tra_formulario)));
        enviar_grilla($this->salida,'vista_control_atributos',null,'div_controlatributos',array('filtro_manual'=>array('periodo'=>$tra_periodo,'informante'=>$tra_informante,'visita'=>$tra_visita,'formulario'=>$tra_formulario)));
        enviar_grilla($this->salida,'vista_exportar_hdr_efectivossinprecio',null,'div_respuestasinprecios',array('filtro_manual'=>array('periodo'=>$tra_periodo,'informante'=>$tra_informante,'visita'=>$tra_visita,'formulario'=>$tra_formulario)));
        enviar_grilla($this->salida,'vista_controlvigencias',null,'div_controlvigencias',array('filtro_manual'=>array('periodo'=>$tra_periodo,'informante'=>$tra_informante)));
        enviar_grilla($this->salida,'vista_control_rangos',null,'div_controlrangos',array('filtro_manual'=>array('periodo'=>$tra_periodo,'informante'=>$tra_informante,'visita'=>$tra_visita,'formulario'=>$tra_formulario)));
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>