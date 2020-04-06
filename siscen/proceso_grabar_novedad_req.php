<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_grabar_novedad_req extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){        
        parent::post_constructor();
        $tabla_proyectos=$this->nuevo_objeto("Tabla_proyectos");
        $tabla_reqest=$this->nuevo_objeto("Tabla_req_est");
        
        $this->definir_parametros(array(   
            'titulo'=>'Grabar novedad a un requerimiento',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_proy'=>array('label'=>'nombre del proyecto','opciones'=>$tabla_proyectos->lista_opciones(array())),
                'tra_req'=>array('label'=>'código de requerimiento'),
                'tra_comentario'=>array('label'=>'comentario de la novedad'), 
                'tra_origen'=>array('label'=>'origen'),//,'opciones'=>$tabla_reqest->lista_opciones(array())),//'no_cambiar_estado'
                'tra_accion'=>array('label'=>'accion'),//puede venir null 
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_grabar_nov_req','value'=>'grabar >>')
            ,
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;       
        $tabla_reqestflu = new tabla_req_est_flu();
        $tabla_reqestflu->contexto=$this;        
        $tabla_reqestflu->leer_unico(array(
            'reqestflu_origen'=>$this->argumentos->tra_origen,
            'reqestflu_accion'=>$this->argumentos->tra_accion,
        ));         
        if(!$this->argumentos->tra_proy ){
            return new Respuesta_Negativa('Debe especificar proyecto');
        }
        if(!$this->argumentos->tra_req){
            return new Respuesta_Negativa('Debe especificar un código de requerimiento');
        }
        if(!$this->argumentos->tra_comentario && $tabla_reqestflu->datos->reqestflu_comentario_obligatorio){            
            return new Respuesta_Negativa('Debe especificar un comentario obligatoriamente');
        }
        $tabla_requerimientos=$this->nuevo_objeto("Tabla_requerimientos");        
        $tabla_requerimientos->contexto=$this;
        
        $tabla_requerimientos->leer_uno_si_hay(array(
            'req_proy'=>$this->argumentos->tra_proy,        
            'req_req'=>$this->argumentos->tra_req,
        ));        
        
        if(!$tabla_requerimientos->obtener_leido()){
            return new Respuesta_Negativa('No existe un requerimiento con ese código');
        }
        $tabla_reqnov=$this->nuevo_objeto("Tabla_req_nov");        
        $tabla_reqnov->contexto=$this;        
        $maxnov=0;
        $ultest='';
        $filtro_reqnov=array(
            'reqnov_proy'       =>$this->argumentos->tra_proy,
            'reqnov_req'        =>$this->argumentos->tra_req,            
        );
        $tabla_reqnov->leer_varios($filtro_reqnov);
        while ($tabla_reqnov->obtener_leido()){
            if($tabla_reqnov->datos->reqnov_reqnov>$maxnov){    
                $maxnov=$tabla_reqnov->datos->reqnov_reqnov;
                $ultest=$tabla_reqnov->datos->reqnov_reqest;
            }
        }
        $maxnov++;
        $tabla_reqnov->valores_para_insert=(array(
            'reqnov_proy'        =>$this->argumentos->tra_proy,
            'reqnov_req'         =>$this->argumentos->tra_req,
            'reqnov_reqnov'      =>$maxnov,
            'reqnov_comentario'  =>$this->argumentos->tra_comentario,
            'reqnov_reqest'      =>$tabla_reqestflu->datos->reqestflu_destino,
            'reqnov_tlg'         =>obtener_tiempo_logico($this),
        ));
        $tabla_reqnov->ejecutar_insercion();
        return new Respuesta_Positiva('La novedad fue ingresada con éxito');
    }
}
?>