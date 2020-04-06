<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_pantar extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('panel'         ,array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('tarea'         ,array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('grupozonal'    ,array('tipo'=>'texto' ,'largo'=>1, 'invisible'=>true));
        $this->definir_campo('panel2009'     ,array('tipo'=>'entero', 'invisible'=>true));
        $this->definir_campo('tamannosupervision' ,array('tipo'=>'entero' ));
    }
    function campos_a_mostrar_en_lista_opciones(){
        return array('panel','tarea');
    }
}    
class Grilla_pantar extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_pantar");
        $this->tabla->campos_lookup=array(
               "operativo"=>false,
               "activa"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT tarea as tar, operativo, activa 
                FROM cvp.tareas t
                WHERE t.tarea = tarea                   
             ) as ta"
            =>'tar=tarea',
        );
    }
    function campos_editables($filtro_para_lectura){
        return array('tamannosupervision');
    }
    function responder_detallar(){
        return false;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('panel'  
                    ,'tarea' 
                    ,'tamannosupervision'
                    ));
    }
}
?>