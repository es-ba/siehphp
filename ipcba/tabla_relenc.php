<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_relenc extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        // $this->definir_prefijo('');
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo'         ,array('tipo'=>'texto'  ,'es_pk'=>true));
        $this->definir_campo('panel'           ,array('tipo'=>'entero' ,'es_pk'=>true ));
        $this->definir_campo('tarea'           ,array('tipo'=>'entero' ,'es_pk'=>true ));
        $this->definir_campo('encuestador'     ,array('tipo'=>'texto'));
    }
}

class Grilla_relenc extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="titulares";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_relenc");
        $this->tabla->campos_lookup=array(
               "encuestadornombre"=>false,
               "titular"=>false,
               "titularnombre"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT persona, nombre||' '||apellido as encuestadornombre FROM personal) p"=>'p.persona=encuestador',
            "(SELECT tarea as tar, encuestador as titular FROM tareas) t"=>'t.tar=tarea',
            "(SELECT tarea as tar, persona, nombre||' '||apellido as titularnombre FROM tareas a left join personal e on a.encuestador = e.persona) g"=>'g.tar=tarea',
        );
    }
    function campos_editables($filtro_para_lectura){
        return array('periodo', 'panel', 'tarea', 'encuestador');
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        //return tiene_rol('programador') || tiene_rol('procesamiento');
        return true;
    }
    function puede_eliminar(){
        //return tiene_rol('programador') || tiene_rol('procesamiento');
        return true;
    }
    function campos_a_listar($filtro_para_lectura){
        return $this->ordenar_campos_a_listar(array('periodo'      
                                                    ,'panel'
                                                    ,'tarea'
                                                    ,'encuestador'
                                                    ,'encuestadornombre'
                                                    ,'titular'
                                                    ,'titularnombre'
                                                    ));
    }
} 
?>