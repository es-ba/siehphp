<?php
//UTF-8:SÍ

require_once "lo_imprescindible.php";
require_once "contextos.php";
require_once "procesos.php";

class Proceso_ingresar_personal extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Ingresar personal nuevo',
            'submenu'=>'campo',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_num'=>array('label'=>'número de persona'),
                'tra_apellido'=>array('label'=>'apellido'),
                'tra_nombre'=>array('label'=>'nombre'),
                'tra_rol'=>array('label'=>'rol','def'=>'encuestador','opciones'=>array('encuestador','recuperador','supervisor','recepcionista','acom_campo','coor_campo','subcoor_campo')),
                'tra_dominio'=>array('label'=>'dominio'),
                'tra_comuna'=>array('label'=>'comuna'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_ingresar_persona','value'=>'ingresar persona >>')
            ,
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        if(!$this->argumentos->tra_nombre || !$this->argumentos->tra_apellido){
            return new Respuesta_Negativa('Debe especificar nombre y apellido');
        }
        if(!$this->argumentos->tra_rol){
            return new Respuesta_Negativa('Debe especificar un rol');
        }
        $this->argumentos->tra_dominio = $this->argumentos->tra_dominio?$this->argumentos->tra_dominio:null;
        $this->argumentos->tra_comuna = $this->argumentos->tra_comuna?$this->argumentos->tra_comuna:null;
        $tabla_personal = new tabla_personal();
        $tabla_personal->contexto=$this;
        $tabla_personal->leer_uno_si_hay(array(
            'per_per'=>$this->argumentos->tra_num,
        ));        
        if($tabla_personal->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una persona con ese número');
        }
        $tabla_personal->valores_para_insert=(array(
            'per_ope'       =>$GLOBALS['NOMBRE_APP'],
            'per_per'       =>$this->argumentos->tra_num,
            'per_nombre'    =>$this->argumentos->tra_nombre,
            'per_rol'       =>$this->argumentos->tra_rol,
            'per_apellido'  =>strtoupper($this->argumentos->tra_apellido),
            'per_dominio'   =>$this->argumentos->tra_dominio,
            'per_comuna'    =>$this->argumentos->tra_comuna,
        ));
        $tabla_personal->ejecutar_insercion();
        return new Respuesta_Positiva('La persona fue ingresada con éxito');
    }
}
?>