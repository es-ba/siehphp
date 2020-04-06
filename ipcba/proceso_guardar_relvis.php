<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "proceso_guardar_rel_tablas.php";

class Proceso_guardar_relvis extends Proceso_guardar_rel_tablas{
    var $parametros_separados=array(
        'pk'=>array(
            'tra_periodo'=>array('tipo'=>'texto','def'=>'a2014m01'),
            'tra_informante'=>array('tipo'=>'entero','def'=>'906'),
            'tra_formulario'=>array('tipo'=>'entero','def'=>'29'),
            'tra_visita'=>array('tipo'=>'texto','def'=>'1'),
        ),
        'cambiar'=>array(
            'tra_fechasalida'=>array('tipo'=>'fecha','def'=>'02/01/2014'),
            'tra_fechaingreso'=>array('tipo'=>'fecha','def'=>'03/01/2014'),
            'tra_encuestador'=>array('tipo'=>'texto','def'=>'27'),
            'tra_supervisor'=>array('tipo'=>'texto','def'=>'21'),
            'tra_recepcionista'=>array('tipo'=>'texto','def'=>'31'),
            'tra_ingresador'=>array('tipo'=>'texto','def'=>'41'),
            'tra_razon'=>array('tipo'=>'entero','def'=>'1'),
        ),
        'controlar'=>array(
            'tra_ant_fechasalida'=>array('tipo'=>'fecha','def'=>'02/01/2014'),
            'tra_ant_fechaingreso'=>array('tipo'=>'fecha','def'=>'03/01/2014'),
            'tra_ant_encuestador'=>array('tipo'=>'texto','def'=>'27'),
            'tra_ant_supervisor'=>array('tipo'=>'texto','def'=>'21'),
            'tra_ant_recepcionista'=>array('tipo'=>'texto','def'=>'31'),
            'tra_ant_ingresador'=>array('tipo'=>'texto','def'=>'41'),
            'tra_ant_razon'=>array('tipo'=>'entero','def'=>'1'),
        )
    );
    var $nombre_tabla='relvis';
    function __construct(){
        parent::__construct(null);
    }
    static function sql_select($filtro){
        $clausulas=array();
        foreach($filtro as $campo=>$valor){
            $clausulas[]=cambiar_prefijo($campo,':tra_','r.').'='.$campo;
        }
        $filtro_sql=implode(' and ',$clausulas);
        return <<<SQL
           select r.periodo, r.informante, i.nombreinformante, r.visita, r.formulario, f.nombreformulario, 
                  r.panel, r.tarea, r.fechasalida, r.fechaingreso, r.encuestador,
                  r.supervisor, r.recepcionista, r.ingresador, r.razon, z.nombrerazon
             from cvp.relvis r 
               inner join cvp.formularios f on r.formulario = f.formulario
               inner join cvp.informantes i on r.informante = i.informante
               left join cvp.razones z on z.razon=r.razon
             where {$filtro_sql}
             order by r.periodo, r.informante, r.visita, r.formulario
SQL;
    }
}
?>