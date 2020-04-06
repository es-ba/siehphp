<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";

class Vista_cal_prod extends Vistas{
    function definicion_estructura(){
        $this->definir_campo('periodo'        ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('calculo'        ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('producto'       ,array('tipo'=>'entero','es_pk'=>true));
        /*
        $this->definir_campo('visita'         ,array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('producto'       ,array('tipo'=>'texto' ,'es_pk'=>true, 'origen'=>'rp.producto'));
        $this->definir_campo('nombreproducto' ,array('tipo'=>'texto' ));
        $this->definir_campo('observacion'    ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('precio'         ,array('tipo'=>'texto' ));
        $this->definir_campo('tipoprecio'     ,array('tipo'=>'texto' ));
        $this->definir_campo('cambio'         ,array('tipo'=>'texto' ));
        */
        // $this->definir_campo('vis_momento'               ,array('operacion'=>'min','origen'=>"tlg_momento"));
        //$this->definir_campos_orden(array('rp.producto','informante'));
    }
    function clausula_from(){
        // return "(select rp.*, p.nombre_producto from relpre_1 rp inner join productos p on rp.producto=p.producto)";
        return "relpre_1 rp inner join productos p on rp.producto=p.producto";
    }
    function clausula_where_agregada(){
        return " and periodo='a2012m07' and rp.producto='P0111121'";
    }
    function puede_detallar(){
        return true;
    }
}


?>