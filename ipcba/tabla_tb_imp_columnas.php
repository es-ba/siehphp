<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_tb_imp_columnas extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        //$this->definir_prefijo('');
        $this->definir_esquema('expo');
        $this->definir_campo('columna'            ,array('tipo'=>'entero' ,'es_pk'=>true));
        $this->definir_campo('periodo'            ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('periodo_denominador',array('tipo'=>'texto' ));
        $this->definir_campo('texto_columna'      ,array('tipo'=>'texto' ));
    }
}

class Grilla_tb_imp_columnas extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="columnas_exportadas";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_tb_imp_columnas");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'columna'  
                                                    ,'periodo_denominador'
                                                    ,'texto_columna'                                                    
                                              ));
    }
} 

?>