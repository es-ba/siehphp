<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_razones extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('razon',array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('nombrerazon',array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('espositivoinformante',array('tipo'=>'sino_dom','not_null'=>true));
        $this->definir_campo('espositivoformulario',array('tipo'=>'sino_dom','not_null'=>true));
        $this->definir_campo('escierredefinitivoinf',array('tipo'=>'sino_dom','not_null'=>true));
        $this->definir_campo('escierredefinitivofor',array('tipo'=>'sino_dom','not_null'=>true));
        $this->definir_campo('visibleparaencuestador',array('tipo'=>'sino_dom','def'=>'S','not_null'=>true));
    }
}    

?>