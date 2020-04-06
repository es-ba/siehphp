<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_cambiar_plazo_req extends Proceso_cambiar_atributo_req{
    function __construct(){
        parent::__construct(null);
        $this->cambiante='plazo';
    }
}

class Proceso_cambiar_prioridad_req extends Proceso_cambiar_atributo_req{
    function __construct(){
        parent::__construct(null);
        $this->cambiante='prioridad';
    }
}

class Proceso_cambiar_costo_req extends Proceso_cambiar_atributo_req{
    function __construct(){
        parent::__construct(null);
        $this->cambiante='costo';
    }
}

class Proceso_cambiar_atributo_req extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){        
        parent::post_constructor();
        $tabla_proyectos=$this->nuevo_objeto("Tabla_proyectos");   
        $this->definir_parametros(array(   
            'titulo'=>'Cambiar '.$this->cambiante.' a un requerimiento',
            'submenu'=>PROCESO_INTERNO,
            'parametros'=>array(
                'tra_proy'=>array('label'=>'nombre del proyecto','opciones'=>$tabla_proyectos->lista_opciones(array())),
                'tra_req'=>array('label'=>'código de requerimiento'),
                ('tra_nuevo_'.$this->cambiante)=>array('label'=>$this->cambiante.' del requerimiento'), 
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_cambiar','value'=>'grabar >>')
            ,
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;  
        $nuevo_valor=$this->argumentos->{'tra_nuevo_'.$this->cambiante};
        $tabla_requerimientos=$this->nuevo_objeto("Tabla_requerimientos");         
        $tabla_reqnov=$this->nuevo_objeto("Tabla_req_nov");         
        if(!$this->argumentos->tra_proy ){
            return new Respuesta_Negativa('Debe especificar proyecto');
        }
        if(!$this->argumentos->tra_req){
            return new Respuesta_Negativa('Debe especificar un codigo de requerimiento');
        }
        if(!$nuevo_valor){            
            return new Respuesta_Negativa('Debe especificar un valor para '.$this->cambiante.' obligatoriamente');
        }
        //$tabla_requerimientos->contexto=$this;
        $tabla_requerimientos->leer_uno_si_hay(array(
            'req_proy'=>$this->argumentos->tra_proy,        
            'req_req'=>$this->argumentos->tra_req,
        ));        
        if(!$tabla_requerimientos->obtener_leido()){
            return new Respuesta_Negativa('No existe un requerimiento con ese código');
        }
        //$valor_anterior=$tabla_requerimientos->datos->{'req_'.$this->cambiante};
        $valor_anterior=($this->cambiante!='plazo' ? $tabla_requerimientos->datos->{'req_'.$this->cambiante} : date_format(date_create($tabla_requerimientos->datos->req_plazo),'d-m-Y'));
        //$plazo = (is_null($tabla_requerimientos->datos->req_plazo) ? null : date_format(date_create($tabla_requerimientos->datos->req_plazo),'d-m-Y'));

        
        $tabla_requerimientos->valores_para_update=(array(
            'req_'.$this->cambiante => $nuevo_valor,
        ));
        
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
            'reqnov_reqest'      =>$ultest,
            'reqnov_comentario'  =>'cambio de '.$this->cambiante.' de '.$valor_anterior.' a '.$nuevo_valor,
            'reqnov_campo'       =>$this->cambiante,
            'reqnov_anterior'    =>$valor_anterior,
            'reqnov_actual'      =>$nuevo_valor,
            'reqnov_tlg'         =>obtener_tiempo_logico($this),
        ));
        $tabla_reqnov->ejecutar_insercion();              
        $tabla_requerimientos->ejecutar_update_unico(array('req_proy'=>$this->argumentos->tra_proy, 'req_req'=>$this->argumentos->tra_req));
        return new Respuesta_Positiva("El dato {$this->cambiante} fue modificado con éxito");
    }
}
?>