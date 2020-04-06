<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_calculos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'          ,array('hereda'=>'periodos','modo'=>'pk'));
        $this->definir_campo('calculo'          ,array('hereda'=>'calculos_def','modo'=>'pk'));
        $this->definir_campo('esperiodobase'    ,array('tipo'=>'texto','largo'=>1,'def'=>'N','not_null'=>true));
        $this->definir_campo('periodoanterior'  ,array('tipo'=>'texto','largo'=>11));
        $this->definir_campo('fechacalculo'     ,array('tipo'=>'timestamp'));
        $this->definir_campo('calculoanterior'  ,array('tipo'=>'entero'));
        $this->definir_campo('abierto'          ,array('tipo'=>'texto','def'=>'N','largo'=>1));
        $this->definir_campo('agrupacionprincipal',array('tipo'=>'texto','largo'=>10,'def'=>'A','not_null'=>true));
        $this->definir_campo('valido'           ,array('tipo'=>'texto','largo'=>1,'def'=>'N','not_null'=>true));
        $this->definir_campo('pb_calculobase'   ,array('hereda'=>'calculos_def','campo_relacionado'=>'calculo','modo'=>'fk_optativa'));
        $this->definir_campo('motivocopia'      ,array('tipo'=>'texto'));
    }
    function campos_a_mostrar_en_lista_opciones(){
        return array('periodo');
    }
}    
class Grilla_calculos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_calculos");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }

    function campos_a_listar($filtro_para_lectura){
        return array('periodo'       
                    ,'calculo' 
                    ,'esperiodobase'      
                    ,'periodoanterior'
                    ,'fechacalculo'
                    ,'calculoanterior'
                    ,'abierto'
                    ,'agrupacionprincipal'
                    ,'valido'
                    ,'pb_calculobase'
                    ,'motivocopia');
    }
}
?>