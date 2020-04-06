<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_control_diccionario extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('periodo'        ,array('tipo'=>'texto' ,'es_pk'=>true, 'origen'=>'val.periodo'));
        $this->definir_campo('producto'       ,array('tipo'=>'texto' ,'es_pk'=>true, 'origen'=>'val.producto'));
        $this->definir_campo('nombreproducto' ,array('tipo'=>'texto', 'origen'=>'val.nombreproducto'));
        $this->definir_campo('atributo'       ,array('tipo'=>'entero','es_pk'=>true, 'origen'=>'val.atributo'));
        $this->definir_campo('nombreatributo' ,array('tipo'=>'texto', 'origen'=>'val.nombreatributo'));
        $this->definir_campo('valor'          ,array('tipo'=>'texto', 'es_pk'=>true,'origen'=>'val.valor'));
        $this->definir_campo('cantidad'       ,array('tipo'=>'texto', 'origen'=>'val.cantidad'));
    }
    
    function clausula_from(){
        return "(select r.periodo, r.producto, p.nombreproducto, r.atributo, a.nombreatributo, r.valor, count(*) cantidad
                  from cvp.relatr r inner join cvp.productos p on r.producto = p.producto 
                  inner join cvp.atributos a on r.atributo = a.atributo
                  left join cvp.dicprodatr d on r.producto = d.producto and r.atributo = d.atributo and 
                             comun.cadena_normalizar(d.origen) = comun.cadena_normalizar(r.valor)
                  where r.atributo = 13 and d.destino is null
                  group by r.periodo, r.producto, p.nombreproducto, r.atributo, a.nombreatributo, r.valor
                  order by r.periodo, r.producto, p.nombreproducto, r.atributo, a.nombreatributo, r.valor) as val";
    }

}


?>