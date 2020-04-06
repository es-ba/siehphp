<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "proceso_guardar_rel_tablas.php";

class Proceso_guardar_relpre extends Proceso_guardar_rel_tablas{
    var $parametros_separados=array(
        'pk'=>array(
            'tra_periodo'=>array('tipo'=>'texto','def'=>'a2014m01'),
            'tra_informante'=>array('tipo'=>'entero','def'=>'906'),
            'tra_visita'=>array('tipo'=>'texto','def'=>'1'),
            'tra_producto'=>array('tipo'=>'texto','def'=>'P1111137'),
            'tra_observacion'=>array('tipo'=>'entero','def'=>'1'),
        ),
        'cambiar'=>array(
            'tra_precio'=>array('tipo'=>'numerico','def'=>'11.10'),
            'tra_tipoprecio'=>array('tipo'=>'texto','def'=>'P'),
            'tra_cambio'=>array('tipo'=>'texto','def'=>''),
            'tra_comentariosrelpre'=>array('tipo'=>'texto','def'=>'algo'),
        ),
        'controlar'=>array(
            'tra_ant_precio'=>array('tipo'=>'numerico','def'=>'11.10'),
            'tra_ant_tipoprecio'=>array('tipo'=>'texto','def'=>'P'),
            'tra_ant_cambio'=>array('tipo'=>'texto','def'=>''),
            'tra_ant_comentariosrelpre'=>array('tipo'=>'texto','def'=>'algo'),
        )
    );
    var $nombre_tabla='relpre';
    function __construct(){
        parent::__construct(null);
    }
    static function sql_select($filtro){
        $clausulas=array();
        foreach($filtro as $campo=>$valor){
            $clausulas[]=cambiar_prefijo($campo,':tra_','p.').'='.$campo;
        }
        $filtro_sql=implode(' and ',$clausulas);
        return <<<SQL
           select p.periodo, p.producto, d.nombreproducto, p.observacion, p.precio, p.tipoprecio, p.cambio, p_1.precio_1, p_1.tipoprecio_1, 
                  p.informante, p.formulario, p.visita, p.comentariosrelpre, p.ultima_visita, 
                  case when p_1.precio_1>0 and p_1.precio_1<>p.precio 
                    then round((p.precio/p_1.precio_1*100-100)::decimal,1)::text || '%' 
                    else null end as masdatos, 
                  p.precionormalizado, p_1.precionormalizado_1,
                  case when coalesce(p_1.precio_1,c.valorprod)>0 and coalesce(p_1.precio_1,c.valorprod)<>p.precio 
                       then case when p.precio/coalesce(p_1.precio_1,c.valorprod)*100-100 < d.porc_adv_inf then 'precio_bajo'::text
                                 when p.precio/coalesce(p_1.precio_1,c.valorprod)*100-100 > d.porc_adv_sup then 'precio_alto'::text
                                 else null 
                             end
                       else null 
                  end as class_name         
             from cvp.relvis v 
               inner join cvp.relpre p on v.periodo=p.periodo and v.informante=p.informante and v.visita = p.visita and v.formulario = p.formulario
               inner join cvp.productos d on p.producto = d.producto
               inner join cvp.relpre_1 p_1 on p_1.periodo=p.periodo and p_1.informante=p.informante and p_1.visita = p.visita 
                                          and p_1.producto = p.producto and p_1.observacion = p.observacion
               inner join cvp.periodos i on p.periodo = i.periodo
               left join cvp.calprod c on c.periodo = i.periodoanterior and c.calculo = 0 and c.producto = p.producto  
             where {$filtro_sql}
             order by p.periodo, p.informante, p.visita, p.formulario, p.producto, p.observacion
SQL;
    }
}
?>