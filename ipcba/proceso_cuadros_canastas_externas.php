<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_cuadros_canastas_externas extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        $this->definir_parametros(array(
              'titulo'=>'Cuadros Canastas Externas Marzo 2022 - Junio 2022',
              'permisos'=>array('grupo'=>'analista_cuadros'),
              'submenu'=>'Resultados',
              'para_produccion'=>true,
              'parametros'=>array(
                 'tra_periodo_desde'=>array('tipo'=>'texto','label'=>'Período desde','def'=> 'a2022m03'),
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=> 'a2022m06' ),
               ),
              'bitacora'=>true,
              'botones'=>array(
                    array('id'=>'boton_ver','style'=>'visibility:hidden','value'=>'ver','otro_control'=>
                       array('id'=>'boton_exportar','innerText'=>'exportar', 'tipo'=>'a', 'href'=>'./canastas_externas')
                    )
               )
            ));
    }
}
?>