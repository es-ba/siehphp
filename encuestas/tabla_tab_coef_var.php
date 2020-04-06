<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_tab_coef_var extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('tabcoefvar');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('tabcoefvar_poblacion', array('es_pk'=>true, 'tipo' => 'entero' ));
        $this->definir_campo('tabcoefvar_tabla', array('es_pk'=>true,'tipo' => 'texto' , 'largo'=>50));
        $this->definir_campo('tabcoefvar_grzona', array('es_pk'=>true,'tipo' => 'texto', 'largo'=>1 ));
        $this->definir_campo('tabcoefvar_zona', array('es_pk'=>true,'tipo' => 'entero' ));
        $this->definir_campo('tabcoefvar_dato', array('tipo' => 'real' ));
    }    
}
?>