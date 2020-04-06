<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";

class Tabla_plana_TEM_ extends Tabla_planas{
    function update_TEM($encuesta,$variables_y_valores_a_cambiar){
        if(!isset($this->tabla_respuestas)){
            $this->tabla_respuestas=$this->contexto->nuevo_objeto("Tabla_respuestas");
        }
        foreach($variables_y_valores_a_cambiar as $variable=>$valor){
            $this->tabla_respuestas->valores_para_update=array('res_valor'=>$valor);
            $this->tabla_respuestas->ejecutar_update_unico(array_merge(
                claves_respuesta_vacia('res_'),
                array(
                    'res_ope'=>$GLOBALS['NOMBRE_APP'],
                    'res_for'=>'TEM',
                    'res_enc'=>$encuesta,
                    'res_var'=>$variable,
                )
            ));
        }
    }
}
class Tabla_plana_S1_  extends Tabla_planas{}
class Tabla_plana_S1_P extends Tabla_planas{}
class Tabla_plana_I1_  extends Tabla_planas{}
class Tabla_plana_A1_  extends Tabla_planas{}
class Tabla_plana_A1_X extends Tabla_planas{}

?>