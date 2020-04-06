<?php
//UTF-8:SÍ
 require_once "lo_imprescindible.php";
 // require_once "tablas_planas.php";
 require_once "grilla.php";

class Grilla_operativos extends Grilla_tabla{
    // function iniciar($nombre_del_objeto_base){
        // $this->nombre_grilla="personas";
        // $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_personas");
        // $this->tabla->campos_lookup=array(
               // "fecha_ultima_modificacion"=>false,               
           // ); 
        // $this->tabla->tablas_lookup=array( 
            // "(select varcalopc_varcal, max(tlg_momento) as fecha_ultima_modificacion from varcalopc vco join tiempo_logico t on t.tlg_tlg=vco.varcalopc_tlg join sesiones s on s.ses_ses=t.tlg_ses where varcalopc_tlg>1 group by varcalopc_varcal) as t"=>'t.varcalopc_varcal=varcal_varcal',
        // );
    // }   
    // function permite_grilla_sin_filtro(){
        // return true;
    // }    
    function puede_insertar(){
        return tiene_rol('rrhh') || tiene_rol('suprrhh');
    }
    function puede_eliminar(){
        return tiene_rol('suprrhh');
    }
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('rrhh')|| tiene_rol('suprrhh')){
            return   parent::campos_editables($filtro_para_lectura);
        }
        return $editables;
    }
}
?>