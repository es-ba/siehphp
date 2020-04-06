<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_generar_periodo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(periodo) as ultimo
              FROM periodos  
              WHERE ingresando='S'
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimo;
        $this->definir_parametros(array(
            'titulo'=>'generar periodo',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>PROCESO_INTERNO, //'administración',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_generar_periodo','value'=>'generar'),
        ));
    }
    
    function responder(){
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        $mi_tabla_periodos=$this->nuevo_objeto('Tabla_periodos');
        $mi_tabla_periodos->valores_para_update=array('fechageneracionperiodo'=>$ahora);
        $mi_filtro['periodo']=$this->argumentos->tra_periodo;
        $mi_tabla_periodos->ejecutar_update_unico($mi_filtro);
        return new Respuesta_Positiva("Fecha generacion periodo actualizada");
    }
}
?>