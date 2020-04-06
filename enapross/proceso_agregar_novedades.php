<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_agregar_novedades extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        
        
$tabla_tipo_nov=$this->nuevo_objeto("Tabla_tipo_nov");
$tabla_importancia=$this->nuevo_objeto("Tabla_importancia");
$tabla_usuarios=$this->nuevo_objeto("Tabla_usuarios");

$this->definir_parametros(array(   
    'titulo'=>'Agregar novedad',
    'submenu'=>'novedades',
    'para_produccion'=>true,
    'parametros'=>array(
        'tra_ope'=>array('label'=>'operativo','style'=>'width:100px','def'=>'enapross','invisible'=>true),
        'tra_nov'=>array('label'=>'novedad','style'=>'width:100px', 'placeholder'=>'auto','td_width'=>110,'tipo'=>'entero'),
        'tra_titulo'=>array('label'=>'título','style'=>'width:200px', 'td_colspan'=>3), 
        'tra_tipo'=>array('label'=>'tipo de novedad','style'=>'width:100px','opciones'=>$tabla_tipo_nov->lista_opciones(array()), 'td_colspan'=>3, 'def'=>'novedad'), 
        'tra_importancia'=>array('label'=>'importancia', 'style'=>'width:50px','opciones'=>$tabla_importancia->lista_opciones(array()), 'td_colspan'=>3, 'def'=>'baja'), 
        'tra_detalle'=>array('id'=>'tra_detalle','label'=>'detalle','style'=>'width:700px;height:200px;font-size:80%', 'td_colspan'=>3,'type'=>'textarea'/*,'onkeypress'=>"retorno_de_carro('tra_detalles','tra_componente');"*/),
        //'tra_usu'=>array('label'=>'usuario', 'td_colspan'=>3),                
        //'tra_adjunto'=>array('label'=>'adjunto', 'td_colspan'=>3), 
    ),
    //'bitacora'=>true,
    'boton'=>array('id'=>'boton_agregar_novedades','value'=>'agregar >>'),
        ));
    }
    function responder(){
        global $esta_es_la_base_en_produccion;
        $tabla_novedades = new tabla_novedades();
        $tabla_novedades->contexto=$this;
        if(!$this->argumentos->tra_nov){
            //return new Respuesta_Negativa('Debe especificar un código de novedad');
            $this->argumentos->tra_nov = $tabla_novedades->obtener_maximo(array(
                'nov_ope'=>$this->argumentos->tra_ope
            ), 'case when es_numero(nov_nov) then nov_nov::numeric else 0::numeric end')+1;
        }
        if(!$this->argumentos->tra_titulo){
            return new Respuesta_Negativa('Debe especificar un título para la novedad');
        }
        if(!$this->argumentos->tra_tipo){
            return new Respuesta_Negativa('Debe especificar un tipo para la novedad');
        }
        if(!$this->argumentos->tra_detalle){
            return new Respuesta_Negativa('Debe especificar un detalle para la novedad');
        }
        $tabla_novedades->leer_uno_si_hay(array(
            'nov_ope'=>$this->argumentos->tra_ope,        
            'nov_nov'=>$this->argumentos->tra_nov,
        ));        
        if($tabla_novedades->obtener_leido()){
            return new Respuesta_Negativa('Ya existe una novedad con ese código');
        }
        $tabla_novedades->valores_para_insert=(array(
            'nov_ope'        =>$this->argumentos->tra_ope,
            'nov_nov'        =>$this->argumentos->tra_nov,
            'nov_titulo'     =>$this->argumentos->tra_titulo,
            'nov_tipo'       =>$this->argumentos->tra_tipo,
            'nov_importancia'=>$this->argumentos->tra_importancia ,           
            'nov_detalle'   =>$this->argumentos->tra_detalle,
            //'nov_usu'        =>$this->argumentos->tra_usu,
            //'nov_adjunto'    =>$this->argumentos->tra_adjunto,
        ));
        $tabla_novedades->ejecutar_insercion();
        $this->salida=new Armador_de_salida(true);
        $this->salida->abrir_grupo_interno('editor_tabla',array('tipo'=>'table','border'=>'single', 'style'=>'width:100%'));             
            $this->salida->abrir_grupo_interno('',array('tipo'=>'tr'));    
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','style'=>'width:15%'));  
                    $this->salida->enviar('','',array());
                $this->salida->cerrar_grupo_interno();
                $this->salida->abrir_grupo_interno('',array('tipo'=>'td','style'=>'width:50%'));  
                    $this->salida->enviar('La novedad fue ingresada con éxito - Código de novedad: '.$this->argumentos->tra_nov);
                $this->salida->cerrar_grupo_interno();
                $this->salida->enviar_script("ir_a_url('enapross.php')");
            $this->salida->cerrar_grupo_interno();
        $this->salida->cerrar_grupo_interno();            
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>