<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_baspro extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('baspro');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('baspro_ope',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true));
        $this->definir_campo('baspro_baspro',array('es_pk'=>true,'tipo'=>'texto','largo'=>50,'not_null'=>true));
        $this->definir_campo('baspro_nombre',array('tipo'=>'texto','largo'=>50,'not_null'=>true)); 
        $this->definir_campo('baspro_cambiar_especiales',array('tipo'=>'logico','not_null'=>true,'def'=>false)); 
        $this->definir_campo('baspro_cambiar_nsnc_por',array('tipo'=>'entero')); 
        $this->definir_campo('baspro_cambiar_sindato_por',array('tipo'=>'entero')); 
        $this->definir_campo('baspro_cambiar_null_por',array('tipo'=>'entero')); 
        $this->definir_campo('baspro_sin_pk',array('tipo'=>'logico','not_null'=>true,'def'=>false)); 
        $this->definir_tablas_hijas(array(
            'baspro_var'=>true,
        ));
    }
}
?>