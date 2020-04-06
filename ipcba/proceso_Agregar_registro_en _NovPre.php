<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_Agregar_registro_en_NovPre extends Proceso_Formulario{
    function __construct($periodos_para_filtro){
        $this->periodos_para_filtro=$periodos_para_filtro;
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $tabla_productos=$this->nuevo_objeto("Tabla_productos");
        $tabla_productos->definir_campos_orden(array('producto'));
        $this->definir_parametros(array(
            'titulo'=>'Anulación de precios',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo','opciones'=>$tabla_periodos->lista_opciones(array('ingresando'=>'S'),'periodo'),'style'=>'width:100px'),
                 'tra_producto'=>array('tipo'=>'texto','label'=>'Producto','opciones'=>$tabla_productos->lista_opciones(array(),'producto'),'style'=>'width:100px'),
                 'tra_informante'=>array('tipo'=>'entero','label'=>'Informante','style'=>'width:100px'),
                 'tra_observacion'=>array('tipo'=>'entero','label'=>'Observacion','style'=>'width:50px'),
                 'tra_visita'=>array('tipo'=>'entero','label'=>'Visita','style'=>'width:50px'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'Agregar'),
        ));
    }
    function mostrarAntesDelFormulario(){
        enviar_grilla($this->salida,'novpre',null,null,array('filtro_manual'=>array('periodo'=>$this->periodos_para_filtro)));
    }
    function responder(){
        $tabla_novpre = new tabla_novpre();
        $tabla_novpre->contexto=$this;
        if(!$this->argumentos->tra_periodo){
            return new Respuesta_Negativa('Debe especificar un periodo');
        }
        if(!$this->argumentos->tra_producto){
            return new Respuesta_Negativa('Debe especificar un producto');
        }
        if(!$this->argumentos->tra_informante){
            return new Respuesta_Negativa('Debe especificar un informante');
        }
        if(!$this->argumentos->tra_observacion){
            return new Respuesta_Negativa('Debe especificar una observacion');
        }
        if(!$this->argumentos->tra_visita){
            return new Respuesta_Negativa('Debe especificar una visita');
        }
        $tabla_novpre->leer_uno_si_hay(array(
            'periodo'=>$this->argumentos->tra_periodo,        
            'producto'=>$this->argumentos->tra_producto,
            'informante'=>$this->argumentos->tra_informante,
            'observacion'=>$this->argumentos->tra_observacion,
            'visita'=>$this->argumentos->tra_visita,
        ));        
        if($tabla_novpre->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una novedad con esa clave');
        }
        $tabla_novpre->valores_para_insert=(array(
            'periodo'       =>$this->argumentos->tra_periodo,
            'producto'      =>$this->argumentos->tra_producto,
            'informante'    =>$this->argumentos->tra_informante,
            'observacion'   =>$this->argumentos->tra_observacion ,           
            'visita'        =>$this->argumentos->tra_visita,
            'usuario'       =>$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"],
        ));
        $tabla_novpre->ejecutar_insercion();
        return new Respuesta_Positiva('Registro Insertado');
    }
}
?>