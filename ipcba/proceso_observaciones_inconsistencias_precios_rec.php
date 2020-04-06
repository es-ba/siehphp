<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_observaciones_inconsistencias_precios_rec extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $this->definir_parametros(array(
            'titulo'=>'Control de Inconsistencias de Precios Recepción',
            'permisos'=>array('grupo'=>'analista','grupo1'=>'jefe_campo','grupo2'=>'recepcionista','grupo3'=>'coordinador'),
            'submenu'=>'Gabinete',
            'para_produccion'=>true,
            'parametros'=>array(
                 'tra_periodo'=>array('tipo'=>'texto','label'=>'Periodo'),
                 'tra_paneldesde'=>array('tipo'=>'entero','label'=>'Panel Desde'),
                 'tra_panelhasta'=>array('tipo'=>'entero','label'=>'Panel Hasta'),
                 'tra_tareadesde'=>array('tipo'=>'entero','label'=>'Tarea Desde'),
                 'tra_tareahasta'=>array('tipo'=>'entero','label'=>'Tarea Hasta'),
             ),
            'bitacora'=>true,
            'boton'=>array('id'=>'ver'),
        ));
    }
    
    function correr(){
        $tabla_periodos=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodos->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_periodos->lista_opciones(array(),'periodo');
        parent::correr();
    }

    function responder(){
        $tra_periodo=$this->argumentos->tra_periodo;
        $tra_paneldesde=$this->argumentos->tra_paneldesde;
        $tra_panelhasta=$this->argumentos->tra_panelhasta;
        $tra_tareadesde=$this->argumentos->tra_tareadesde;
        $tra_tareahasta=$this->argumentos->tra_tareahasta;
        $this->salida=new Armador_de_salida(true);
        $mifiltropanel="#=".$tra_paneldesde;
        for ($i=$tra_paneldesde+1;$i<=$tra_panelhasta;$i++ ){
            //Ejemplo:#=7|=8|=9|=10|=11|=12
            $mifiltropanel=$mifiltropanel."|=".$i;
        }
        $mifiltrotarea="#=".$tra_tareadesde;
        for ($i=$tra_tareadesde+1;$i<=$tra_tareahasta;$i++ ){
            //Ejemplo:#=7|=8|=9|=10|=11|=12
            $mifiltrotarea=$mifiltrotarea."|=".$i;
        }
        $this->salida->enviar('','',array('id'=>'div_relvis'));
        if(is_null($tra_tareadesde) or is_null($tra_tareahasta)){
            enviar_grilla($this->salida,'relpre_control_rangos_recepcion',null,'div_relvis',array('filtro_manual'=>array('periodo'=>$tra_periodo,'panel'=>$mifiltropanel)));
        }else{
            enviar_grilla($this->salida,'relpre_control_rangos_recepcion',null,'div_relvis',array('filtro_manual'=>array('periodo'=>$tra_periodo,'panel'=>$mifiltropanel,'tarea'=>$mifiltrotarea)));
        }
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>