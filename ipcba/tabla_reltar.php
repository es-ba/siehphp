<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_reltar extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'         ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('panel'           ,array('tipo'=>'entero' ,'es_pk'=>true ));
        $this->definir_campo('tarea'           ,array('tipo'=>'entero' ,'es_pk'=>true ));
        $this->definir_campo('supervisor'      ,array('tipo'=>'texto'));
        $this->definir_campo('encuestador'     ,array('tipo'=>'texto'));
        $this->definir_campo('realizada'       ,array('tipo'=>'texto'));
        $this->definir_campo('resultado'       ,array('tipo'=>'texto'));
        $this->definir_campo('observaciones'   ,array('tipo'=>'texto'));
        $this->definir_campo('puntos'          ,array('tipo'=>'entero'));
    }
}


class Grilla_tareas_a_supervisar extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="reltar";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_reltar");
    }
    function campos_editables($filtro_para_lectura){
        return array('realizada', 'resultado', 'observaciones');
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'  
                                                    ,'tarea' 
                                                    ,'supervisor'       
                                                    ,'encuestador'
                                                    ,'realizada'
                                                    ,'resultado'
                                                    ,'puntos'
                                                    ,'observaciones'));
    }
} 

?>