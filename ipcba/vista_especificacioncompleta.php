<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Vista_especificacioncompleta extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'              ,array('tipo'=>'texto', 'es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('especificacioncompleta',array('tipo'=>'texto', 'origen'=>'especificacioncompleta'));
        $this->definir_campos_orden(array('producto','especificacioncompleta'));        
    }
    function clausula_from(){
        return "(select distinct producto, especificacioncompleta 
                    from cvp.paraimpresionformulariosenblanco) as consulta";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
                'producto'        ,
                'especificacioncompleta');
        return $campos_solo_lectura;        
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('producto','especificacioncompleta'
                                                     ));
    }    
}

class Grilla_prodespecificacioncompleta extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("vista_especificacioncompleta");
    }
    function campos_editables($filtro_para_lectura){
        //if(tiene_rol('coordinador')){
        //  return array('activo');
        //};
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        //return array('*');
        return $this->ordenar_campos_a_listar(array('producto','especificacioncompleta'));
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