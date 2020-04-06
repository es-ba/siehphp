<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_control_rangos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'          ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('producto'         ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('nombreproducto'   ,array('tipo'=>'texto'  ));
        $this->definir_campo('informante'       ,array('tipo'=>'entero' ,'es_pk'=>true));
        $this->definir_campo('tipoinformante'   ,array('tipo'=>'texto'  ));
        $this->definir_campo('observacion'      ,array('tipo'=>'entero' ,'es_pk'=>true));
        $this->definir_campo('visita'           ,array('tipo'=>'entero' ,'es_pk'=>true));
        $this->definir_campo('panel'            ,array('tipo'=>'entero' ));
        $this->definir_campo('tarea'            ,array('tipo'=>'entero' ));
        $this->definir_campo('precionormalizado',array('tipo'=>'decimal'));
        $this->definir_campo('tipoprecio'       ,array('tipo'=>'texto'  ));
        $this->definir_campo('cambio'           ,array('tipo'=>'texto'  ));
        $this->definir_campo('impobs'           ,array('tipo'=>'texto'  ));
        $this->definir_campo('precioant'        ,array('tipo'=>'decimal'));
        $this->definir_campo('variac'           ,array('tipo'=>'decimal'));
        $this->definir_campo('promvar'          ,array('tipo'=>'decimal'));
        $this->definir_campo('desvvar'          ,array('tipo'=>'decimal'));
        $this->definir_campo('promrotativo'     ,array('tipo'=>'decimal'));
        $this->definir_campo('desvprot'         ,array('tipo'=>'decimal'));
        $this->definir_campo('impobs_1'         ,array('tipo'=>'texto'  ));
    }
    function permite_grilla_sin_filtro(){
        Loguear('2013-02-27','~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' );
        return false;
    }
} 


   
?>