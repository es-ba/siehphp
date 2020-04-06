<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_import_info extends Tabla{
    function definicion_estructura(){
        $this->heredar_en_cascada=true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->con_campos_auditoria=false;
        $this->definir_campo('operativo',array('es_pk'=>true,'tipo'=>'texto','not_null'=>true ));
        $this->definir_campo('agrupacion',array('es_pk'=>true,'tipo'=>'texto', 'not_null'=>true));
        $this->definir_campo('grupo',array('es_pk'=>true,'tipo'=>'texto', 'not_null'=>true));
        $this->definir_campo('var_var',array('tipo'=>'texto', 'not_null'=>true));
        $this->definir_campo('var_promedio',array('tipo'=>'texto','not_null'=>true));
    }    
}

?>
