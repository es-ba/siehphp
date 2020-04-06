<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tb_imp_rubros extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('expo');
        $this->definir_campo('rubro'            ,array('tipo'=>'texto' ,'es_pk'=>true));
        $this->definir_campo('nombre_rubro'     ,array('tipo'=>'texto'));
        $this->definir_campo('explicacion_rubro',array('tipo'=>'texto' ));
        $this->definir_campo('nivel'            ,array('tipo'=>'entero' ));
        $this->definir_campo('rubro_padre'      ,array('tipo'=>'texto' ));
        $this->definir_campo('aparece_en_resultados',array('tipo'=>'entero' ));
    }
}

class Grilla_tb_imp_rubros extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="rubros_exportados";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_tb_imp_rubros");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('rubro'      
                                                    ,'nombre_rubro'  
                                                    ,'explicacion_rubro'
                                                    ,'nivel'                                                     
                                                    ,'rubro_padre'
                                                    ,'aparece_en_resultados'
                                              ));
    }
} 

?>