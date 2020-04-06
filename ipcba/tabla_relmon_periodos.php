<?php
//UTF-8:SÍ
require_once "tablas.php";

class Tabla_relmon extends Tabla{
    function definicion_estructura(){
    $this->con_campos_auditoria=false;
    $this->definir_esquema('cvp');
    $this->definir_campo('periodo'     ,array('hereda'=>'periodos','modo'=>'pk'));
    $this->definir_campo('moneda'      ,array('hereda'=>'monedas','modo'=>'pk'));
    $this->definir_campo('valor_pesos' ,array('tipo'=>'decimal'));
    }    
}    
    class Grilla_relmon_periodos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="anoenc";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_relmon");
    }
    function campos_editables($filtro_para_lectura){
        return array('valor_pesos');
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'       
                                                    ,'moneda' 
                                                    ,'valor_pesos'      
                                                   ));
    }
    /*
    function clausula_from(){
            return "( inner join calculos c on periodo=c.periodo)
               ";
    }
    function clausula_where_agregada(){
        return " c.calculo=0 and c.abierto='S' ";
    }
    */
}

?>