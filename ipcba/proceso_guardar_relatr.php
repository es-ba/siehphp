<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "proceso_guardar_rel_tablas.php";

class Proceso_guardar_relatr extends Proceso_guardar_rel_tablas{
    var $parametros_separados=array(
        'pk'=>array(
            'tra_periodo'=>array('tipo'=>'texto','def'=>'a2014m01'),
            'tra_informante'=>array('tipo'=>'entero','def'=>'906'),
            'tra_visita'=>array('tipo'=>'texto','def'=>'1'),
            'tra_producto'=>array('tipo'=>'texto','def'=>'P1111137'),
            'tra_observacion'=>array('tipo'=>'entero','def'=>'1'),
            'tra_atributo'=>array('tipo'=>'entero','def'=>'118'),
        ),
        'cambiar'=>array(
            /* CAMBIAR */
            'tra_valor'=>array('tipo'=>'texto','def'=>'detalles'),
        ),
        'controlar'=>array(
            'tra_ant_valor'=>array('tipo'=>'texto','def'=>''),
        )
    );
    var $nombre_tabla='relatr';
    function __construct(){
        parent::__construct(null);
    }
    static function sql_select($filtro){
        $clausulas=array();
        foreach($filtro as $campo=>$valor){
            $clausulas[]=cambiar_prefijo($campo,':tra_','a.').'='.$campo;
        }
        $filtro_sql=implode(' and ',$clausulas);
        return <<<SQL
           select a.periodo, a.producto, a.observacion, a.informante, a.atributo, t.nombreatributo, a.valor, a_1.valor_1, 
               case when t.tipodato='N' then
                   case when (a.valor::decimal)<rangodesde then 'rango_menor'
                        when (a.valor::decimal)>rangohasta then 'rango_mayor'
                        else '' end 
                 else '' end as class_name,
               a.visita, t.tipodato, pa.orden, pa.rangodesde, pa.rangohasta, pa.alterable, pa.normalizable
             from cvp.relpre p 
                inner join cvp.relatr a on p.periodo = a.periodo and p.informante = a.informante and p.producto = a.producto and
                                     p.observacion = a.observacion and p.visita = a.visita
                inner join cvp.relatr_1 a_1 on a.periodo = a_1.periodo and a.informante = a_1.informante and a.producto = a_1.producto and
                                     a.observacion = a_1.observacion and a.visita = a_1.visita and a.atributo = a_1.atributo
                inner join cvp.atributos t on a.atributo = t.atributo
                inner join cvp.prodatr pa on a.producto = pa.producto and a.atributo = pa.atributo
             where {$filtro_sql}
             order by a.periodo, a.informante, a.visita, a.producto, a.observacion, pa.orden
SQL;
    }
}
?>