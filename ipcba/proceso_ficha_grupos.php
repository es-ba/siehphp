<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ficha_grupo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Ficha de grupo',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_agrupacion'=>array('tipo'=>'texto','label'=>'Agrupacion' ,'def'=>'Z'),
                 'tra_grupo'=>array('tipo'=>'texto','label'=>'Grupo' ,'def'=>'Z01'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    function responder(){
        $tra_agrupacion=$this->argumentos->tra_agrupacion;
        $tra_grupo=$this->argumentos->tra_grupo;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_agrupacion','id'=>'div_grupo'));
        //$this->salida->enviar('','',array('id'=>'div_grupo'));
        enviar_grilla($this->salida,'grupos',array('agrupacion'=>$tra_agrupacion, 'grupo'=>$tra_grupo),'div_grupo');
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>