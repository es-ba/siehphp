<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_baspro_var extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="baspro_var";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_baspro_var");
        $this->tabla->campos_lookup=array(
               "var_for"=>false,
               "varcal_destino"=>false,
               "table_name"=>false,
               "bases"=>false,
               "nombre_largo_para_documentacion"=>false,
           ); 
        $this->tabla->tablas_lookup=array( 
            "variables va"=>'va.var_var=basprovar_var AND va.var_ope=basprovar_ope',
            "varcal vc"=>'vc.varcal_varcal=basprovar_var AND vc.varcal_ope=basprovar_ope',
            "(SELECT basprovar_baspro baseinfo, basprovar_var as variableinfo, encu.tabla_variable(basprovar_var) as table_name
                   FROM baspro_var  
                ) as c"
            =>'variableinfo=basprovar_var  and baseinfo=basprovar_baspro',
            "(SELECT basprovar_var as bases_var, string_agg(basprovar_baspro,', ' order by basprovar_baspro) as bases
                FROM baspro_var
                GROUP BY basprovar_var) bases"=>"bases_var=basprovar_var",
            "(SELECT basprovar_ope as ope, basprovar_baspro as base,coalesce(var_var,varcal_varcal) as variable, encu.nombre_largo_para_documentacion(basprovar_var,basprovar_baspro) as nombre_largo_para_documentacion
              FROM baspro_var b 
                LEFT JOIN variables v ON b.basprovar_ope = v.var_ope AND b.basprovar_var = v.var_var
                LEFT JOIN varcal c ON b.basprovar_ope = c.varcal_ope AND b.basprovar_var = c.varcal_varcal
                LEFT JOIN preguntas p ON v.var_ope = p.pre_ope AND v.var_pre = p.pre_pre) as dr"
            =>'dr.variable=basprovar_var AND dr.base=basprovar_baspro AND dr.ope=basprovar_ope',
        );
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
          $editables=array('basprovar_ope','basprovar_baspro','basprovar_var','basprovar_alias','basprovar_cantdecimales','basprovar_orden','basprovar_exportar_en');
        }
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return true;
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function campos_a_listar($filtro_para_lectura){
        return array(  'basprovar_ope',
                       'basprovar_baspro', 
                       'basprovar_var',
                       'basprovar_orden',                       
                       'basprovar_alias',
                       'basprovar_cantdecimales',
                       'basprovar_exportar_en',                       
                       'var_for', 
                       'varcal_destino', 
                       'table_name',
                       'bases',
                       'nombre_largo_para_documentacion');
    }
}
?>