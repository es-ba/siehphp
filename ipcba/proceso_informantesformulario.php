<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_informantesformulario extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Informantes por Formulario',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Informantes',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
                 'tra_periodo_desde'=>array('tipo'=>'texto','label'=>'Periodo desde'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    
    function correr(){
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_periodos->lista_opciones(array(),'periodo');
        $this->parametros->parametros['tra_periodo_desde']['opciones']=$tabla_periodos->lista_opciones(array(),'periodo');
        parent::correr();
    }

    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $tra_periodo_desde=$this->argumentos->tra_periodo_desde;
        $periodos_para_filtro = '# >=' . $tra_periodo_desde . '&' . '<=' . $tra_periodo;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_controlatributos'));
        enviar_grilla($this->salida,'vista_informantesformulario',null,'div_controlatributos',array('filtro_manual'=>array('periodo'=>$periodos_para_filtro)));
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>