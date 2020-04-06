<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_grupos extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('agrupacion'           ,array('tipo'=>'texto','es_pk'=>true,'largo'=>9));
        $this->definir_campo('grupo'                ,array('tipo'=>'texto','es_pk'=>true,'largo'=>9));
        $this->definir_campo('nombregrupo'          ,array('tipo'=>'texto', 'largo'=>250));
        $this->definir_campo('grupopadre'           ,array('tipo'=>'texto', 'largo'=>9));
        $this->definir_campo('ponderador'           ,array('tipo'=>'decimal'));
        $this->definir_campo('nivel'                ,array('tipo'=>'entero'));
        $this->definir_campo('esproducto'           ,array('tipo'=>'texto', 'def'=>'N', 'largo'=>1));
        $this->definir_campo('nombrecanasta'        ,array('tipo'=>'texto', 'largo'=>250));
        $this->definir_campo('agrupacionorigen'     ,array('tipo'=>'texto', 'largo'=>9));
        $this->definir_campo('detallarcanasta'      ,array('tipo'=>'texto', 'largo'=>1));
        $this->definir_campo('explicaciongrupo'     ,array('tipo'=>'texto', 'largo'=>250));
    }
} 

class Grilla_grupos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_grupos");
    }    
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('coordinador')){
            return array('nombregrupo','explicaciongrupo');
        };
    //    return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('agrupacion'       
                                                    ,'grupo' 
                                                    ,'nivel' ));
    }
    
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver ficha del grupo',
            'proceso'=>'ficha_grupo',
            'campos_parametros'=>array('tra_agrupacion'=>null,'tra_grupo'=>null),
            'y_luego'=>'ver'
        );
    }
    
}
?>