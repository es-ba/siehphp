<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "tablas_planas.php";
require_once "grilla.php";

class Grilla_diccionario extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){
        $this->nombre_grilla="diccionario";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Tabla_varcondic");
        $this->tabla->campos_lookup=array(
               "i1_casosexistentes"=>true,
           ); 
        $where_agregada=" v.varcondic_dic='t39_barrio' " ;          
        $this->tabla->tablas_lookup=array(            
              "(select v.varcondic_origen as i1_barrio_origen, bc.barrio as i1_barrio, sum(bc.casosexistentes) as i1_casosexistentes
                 from varcondic v
                 left join
                   (select dbo.cadena_normalizar (pla_t39_barrio) as barrio, count(*) as casosexistentes 
                      from  plana_i1_   
                      group by pla_t39_barrio) as bc on bc.barrio=v.varcondic_origen
                 where $where_agregada     
                 group by bc.barrio , v.varcondic_origen
                 order by bc.barrio
               ) i1_"=>'varcondic_origen=i1_barrio_origen ',  
             
           );
    }         
    function campos_editables($filtro_para_lectura){
        $editables=array();
        if(tiene_rol('programador') || tiene_rol('procesamiento')){
            $editables[]='varcondic_dic';
            $editables[]='varcondic_origen';
            $editables[]='varcondic_destino';
        }
        return $editables;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }
    function puede_insertar(){
        return tiene_rol('programador') || tiene_rol('procesamiento') || tiene_rol('tematica');
    }
    function puede_eliminar(){
        return tiene_rol('programador') || tiene_rol('procesamiento');
    }
    function cantidadColumnasFijas(){
        return 2;
    }
    function campos_a_listar($filtro_para_lectura){
        return array('varcondic_dic', 'varcondic_origen', 'varcondic_destino','varcondic_cantidad', 'i1_casosexistentes');
    }
}
?>