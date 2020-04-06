<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_agrupaciones extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('agrupacion'           ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('nombreagrupacion'     ,array('tipo'=>'texto', 'mostrar_al_elegir'=>true));
        $this->definir_campo('paravarioshogares'    ,array('tipo'=>'logico'));
        $this->definir_campo('calcular_junto_grupo' ,array('tipo'=>'texto'));
        $this->definir_campo('valoriza'             ,array('tipo'=>'logico'));
        $this->definir_campo('tipo_agrupacion'      ,array('tipo'=>'texto'));
    }
} 

class Grilla_agrupaciones extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_agrupaciones");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('agrupacion'       
                                                    ,'nombreagrupacion' 
                                                    ,'paravarioshogares'      
                                                    ,'calcular_junto_grupo'
                                                    ,'valoriza'
                                                    ,'tipo_agrupacion'));
    }
}
?>