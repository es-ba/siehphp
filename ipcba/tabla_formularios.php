<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_formularios extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('formulario'           ,array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('nombreformulario'     ,array('tipo'=>'texto','largo'=>250));
        $this->definir_campo('soloparatipo'         ,array('hereda'=>'tipoinf','campo_relacionado'=>'tipoinformante'));
        $this->definir_campo('operativo'            ,array('tipo'=>'enumerado','elementos'=>array('C','G'),'largo'=>1,'not_null'=>true));
        $this->definir_campo('activo'               ,array('tipo'=>'sino_dom'));
        $this->definir_campo('despacho'             ,array('tipo'=>'texto','largo'=>1));
        $this->definir_campo('altamanualdesdeperiodo',array('tipo'=>'texto','largo'=>11));
    }
} 
class Vista_prodformularios extends Vistas{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('producto'             ,array('tipo'=>'entero','es_pk'=>true, 'origen'=>'producto'));
        $this->definir_campo('formulario'           ,array('tipo'=>'entero','es_pk'=>true, 'origen'=>'formulario'));       
        $this->definir_campo('nombreformulario'     ,array('tipo'=>'texto', 'origen'=>'nombreformulario'));
        $this->definir_campo('soloparatipo'         ,array('tipo'=>'real', 'origen'=>'soloparatipo'));
        $this->definir_campo('operativo'            ,array('tipo'=>'texto', 'origen'=>'operativo'));
        $this->definir_campo('activo'               ,array('tipo'=>'texto', 'origen'=>'activo'));
        $this->definir_campo('despacho'             ,array('tipo'=>'texto', 'origen'=>'despacho'));
        $this->definir_campo('altamanualdesdeperiodo',array('tipo'=>'texto','origen'=>'altamanualdesdeperiodo'));
        $this->definir_campo('cantinformantesefec',array('tipo'=>'entero'));
        $this->definir_campos_orden(array('producto','formulario'));        
    }
     function clausula_from(){
        return " (
        select a.producto, b.* , count(distinct(v.informante)) as cantinformantesefec
            from cvp.forprod a inner join cvp.formularios b on a.formulario=b.formulario
                               left join cvp.relvis v on a.formulario=v.formulario 
                                                and periodo>=(select lead(periodo,2)over(order by periodo desc) periodo_2 
                                                                from cvp.periodos 
                                                                order by periodo desc
                                                                limit 1
                                                              )
                                                and v.razon=1
            group by a.producto, b.formulario, b.nombreformulario, b.soloparatipo, b.operativo,            
                        b.activo, b.despacho, b.altamanualdesdeperiodo
        ) as consulta ";
    }
    function puede_detallar(){
        return false;
    }
    function campos_solo_lectura(){
        $campos_solo_lectura=array(
                    'producto'        ,    
                    'formulario'      ,    
                    'nombreformulario',    
                    'soloparatipo'    ,    
                    'operativo'       ,
                    'activo'          ,
                    'despacho'        ,
                    'altamanualdesdeperiodo',
                    'cantinformantesefec'
        );
        return $campos_solo_lectura;
    }
}
class Grilla_prodformularios extends Grilla_vistas{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("vista_prodformularios");
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('*');
       // return $this->ordenar_campos_a_listar(array('producto','formulario'));
    }
    function campos_a_excluir($filtro_para_lectura){
        return array('altamanualdesdeperiodo' ,
        );
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