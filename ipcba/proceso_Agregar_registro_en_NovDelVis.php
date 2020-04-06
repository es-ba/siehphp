<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
class Proceso_Agregar_registro_en_NovDelVis extends Proceso_Formulario{
    function __construct($periodos_para_filtro){
        $this->periodos_para_filtro=$periodos_para_filtro;
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $this->definir_parametros(array(
            'titulo'=>'Borrar visitas',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'recep_gabinete'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo','opciones'=>$tabla_periodos->lista_opciones(array('ingresando'=>'S'),'periodo'),'style'=>'width:100px'),
                 'tra_informante'=>array('tipo'=>'entero','label'=>'Informante','style'=>'width:100px'),
                 'tra_visita'=>array('tipo'=>'entero','label'=>'Visita','style'=>'width:30px'),
                 'tra_formulario'=>array('tipo'=>'entero','label'=>'Formulario','style'=>'width:60px'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'Agregar'),
        ));
    }
    function mostrarAntesDelFormulario(){
        enviar_grilla($this->salida,'novdelvis',null,null,array('filtro_manual'=>array('periodo'=>$this->periodos_para_filtro)));
    }
    function responder(){
        $tabla_novdelvis = new tabla_novdelvis();
        $tabla_novdelvis->contexto=$this;
        if(!$this->argumentos->tra_periodo){
            return new Respuesta_Negativa('Debe especificar un periodo');
        }
        if(!$this->argumentos->tra_informante){
            return new Respuesta_Negativa('Debe especificar un informante');
        }
        if(!$this->argumentos->tra_visita){
            return new Respuesta_Negativa('Debe especificar una visita');
        }
        if(!$this->argumentos->tra_formulario){
            return new Respuesta_Negativa('Debe especificar un formulario');
        }
        $tabla_novdelvis->leer_uno_si_hay(array(
            'periodo'=>$this->argumentos->tra_periodo,        
            'informante'=>$this->argumentos->tra_informante,
            'visita'=>$this->argumentos->tra_visita,
            'formulario'=>$this->argumentos->tra_formulario,
        ));        
        if($tabla_novdelvis->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una novedad con esa clave');
        }
        $tabla_novdelvis->valores_para_insert=(array(
            'periodo'       =>$this->argumentos->tra_periodo,
            'informante'    =>$this->argumentos->tra_informante,
            'visita'        =>$this->argumentos->tra_visita,
            'formulario'    =>$this->argumentos->tra_formulario ,           
            'usuario'       =>$_SESSION["{$GLOBALS['NOMBRE_APP']}/{$GLOBALS['NOMBRE_DB']}_usu_usu"],
        ));
        $tabla_novdelvis->ejecutar_insercion();
        return new Respuesta_Positiva('Registro Insertado');
    }
}
?>