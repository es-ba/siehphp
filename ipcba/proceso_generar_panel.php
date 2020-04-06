<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";

class Proceso_generar_panel extends Proceso_Formulario{
    function __construct(){
        parent::__construct(null);
    }
    function post_constructor(){
        parent::post_constructor();
        $ahora=new DateTime();
        $ahora->sub(new DateInterval('P1M'));
        //$def_periodo='a'.$ahora->format('Y').'m'.$ahora->format('m');
         $cursor=$this->db->ejecutar_sql(new Sql(<<<SQL
            SELECT max(p.periodo) as ultimoper, min(panel) as ultimopan
              FROM periodos p inner join relpan r on p.periodo = r.periodo  
              WHERE p.ingresando='S' and fechageneracionpanel is null
SQL
        ));
        $fila=$cursor->fetchObject();
        $def_periodo=$fila->ultimoper;
        $def_panel=$fila->ultimopan;
        $this->definir_parametros(array(
            'titulo'=>'generar panel',
            'permisos'=>array('grupo'=>'jefe_campo'),
            'submenu'=>PROCESO_INTERNO, //'administración',
            'para_produccion'=>true,
            'parametros'=>array(
                'tra_periodo'=>array('tipo'=>'texto','label'=>'Período','def'=>$def_periodo),
                'tra_panel'=>array('tipo'=>'entero','label'=>'Panel','def'=>$def_panel),
                ),
            'bitacora'=>true,
            'boton'=>array('id'=>'boton_generar_panel','value'=>'generar'),
        ));
    }
    
    function responder(){
        $ahora=date_format(new DateTime(), "Y-m-d H:i:s");
        $mi_tabla_panel=$this->nuevo_objeto('Tabla_relpan');
        $mi_tabla_panel->valores_para_update=array('fechageneracionpanel'=>$ahora);
        $mi_filtro['periodo']=$this->argumentos->tra_periodo;
        $mi_filtro['panel']=$this->argumentos->tra_panel;
        $mi_tabla_panel->ejecutar_update_unico($mi_filtro);
        return new Respuesta_Positiva("Fecha generacion panel actualizada");
    }
}
?>