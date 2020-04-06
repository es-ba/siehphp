<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_muestras extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('muestra'                      ,array('tipo'=>'entero', 'not_null'=>true, 'es_pk'=>true));
        $this->definir_campo('descripcion'                  ,array('tipo'=>'texto', 'largo'=>50));
        $this->definir_campo('alta_inmediata_hasta_periodo' ,array('hereda'=>'periodos','modo'=>'fk_optativa','campo_relacionado'=>'periodo'));
    }
} 

?>