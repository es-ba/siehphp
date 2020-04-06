<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_t39_barrio_noendic extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="t39_barrio_noendic";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_plana_i1_");
     
       $this->tabla->campos_lookup=array(
               "v_barrio_normalizado"=>true,
           ); 
        $condicion= "  and v.varcondic_dic='t39_barrio' ";
        $this->tabla->tablas_lookup=array(            
              "(  select  pla_t39_barrio as v_barrio_orig, comun.cadena_normalizar (pla_t39_barrio) as v_barrio_normalizado 
                    from plana_i1_ i  
                    left join varcondic v on v.varcondic_origen=comun.cadena_normalizar (pla_t39_barrio) $condicion
                    where  v.varcondic_origen is null and pla_t39_barrio is not null and pla_t39_barrio not in ('-1','-9')
                    group by pla_t39_barrio
               ) v_"=>'pla_t39_barrio=v_barrio_orig ',  
             
           );
    }         
  /* consultar sino hay que hacerla a traves de grilla_respuestas.   
   function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='pla_t39_barrio';
        }
        return $editables;
    }
  */  
    function permite_grilla_sin_filtro(){
        return true;
    }
  /*
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('tematica');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    } 
    */
    function cantidadColumnasFijas(){
        return 3;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('pla_enc', 'pla_hog', 'pla_mie','pla_exm', 'pla_t39','pla_t39_barrio', 'v_barrio_normalizado');
    }
}
?>