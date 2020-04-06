<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
//require_once "vista_requerimientos.php";

class Grilla_monitoreo_viv_actividad extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){  
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Vista_monitoreo_viv_actividad");
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ir',
            'title'=>'abrir encuesta',
            'proceso'=>'ingresar_encuesta',
            'campos_parametros'=>array('tra_enc'=>null,'tra_hn'=>array('forzar_valor'=>-951)),
            'y_luego'=>'boton_ingresar_encuesta',
        );
    }
}
?>