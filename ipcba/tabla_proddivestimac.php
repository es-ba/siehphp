<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_proddivestimac extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('estimacion'         ,array('tipo'=>'entero','es_pk'=>true));
        $this->definir_campo('producto'           ,array('tipo'=>'texto','es_pk'=>true,'largo'=>8));
        $this->definir_campo('division'           ,array('tipo'=>'texto','es_pk'=>true));
        $this->definir_campo('umbralpriimp'       ,array('tipo'=>'entero'));
        $this->definir_campo('umbraldescarte'     ,array('tipo'=>'entero'));
        $this->definir_campo('umbralbajaauto'     ,array('tipo'=>'entero'));
    }
} 
/*    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="novpre";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_novpre"); */

class Grilla_proddivestimac extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="proddivestimac";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_proddivestimac");
        $this->tabla->campos_lookup=array(
               "nombreproducto"=>false,
        ); 
        $this->tabla->tablas_lookup=array(
            "(SELECT producto prod, nombreproducto FROM cvp.productos) as n"
            => 'n.prod = producto',			
        );
    }    
    function campos_editables($filtro_para_lectura){
        if(tiene_rol('coordinador') or tiene_rol('analista')){
            return array('umbralpriimp','umbraldescarte','umbralbajaauto');
        };
    //    return array();
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('estimacion'       
                                                    ,'producto' 
                                                    ,'division'
                                                    ,'nombreproducto'
                                                    ,'umbralpriimp'
                                                    ,'umbraldescarte'
                                                    ,'umbralbajaauto'
                                                    ));
    }
/*    
    function boton_enviar(){
        return array(
            'leyenda'=>'ver',
            'title'=>'Ver ficha del grupo',
            'proceso'=>'ficha_grupo',
            'campos_parametros'=>array('tra_agrupacion'=>null,'tra_grupo'=>null),
            'y_luego'=>'ver'
        );
    }
*/    
}
?>