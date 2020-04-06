<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_copiar_calculo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT case when min(periodo) is not null then min(periodo) else (select max(periodo) from calculos where calculo=0)  end as ultimo
              FROM calculos  
              WHERE abierto='S' and calculo=0
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
            'titulo'=>'Copia del cálculo',
            'permisos'=>array('grupo'=>'coordinador'),
            'submenu'=>'Administración',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo),
                'tra_motivocopia'=>array('tipo'=>'texto','label'=>'Motivo de copia'),
//                'tra_calculo_destino'=>array('tipo'=>'texto','label'=>'Calculo Destino','disabled'=>true),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_copiar_calculo','value'=>'copiar'),
        ));
    }
    function correr(){
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimo FROM calculos
SQL
        ));
        $fila=$cursor->fetchObject();
        $ultimo_periodo_calculado=$fila->ultimo;
        Loguear('2013-02-22','LLEGUÉ ACÁ: ------------- '.var_export($this->parametros,true));
        $tabla_calculos=$this->nuevo_objeto("Tabla_calculos");
        $tabla_calculos->definir_campos_orden(array('periodo desc'));
        $this->parametros->parametros['tra_periodo']['opciones']=$tabla_calculos->lista_opciones(array('calculo'=>0),'periodo');
        parent::correr();
        //para agregar la grilla debajo:
        $periodos_para_filtro = '# > a2013m07';
        enviar_grilla($this->salida,'calculos',null,null,array('filtro_manual'=>array('periodo'=>$periodos_para_filtro,'calculo'=>'# >0')));
    }
    
    
    function responder(){
        $this->salida=new Armador_de_salida(true);
        if (!$this->argumentos->tra_motivocopia){
            return new Respuesta_Negativa('Debe especificar motivo de copia del calculo');        
        }
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(calculo) as ult_calculo FROM calculos where periodo=:tra_periodo
SQL
           , array(':tra_periodo'=>$this->argumentos->tra_periodo)
        ));
        $fila=$cursor->fetchObject();
        $calculo_destino=$fila->ult_calculo+1;
        $tabla_calculos_def = new tabla_calculos_def();
        $tabla_calculos_def->contexto=$this;
        $tabla_calculos_def->leer_uno_si_hay(array(
            'calculo'=>$calculo_destino
        ));        
        if(!$tabla_calculos_def->obtener_leido()){
            $tabla_calculos_def->valores_para_insert=(array(
                   'calculo'    =>$calculo_destino,
                   'definicion' =>'Copia del Calculo'));
            $tabla_calculos_def->ejecutar_insercion();
        }    
        $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT * from cvp.calculos  WHERE periodo=:tra_periodo AND calculo=:tra_calculo_destino
SQL
            , array(':tra_periodo'=>$this->argumentos->tra_periodo, ':tra_calculo_destino'=>$calculo_destino )
        ));
        $fila=$cursor->fetchObject();
        if(!!$fila){
            return new Respuesta_Negativa('Ya hay una copia del calculo periodo '. $this->argumentos->tra_periodo . ' calculo destino '. $calculo_destino);
        }else{
            $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
                SELECT 1 as hay_calculo FROM cvp.calculos where periodo=:tra_periodo and calculo=0
SQL
                , array(':tra_periodo'=>$this->argumentos->tra_periodo)
            ));
            $hay_calculo=$cursor->fetchObject();
            if($hay_calculo){
                $time_start = microtime(true);
                $this->db->ejecutar_sql(new Sql("select cvp.copiarcalculo(:tra_periodo, 0, :tra_periodo, :tra_calculo_destino, :tra_motivocopia)",
                                    array(':tra_periodo'=>$this->argumentos->tra_periodo, ':tra_periodo'=>$this->argumentos->tra_periodo,':tra_calculo_destino'=>$calculo_destino, ':tra_motivocopia'=>$this->argumentos->tra_motivocopia )));
                $demora = round(microtime(true) - $time_start);
                return new Respuesta_Positiva('Calculo copiado con éxito en calculo=' . $calculo_destino. '. Copia hecha en '. $demora .' segundos');
            }else{
                return new Respuesta_Negativa('No habia datos del periodo '. $this->argumentos->tra_periodo .' para copiar');
            }
        }        
    return $this->salida->obtener_una_respuesta_HTML();
    }
}
?>