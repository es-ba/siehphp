<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "proceso_ejecutar_seleccionar_supervisiones.php";

class Proceso_seleccionar_supervisiones extends Proceso_Formulario{
    function __construct(){
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        $def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
        parent::__construct(array(
            'titulo'=>'Seleccionar',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>'Supervisiones',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo),
                'tra_panel'=>array('tipo'=>'texto','label'=>'Panel',),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_ver','value'=>'preparar'),
        ));
    }
    function correr(){
        $tabla_periodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_periodo->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_periodo->lista_opciones(array('ingresando'=>'S','periodo'=>'#>=a2014m01'));
        
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT r.periodo, r.panel 
            FROM cvp.relpan r inner join cvp.periodos p on r.periodo = p.periodo
            WHERE r.periodo>='a2014m01' and r.generacionsupervisiones is null and p.ingresando='S'
            order by r.periodo desc, r.panel limit 1
SQL
        ));
        $fila=$cursor->fetchObject();
        $this->parametros->parametros['tra_periodo']['def']=$fila->periodo;
        $this->parametros->parametros['tra_panel']['def']=$fila->panel;
        // en periodos el filtro será algo así como array('cerrado'=>false)
        parent::correr();
    }
    function responder(){
        $this->salida=new Armador_de_salida(true);
        // si ya estaba seleccionado esta parte tiene que ir READ ONLY:
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT generacionsupervisiones FROM cvp.relpan WHERE periodo=:periodo and panel=:panel
SQL
           , array(':periodo'=>$this->argumentos->tra_periodo, ':panel'=>$this->argumentos->tra_panel)));
        $fila=$cursor->fetchObject();
        if($fila){
            $generacionsupervisiones=$fila->generacionsupervisiones;  
            if(!$generacionsupervisiones){
                $this->db->ejecutar_sql(new Sql(<<<SQL
                    SELECT generar_para_supervisiones(:periodo,:panel);
SQL
                    , array(':periodo'=>$this->argumentos->tra_periodo, ':panel'=>$this->argumentos->tra_panel)
                ));
                $cual_grilla_supervisores='supervisores_a_elegir';
            }else{
                $cual_grilla_supervisores='supervisores_elegidos';
            }
            $this->salida->enviar('','',array('id'=>'grilla_esta'));
            enviar_grilla($this->salida,$cual_grilla_supervisores,array('periodo'=>$this->argumentos->tra_periodo,'panel'=>$this->argumentos->tra_panel),'grilla_esta',array('simple'=>'true'));
            $this->salida->enviar_boton('seleccionar','', array('id'=>'seleccionar', 'name'=>'seleccionar','onclick'=>"boton_seleccionar_supervisiones();", 'disabled'=>!!$generacionsupervisiones)); // tiene que ejecutar el algoritmo y mostrar la salida. 
            if($generacionsupervisiones){
                $this->salida->enviar('','',array('id'=>'resultados_supervision'));
                enviar_grilla($this->salida,'tareas_a_supervisar',array('periodo'=>$this->argumentos->tra_periodo,'panel'=>$this->argumentos->tra_panel,'supervisor'=>'#>0'),'resultados_supervision',array('simple'=>'true'));
            }else{
                $this->salida->enviar('','',array('id'=>'resultados_supervision'));
            }
        }else{
            return new Respuesta_Negativa("No esta generado el panel {$this->argumentos->tra_panel} en el periodo {$this->argumentos->tra_periodo}");
        }
        return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>