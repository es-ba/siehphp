<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_tabla_selprodatr extends Procesos{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Tabla SelProdAtr',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
        ));
    }
    function correr(){
        $tabla_selprodatr=$this->nuevo_objeto('Tabla_selprodatr');
        $tabla_selprodatr->ejecutar_instalacion(false);
    }
}
?>