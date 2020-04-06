<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tareas extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('tarea',array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('encuestador',array('hereda'=>'personal','campo_relacionado'=>'persona','modo'=>'fk_obligatoria'));
    }
}    

?>