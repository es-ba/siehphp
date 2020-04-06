<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_canasta_producto extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Canasta por Producto',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
                 'tra_hogar'=>array('tipo'=>'texto','label'=>'Hogar'),
                 'tra_agrupacion'=>array('tipo'=>'texto','label'=>'Agrupacion'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    
    function correr(){
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_periodos->lista_opciones(array(),'periodo');
        $tabla_hogares=$this->nuevo_objeto("Tabla_hogares");
        $tabla_hogares->definir_campos_orden(array('comun.para_ordenar_numeros(hogar)'));
        $this->parametros->parametros['tra_hogar']['opciones']=$tabla_hogares->lista_opciones(array(),'hogar');
        $tabla_agrupaciones=$this->nuevo_objeto("Tabla_agrupaciones");
        $tabla_periodos->definir_campos_orden(array('agrupacion'));
        $this->parametros->parametros['tra_agrupacion']['opciones']=$tabla_agrupaciones->lista_opciones(array(),'agrupacion');
        parent::correr();
    }

    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $tra_hogar=$this->argumentos->tra_hogar;
        $tra_agrupacion=$this->argumentos->tra_agrupacion;
        $this->salida=new Armador_de_salida(true);
        //$mifiltro="#>=$tra_paneldesde & <=$tra_panelhasta";
        $this->salida->enviar('','',array('id'=>'div_canastaproductos'));
        enviar_grilla($this->salida,'vista_canasta_producto',null,'div_canastaproductos',array('filtro_manual'=>array('periodo'=>$tra_periodo,'hogar'=>$tra_hogar,'agrupacion'=>$tra_agrupacion)));
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>