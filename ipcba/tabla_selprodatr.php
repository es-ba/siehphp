<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_SelProdAtr  extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        //$this->heredar_en_cascada=true;
        $this->definir_esquema('cvp');     
        $this->definir_campo('producto', array('es_pk'=>true, 'tipo' => 'texto' , 'largo'=>8));
        $this->definir_campo('sel_nro', array('es_pk'=>true, 'tipo' => 'entero' ));
        $this->definir_campo('atributo', array('es_pk'=>true, 'tipo' => 'entero'));
        $this->definir_campo('valor', array('tipo' => 'texto', 'largo'=>250));
    /*
        probando definir herencia  por ejemplo con selpre busca quitar el prefijo y aqui no tenemos entonces da error
        $this->definir_campo('producto', array('hereda'=>'selprod', 'modo'=>'pk'));
        $this->definir_campo('sel_nro', array('hereda'=>'selprod', 'modo'=>'pk'));
        --$this->definir_campo('atributo', array('hereda'=>'atributos', 'modo'=>'pk'));
    */
    }
}
?>