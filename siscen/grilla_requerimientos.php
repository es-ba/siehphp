<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "vista_requerimientos.php";

class Grilla_requerimientos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){  
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("Vista_requerimientos");
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'V',
            'title'=>'Ver requerimiento',
            'proceso'=>'agregar_novedades_req',
            'campos_parametros'=>array('tra_proy'=>null, 'tra_req'=>null),
            'y_luego'=>'buscar'
        );
    }
    function campos_a_excluir($filtro_para_lectura){
        return array(
            'req_lado',
        );  
    }
    function campos_editables($filtro_para_lectura){
        return array();  
    }
}



/*
class Grilla_requerimientos extends Grilla_tabla{
    function iniciar($nombre_del_objeto_base){  
        $this->nombre_grilla="requerimientos";
        $this->tabla_o_vista=$this->tabla=$this->contexto->nuevo_objeto("tabla_requerimientos");
        //$this->tabla->datos->req_plazo = (is_null($this->tabla->datos->req_plazo) ? null : date_format(date_create($$this->tabla->datos->req_plazo),'d-m-Y'));

        if (tiene_rol('programador')){
            $this->tabla->campos_lookup=array(
               "fecha_confirmacion"           => false,
               "fecha_ultima_novedad"         => false,
               "req_lado"                     => false,
               "req_estado"                   => false,
               "trac"                         => false,
               "owners"                       => false,
               "intervenir"                   => false,
            ); 
        } else{
            $this->tabla->campos_lookup=array(
               "fecha_confirmacion"           => false,
               "fecha_ultima_novedad"         => false,
               "req_lado"                     => false,
               "req_estado"                   => false,
            );        
        }
        $con_tickets_from=tiene_rol('programador')?" inner join (select req_proy, req_req, estado_trac as trac, owners from siscen.control_siscen) t on t.req_proy=b.proy and t.req_req=b.req":"";
        $con_tickets_sel=tiene_rol('programador')?" ,t.trac, t.owners, case when c.reqnov_reqest='verificado' then '6.Verif' 
                    when c.reqnov_reqest='terminado' and trac='terminado' then '5.U.F.V.'
                    when c.reqnov_reqest in ('confirmado','contestado') and trac='empezado' then '4.Haciendo'
                    when c.reqnov_reqest in ('duda','terminado') then '3.Usu'
                    when c.reqnov_reqest in ('borrador') then '2.Viendo'
                    else '1.Intevenir'
                end as intervenir ":"";
        $this->tabla->tablas_lookup=array(
            "(SELECT b.*,c.reqnov_reqest as req_estado,e.reqest_lado as req_lado {$con_tickets_sel} FROM
             (SELECT a.reqnov_proy AS proy, a.reqnov_req AS req, to_char(max(a.momento_conf),'DD/MM/YYYY') fecha_confirmacion, to_char(max(a.momento_ult),'DD/MM/YYYY') fecha_ultima_novedad, max(a.ult_nov) ult_nov
              FROM (SELECT reqnov_proy, reqnov_req ,min(tlg_momento) as momento_conf, null as momento_ult, null as ult_nov 
                      FROM siscen.req_nov 
                      inner join siscen.tiempo_logico on tlg_tlg=reqnov_tlg
                      where reqnov_reqest = 'confirmado' 
                      group by reqnov_proy, reqnov_req
                    UNION
                    SELECT reqnov_proy, reqnov_req, null as momento_conf, max(tlg_momento) as momento_ult, max(reqnov_reqnov) as ult_nov  
                      FROM siscen.req_nov
                      inner join siscen.tiempo_logico on tlg_tlg=reqnov_tlg
                      inner join siscen.req_est on reqnov_reqest=reqest_reqest
                      group by reqnov_proy, reqnov_req
                    ) a 
              group by a.reqnov_proy, a.reqnov_req) b
              inner join siscen.req_nov c on c.reqnov_proy=b.proy and c.reqnov_req=b.req and b.ult_nov=c.reqnov_reqnov
              inner join siscen.req_est e on e.reqest_reqest = c.reqnov_reqest {$con_tickets_from}) d"=>'d.proy=req_proy and d.req =req_req'
        );
    }
    function campos_editables($filtro_para_lectura){
        //$editables=array();
        //if(tiene_rol('mues_campo') || tiene_rol('programador') ){
        $editables=array('req_costo','req_plazo');
        //    };
        return $editables;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'V',
            'title'=>'Ver requerimiento',
            'proceso'=>'agregar_novedades_req',
            'campos_parametros'=>array('tra_proy'=>null, 'tra_req'=>null),
            'y_luego'=>'buscar'
        );
    }
    function campos_a_excluir($filtro_para_lectura){
        return array(
            'req_detalles'
        );  
    }
    function campos_a_listar($filtro_para_lectura){
        $a_listar = array('req_proy'       
                    ,'req_req' 
                    ,'req_titulo'      
                    ,'req_tiporeq'
                    ,'req_prioridad'
                    ,'req_costo'
                    ,'req_grupo'
                    ,'req_componente'
                    ,'req_estado'
                    ,'fecha_confirmacion'
                    ,'fecha_ultima_novedad'
                    ,'req_plazo'
                    ,'req_lado');
        if (tiene_rol('programador')){
            array_push($a_listar,'trac','owners','intervenir');
        }
        return $a_listar;
    }
     
   )    
   //function puede_insertar(){
   //   return tiene_rol('mues_campo') || tiene_rol('programador');
   //}
   //function puede_eliminar(){
   //    return tiene_rol('mues_campo');
   //}
}
*/
?>