<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_Agregar_registro_en_NovObs extends Proceso_Formulario{
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
            'titulo'=>'Altas y bajas manuales del cálculo',
            'permisos'=>array('grupo'=>'analista'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo','opciones'=>$tabla_periodos->lista_opciones(array('ingresando'=>'S'),'periodo'),'style'=>'width:100px'),
                 //'tra_calculo'=>array('tipo'=>'entero','label'=>'Calculo','def'=>'0'),
                 'tra_producto'=>array('tipo'=>'texto','label'=>'Producto','opciones'=>$tabla_productos->lista_opciones(array(),'producto'),'style'=>'width:100px'),
                 'tra_informante'=>array('tipo'=>'entero','label'=>'Informante','style'=>'width:100px'),
                 'tra_observacion'=>array('tipo'=>'entero','label'=>'Observacion','style'=>'width:50px'),
                 'tra_estado'=>array('tipo'=>'texto','label'=>'Estado','opciones'=>array('Alta','Baja'),'style'=>'width:50px'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'Agregar'),
        ));
    }
    function mostrarAntesDelFormulario(){
        enviar_grilla($this->salida,'novobs',null,null,array('filtro_manual'=>array('periodo'=>$this->periodos_para_filtro)));
    }
    function responder(){
        $tabla_novobs = new tabla_novobs();
        $tabla_novobs->contexto=$this;
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
            return new Respuesta_Negativa('Debe especificar un observacion');
        }
        $tabla_novobs->leer_uno_si_hay(array(
            'periodo'=>$this->argumentos->tra_periodo,        
            'calculo' => 0,
            'producto'=>$this->argumentos->tra_producto,
            'informante'=>$this->argumentos->tra_informante,
            'observacion'=>$this->argumentos->tra_observacion,
        ));        
        if($tabla_novobs->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una novedad con esa clave');
        }
        $tabla_novobs->valores_para_insert=(array(
            'periodo'       =>$this->argumentos->tra_periodo,
            'calculo'       => 0,
            'producto'      =>$this->argumentos->tra_producto,
            'informante'    =>$this->argumentos->tra_informante,
            'observacion'   =>$this->argumentos->tra_observacion ,           
            'estado'        =>$this->argumentos->tra_estado,
            'usuario'       =>$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"],
        ));
        $tabla_novobs->ejecutar_insercion();
        return new Respuesta_Positiva('Registro Insertado');
    }
}
?>