<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_frecuencia_variables extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>(substr($GLOBALS['NOMBRE_APP'],0,3)=='eah'&& $GLOBALS['anio_operativo']>=2015)?'Obtener frecuencias de variables relevadas - Modo '. $_SESSION['modo_encuesta']:'Obtener frecuencias de variables relevadas',
            'submenu'=>'procesamiento',
            'parametros'=>array(
                'tra_ope'=>array('label'=>'operativo','def'=>$GLOBALS['NOMBRE_APP'],'invisible'=>true),
                'tra_var'=>array('label'=>'variable relevada','def'=>'i1'), 
                'tra_estado_desde'=>array('label'=>'estado desde','def'=>'77','style'=>'width:40px'),
                'tra_estado_hasta'=>array('label'=>'estado hasta','def'=>'79','style'=>'width:40px'),
                'tra_agregar_variables'=>array('label'=>'mostrar variables','aclaracion'=>'agregar estas a las variables de contexto (separarlas con coma)','style'=>'width:300px'),
                
             //   'tra_estado'=>array('label'=>'estado','disabled'=>true,'style'=>'width:50px','def'=>'79', 'aclaracion'=>'Sólo estado 79'),
            ),
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'procesamiento'),
            'bitacora'=>true,
            'boton'=>array('id'=>'tabular'),
        ));
    }
    function responder(){
        global $db;
        $this->salida=new Armador_de_salida(true);
        $this->salida->enviar('','',array('id'=>'div_grilla'));
        if (!$this->argumentos->tra_estado_desde){
            return new Respuesta_Negativa('Debe especificar estado_desde');        
        }
        if (!$this->argumentos->tra_estado_hasta){
            return new Respuesta_Negativa('Debe especificar estado_hasta');        
        }
        enviar_grilla($this->salida,'var_tabulado',array('var_var'=>$this->argumentos->tra_var,'pla_estado_desde'=>$this->argumentos->tra_estado_desde,
                      'pla_estado_hasta'=>$this->argumentos->tra_estado_hasta, 'pla_agregar_variables'=>$this->argumentos->tra_agregar_variables),'div_grilla');
        return $this->salida->obtener_una_respuesta_HTML();
    }
}

?>