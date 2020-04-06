<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_ingreso extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT min(periodo) as ultimo
              FROM periodos
              WHERE ingresando='S'
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
            'titulo'=>'Ingreso',
            'permisos'=>array('grupo'=>'ingresador'),
            'submenu'=>'Ingreso',
            'para_produccion'=>true,
            'parametros'=>array(
                   'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo /* PONER: $def_periodo */,'style'=>'width:100px'),
                   'tra_panel'=>array('tipo'=>'texto','label'=>'Panel','style'=>'width:40px'),
                   'tra_tarea'=>array('tipo'=>'texto','label'=>'Tarea','style'=>'width:40px'),
            ),
            'bitacora'=>true, // provisorio
            'en_construccion'=>true,
            'boton'=>array('id'=>'ver', 'value' => 'ver'),
        ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT min(periodo) as ultimo FROM periodos WHERE ingresando='S'
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo=$fila->ultimo;
        Loguear('2013-02-22','LLEGUÉ ACÁ: ------------- '.var_export($this->parametros,true));
        //$this->parametros->parametros['tra_periodo']['def']=$ultimo_periodo;

        $tabla_hastaperiodo=$this->nuevo_objeto("Tabla_periodos");
        $tabla_hastaperiodo->definir_campos_orden(array('periodo'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_hastaperiodo->lista_opciones(array('ingresando'=>'S'));
        $this->parametros->parametros['tra_panel']['opciones']=array('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20');
        $tabla_tareas=$this->nuevo_objeto("Tabla_tareas");
        $this->parametros->parametros['tra_tarea']['opciones']=$tabla_tareas->lista_opciones(array());
        parent::correr();
    }
    function responder(){
        $this->salida=new Armador_de_salida(true);
        if(!$this->argumentos->tra_periodo) {
            return new Respuesta_Negativa('Debe especificar periodo!');        
        }
        $filtro_relvis=array('periodo'=>$this->argumentos->tra_periodo,'panel'=>$this->argumentos->tra_panel);
        if(!!$this->argumentos->tra_tarea){
            $filtro_relvis['tarea']=$this->argumentos->tra_tarea;
        }    
        Loguear('2014-04-08','ingreso: ------------- '.var_export($filtro_relvis,true));

        if(!!$this->argumentos->tra_panel) {
            $this->salida=new Armador_de_salida(true);
            $this->salida->enviar('','',array('id'=>'div_relvis'));
            enviar_grilla($this->salida,'relvis_ing',$filtro_relvis,'div_relvis');
            return $this->salida->obtener_una_respuesta_HTML();
        }else {
            $this->salida->enviar('','',array('id'=>'div_relpan'));
            enviar_grilla($this->salida,'relpan',array('periodo'=>$this->argumentos->tra_periodo),'div_relpan');
            return $this->salida->obtener_una_respuesta_HTML();
        }
    }
}
?>