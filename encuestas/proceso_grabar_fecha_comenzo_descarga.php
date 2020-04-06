<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_grabar_fecha_comenzo_descarga extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Grabar fecha_comenzo_descarga',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_enc'=>array(),
                'tra_fecha_hora'=>array('invisible'=>true,'tipo'=>'fecha','def'=>date_format(new DateTime(), "Y-m-d H:i:s")),                
            ),
            'boton'=>array('id'=>'guardar'),
        ));
    }
    function responder(){
        Loguear('2012-03-05','antes de grabar');
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        $tabla_plana_tem_=$this->nuevo_objeto('Tabla_plana_TEM_');
        $tabla_plana_tem_->update_TEM($this->argumentos->tra_enc,array(
            'fecha_comenzo_descarga'=>$ahora,
        ));
        return new Respuesta_Positiva("Fecha comenzo descarga actualizada");
    }

}

?>