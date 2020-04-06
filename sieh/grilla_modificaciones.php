<?php
//UTF-8:SÍ
 require_once "lo_imprescindible.php";
 // require_once "tablas_planas.php";
 require_once "grilla.php";

class Grilla_modificaciones extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="modificaciones";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_modificaciones");
        $this->tabla->campos_lookup=array(
               "vis_fecha"=>false,               
               "vis_usuario"=>false               
           ); 
        $this->tabla->tablas_lookup=array( 
            "(select tlg_tlg, tlg_momento as vis_fecha, ses_usu as vis_usuario from his.modificaciones join rrhh.tiempo_logico on tlg_tlg = mdf_tlg join rrhh.sesiones on tlg_ses=ses_ses ) as t"=>'t.tlg_tlg=mdf_tlg',
        );
    }
    function campos_editables($filtro_para_lectura){
        return array();
    }
}
?>