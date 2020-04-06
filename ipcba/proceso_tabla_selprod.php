<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_tabla_selprod extends Procesos{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Tabla SelProd',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
        ));
    }
    function correr(){
        $tabla_selprod=$this->nuevo_objeto('Tabla_selprod');
        $tabla_selprod->ejecutar_instalacion(false);
    }
}
?>