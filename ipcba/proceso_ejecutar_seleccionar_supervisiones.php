<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ejecutar_seleccionar_supervisiones extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Correr el algoritmo de selección',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>PROCESO_INTERNO,
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período'),
                'tra_panel'=>array('tipo'=>'texto','label'=>'Panel',),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_ver','value'=>'seleccionar'),
        ));
    }
    function responder(){
    // si ya estaba seleccionado, no ejecutar y la grilla tiene que ir READ ONLY:
        $this->salida=new Armador_de_salida(true);
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT generacionsupervisiones FROM cvp.relpan WHERE periodo=:periodo and panel=:panel
SQL
           , array(':periodo'=>$this->argumentos->tra_periodo, ':panel'=>$this->argumentos->tra_panel)));
        $fila=$cursor->fetchObject();
        $fechasupervision=$fila->generacionsupervisiones;  
        if(is_null($fechasupervision)){
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                SELECT disponible FROM cvp.relsup WHERE periodo=:periodo and panel=:panel and disponible ='S' limit 1
SQL
               , array(':periodo'=>$this->argumentos->tra_periodo, ':panel'=>$this->argumentos->tra_panel)));
            $fila=$cursor->fetchObject();
            //$sdisponible=$fila->disponible;  
            if(!$fila){
              return new Respuesta_Negativa('Debe especificar al menos un supervisor disponible');
            }else{
              $this->db->ejecutar_sql(new Sql("select cvp.seleccionar_supervisiones_aleatorias(:periodo, :panel)", array(':periodo'=>$this->argumentos->tra_periodo, ':panel'=>$this->argumentos->tra_panel)));
            }
        }else{
            $this->salida->enviar('La selección ya había sido realizada con anterioridad');
        }
        $this->salida->enviar('','',array('id'=>'resultados_supervision'));
        enviar_grilla($this->salida,'tareas_a_supervisar',array('periodo'=>$this->argumentos->tra_periodo,'panel'=>$this->argumentos->tra_panel,'supervisor'=>'#>0'),'resultados_supervision',array('simple'=>'true'));
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>