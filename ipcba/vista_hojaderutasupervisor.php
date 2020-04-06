<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Vista_hojaderutasupervisor extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        //revisar pk!
        $this->definir_campo('supervisor'       ,array('tipo'=>'entero','origen'=>'supervisor'));
        $this->definir_campo('nombresupervisor' ,array('tipo'=>'texto','origen'=>'nombresupervisor'));
        $this->definir_campo('periodo'          ,array('tipo'=>'texto','es_pk'=>true,'origen'=>'periodo'));
        $this->definir_campo('panel'            ,array('tipo'=>'entero','es_pk'=>true,'origen'=>'panel'));
        $this->definir_campo('tarea'            ,array('tipo'=>'entero','es_pk'=>true,'origen'=>'tarea'));
        $this->definir_campo('fechasalida'      ,array('tipo'=>'fecha','origen'=>'fechasalida'));
        $this->definir_campo('informante'       ,array('tipo'=>'entero','es_pk'=>true,'origen'=>'informante'));
        $this->definir_campo('encuestador'      ,array('tipo'=>'entero','origen'=>'encuestador'));
        $this->definir_campo('nombreencuestador',array('tipo'=>'texto','origen'=>'nombreencuestador'));
        $this->definir_campo('razon'           ,array('tipo'=>'entero','origen'=>'razon'));
        $this->definir_campo('visita'          ,array('tipo'=>'entero','es_pk'=>true,'origen'=>'visita'));
        $this->definir_campo('nombreinformante',array('tipo'=>'texto','origen'=>'nombreinformante'));
        $this->definir_campo('direccion'       ,array('tipo'=>'texto','origen'=>'direccion'));
        $this->definir_campo('formularios'     ,array('tipo'=>'texto','origen'=>'formularios'));
        $this->definir_campo('espacio'         ,array('tipo'=>'texto','origen'=>'espacio'));
        $this->definir_campo('contacto'        ,array('tipo'=>'texto','origen'=>'contacto'));
        $this->definir_campo('conjuntomuestral',array('tipo'=>'texto','origen'=>'conjuntomuestral'));
        $this->definir_campo('ordenhdr'        ,array('tipo'=>'entero','origen'=>'ordenhdr'));
        $this->definir_campos_orden(array('periodo','panel','tarea', 'ordenhdr','direccion')); 
    }  
    function clausula_from(){
        return "hojaderutasupervisor";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array('*');
        return $campos_solo_lectura;        
    }
    function campos_a_listar($filtro_para_lectura){
        return array('*');
    }    
}

?>