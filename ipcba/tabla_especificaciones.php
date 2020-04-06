<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_especificaciones extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'             ,array('hereda'=>'productos','modo'=>'pk'));
        $this->definir_campo('especificacion'       ,array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('nombreespecificacion' ,array('tipo'=>'texto'));
        $this->definir_campo('tamannonormal'        ,array('tipo'=>'real'));
        $this->definir_campo('ponderadoresp'        ,array('tipo'=>'real','not_null'=>true,'def'=>1));
        $this->definir_campo('envase'               ,array('tipo'=>'texto','largo'=>80));
        $this->definir_campo('excluir'              ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('cantidad'             ,array('tipo'=>'decimal'));
        $this->definir_campo('unidaddemedida'       ,array('tipo'=>'texto','largo'=>20));
        $this->definir_campo('pesovolumenporunidad' ,array('tipo'=>'real'));
    }
} 

class Grilla_especificaciones extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_especificaciones");
    }
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('coordinador')){
            return array('excluir','envase','nombreespecificacion');
        };
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('ponderadoresp');
    }    
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('producto','especificacion'));
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver ficha del producto',
            'proceso'=>'ficha_producto',
            'campos_parametros'=>array('tra_producto'=>null),
            'y_luego'=>'ver'
        );
    }
}

?>