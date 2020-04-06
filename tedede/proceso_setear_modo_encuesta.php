<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "proceso_formulario.php";

class Proceso_setear_modo_encuesta extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Cambiar Modo encuesta',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'pmodoenc'=>array('tipo'=>'texto','label'=>'Modo Encuesta')
            ),
            'boton'=>array('id'=>'guardar'),
        ));
    }
    function responder(){
        //global $hoy;
        //Loguear('2015-11-13','antes de setear'. var_export($this->argumentos->pmodoenc) );
        $_SESSION['modo_encuesta']=$this->argumentos->pmodoenc;
        $rta=$_SESSION['modo_encuesta'];
        return new Respuesta_Positiva($rta);
    }
}

?>
