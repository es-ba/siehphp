<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_agregar_adjuntos_requerimiento extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_proyectos=$this->nuevo_objeto("Tabla_proyectos");    
        $tabla_requerimientos=$this->nuevo_objeto("Tabla_requerimientos");            
        $this->definir_parametros(array(   
            'titulo'=>'Agregar adjunto a un requerimiento',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_proy'=>array('label'=>'nombre del proyecto', 'opciones'=>$tabla_proyectos->lista_opciones(array()), 'pide_opciones'=>array('tra_req')),
                'tra_req'=>array('label'=>'código de requerimiento','opciones'=>$tabla_requerimientos->lista_opciones(array())),                
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'buscar'/*,'value'=>'buscar >>'*/)
            ,
        ));
    }
}    
?>