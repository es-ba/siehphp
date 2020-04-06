<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relsup extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'         ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('panel'           ,array('tipo'=>'entero' ,'es_pk'=>true ));
        $this->definir_campo('supervisor'      ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('disponible'      ,array('tipo'=>'texto'));
        $this->definir_campo('motivonodisponible'  ,array('tipo'=>'texto'));
    }
}

class Grilla_supervisores_a_elegir extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="superv";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_relsup");
    }
    function campos_editables($filtro_para_lectura){
        return array('disponible','motivonodisponible');
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'supervisor'       
                                                    ,'disponible'
                                                    ,'motivonodisponible'));
    }
} 

class Grilla_supervisores_elegidos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="superv";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_relsup");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'supervisor'       
                                                    ,'disponible'
                                                    ,'motivonodisponible'));
    }
} 

?>