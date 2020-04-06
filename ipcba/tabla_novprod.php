<?php
//UTF-8:SÍ 
require_once "tablas.php";

class Tabla_novprod extends Tabla{
    function definicion_estructura(){
        $this->con_campos_auditoria=false;
        $this->definir_esquema('cvp');
        $this->definir_campo('periodo',array('hereda'=>'periodos','modo'=>'pk'));
        $this->definir_campo('calculo',array('tipo'=>'entero','es_pk'=>true, 'def'=>0));
        $this->definir_campo('producto',array('hereda'=>'productos','modo'=>'pk'));
        $this->definir_campo('promedioext',array('tipo'=>'real','not_null'=>true));
        $this->definir_campo('variacion',array('tipo'=>'real', 'def'=>0));
    }
}    
class Grilla_novprod extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="novprod";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_novprod");
        $this->tabla->campos_lookup=array(
               "nombreproducto"=>false,
               "anterior"=>false,
               //"variacion"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "(SELECT producto as prod, nombreproducto FROM productos) p"=>'p.prod=producto',
            "(SELECT c.periodo as per, c.calculo as cal, c.producto as prod, c.division as div, round(c0.promdiv::decimal,2) as anterior
                FROM caldiv c 
                LEFT JOIN calculos l ON c.periodo = l.periodo AND c.calculo = l.calculo 
                LEFT JOIN caldiv c0 ON c0.periodo = l.periodoanterior and c0.calculo = l.calculoanterior and c.producto = c0.producto and c.division = c0.division
                LEFT JOIN novprod n ON c.periodo = n.periodo and c.calculo = n.calculo and c.producto = n.producto 
                WHERE c.division = '0'
             ) d"=>'d.per=periodo AND d.cal=calculo AND d.prod = producto',
        );
    }
    function campos_editables($filtro_para_lectura){
        //$editables=array();
        //if(tiene_rol('programador') || tiene_rol('procesamiento')){
          $editables=array('variacion');
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
      return $this->ordenar_campos_a_listar(array('periodo','calculo','producto','nombreproducto','promedioext','anterior','variacion'));
    }
}
?>