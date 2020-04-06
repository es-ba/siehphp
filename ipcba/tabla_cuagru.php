<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas.php";

class Tabla_cuagru extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('cuadro'     ,array('es_pk'=>true,'tipo'=>'texto','largo'=>10));
        $this->definir_campo('agrupacion' ,array('tipo'=>'texto','es_pk'=>true,'largo'=>9));
        $this->definir_campo('grupo'      ,array('tipo'=>'texto','es_pk'=>true,'largo'=>9));
        $this->definir_campo('orden'      ,array('tipo'=>'entero'));
        $this->definir_campos_orden(array('cuadro','agrupacion','orden','grupo'));

    }
}   
class Grilla_cuagru extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="cuagru";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_cuagru");
        $this->tabla->campos_lookup=array(
               "descripcion"=>false,
               "nombregrupo"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT cuadro as cua, descripcion FROM cuadros) c"=>'c.cua=cuadro',
            "(SELECT agrupacion as agrup, grupo as gru, nombregrupo FROM grupos) g"=>'g.agrup=agrupacion AND g.gru=grupo',
        );
    }
    function campos_editables($filtro_para_lectura){
        //$editables=array();
        //if(tiene_rol('programador') || tiene_rol('procesamiento')){
          $editables=array('cuadro','agrupacion','grupo','orden');
        //}
        return $editables;
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
      return $this->ordenar_campos_a_listar(array('cuadro','agrupacion','grupo','orden','descripcion','nombregrupo'));
      
      /*return array(  'cuadro',
                       'agrupacion', 
                       'grupo',
                       'orden',
                       'descripcion',                       
                       'nombregrupo');*/
    }
}
?>