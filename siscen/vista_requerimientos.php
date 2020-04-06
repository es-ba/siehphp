<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
//require_once "grilla_respuestas.php";

class Vista_requerimientos extends Vistas{
    function definicion_estructura(){
        //$mostrar_plazo = true;
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('req_proy',array('tipo'=>'texto','es_pk'=>true, 'origen'=>'b.reqnov_proy'));
        $this->definir_campo('req_req' ,array('tipo'=>'texto', 'es_pk'=>true, 'largo'=>10, 'origen'=>'b.reqnov_req'));
        $this->definir_campo('req_titulo',array('tipo'=>'texto','largo'=>100, 'origen'=>'r.req_titulo'));
        $this->definir_campo('req_tiporeq',array('tipo'=>'texto', 'origen'=>'r.req_tiporeq'));
        $this->definir_campo('req_prioridad',array('tipo'=>'entero', 'origen'=>'r.req_prioridad'));
        $this->definir_campo('req_costo',array('tipo'=>'entero', 'origen'=>'r.req_costo'));
        //$this->definir_campo('req_detalles',array('tipo'=>'texto','largo'=>400, 'origen'=>'r.req_detalles'));
        $this->definir_campo('req_grupo',array('tipo'=>'texto','largo'=>50, 'origen'=>'r.req_grupo'));
        $this->definir_campo('req_componente',array('tipo'=>'texto','largo'=>50, 'origen'=>'r.req_componente'));
        $this->definir_campo('req_estado',array('tipo'=>'texto','largo'=>50, 'origen'=>'c.reqnov_reqest'));
        $this->definir_campo('req_lado',array('tipo'=>'texto','largo'=>50, 'origen'=>'d.reqest_lado', 'invisible'=>true));
        $this->definir_campo('req_fecha_confirmacion',array('tipo'=>'timestamp', 'origen'=>'b.momento_conf'));
        $this->definir_campo('req_fecha_ultima_novedad',array('tipo'=>'timestamp', 'origen'=>'b.momento_ult'));
        //if($mostrar_plazo){
            $this->definir_campo('req_plazo',array('tipo'=>'timestamp', 'origen'=>'r.req_plazo'));
        //}
        if(tiene_rol('programador')){
            $this->definir_campo('estado_trac',array('tipo'=>'texto', 'origen'=>'t.estado_trac'));
            $this->definir_campo('owners',array('tipo'=>'texto', 'origen'=>'t.owners'));
            $this->definir_campo('intervenir',array('tipo'=>'texto', 'origen'=><<<SQL
                case when req_estado='verificado' then '6.Verif' 
                    when req_estado='terminado' and estado_trac='terminado' then '5.U.F.V.'
                    when req_estado in ('confirmado','contestado') and estado_trac='empezado' then '4.Haciendo'
                    when req_estado in ('duda','terminado') then '3.Usu'
                    when req_estado in ('borrador') then '2.Viendo'
                    else '1.Intevenir'
                end
SQL
            ));
        }
        $this->definir_campos_orden(array('req_proy','para_ordenar_numeros(b.reqnov_req)'));
    }
    function clausula_from(){
        $con_tickets=tiene_rol('programador')?"inner join siscen.control_siscen t on t.req_proy=r.req_proy and t.req_req=r.req_req":"";
        return <<<SQL
           (select a.reqnov_proy, a.reqnov_req, max(a.momento_conf) momento_conf, max(a.momento_ult) momento_ult, max(a.ult_nov) ult_nov
                from (
                  select reqnov_proy, reqnov_req ,min(tlg_momento) as momento_conf, null as momento_ult, null as ult_nov 
                    from siscen.req_nov 
                      inner join siscen.tiempo_logico on tlg_tlg=reqnov_tlg
                    where reqnov_reqest = 'confirmado' 
                    group by reqnov_proy, reqnov_req
                  union
                  select reqnov_proy, reqnov_req, null as momento_conf, max(tlg_momento) as momento_ult, max(reqnov_reqnov) as ult_nov  
                    from siscen.req_nov
                      inner join siscen.tiempo_logico on tlg_tlg=reqnov_tlg
                      inner join siscen.req_est on reqnov_reqest=reqest_reqest
                    group by reqnov_proy, reqnov_req
                ) a 
            group by a.reqnov_proy, a.reqnov_req) b
              inner join siscen.req_nov c on c.reqnov_proy=b.reqnov_proy and c.reqnov_req=b.reqnov_req  and b.ult_nov=c.reqnov_reqnov 
              inner join siscen.req_est d on c.reqnov_reqest=d.reqest_reqest
              inner join siscen.requerimientos r on c.reqnov_proy = r.req_proy and c.reqnov_req = r.req_req 
              inner join siscen.proy_usu on b.reqnov_proy=proyusu_proy 
              {$con_tickets}
SQL;
    }
    function clausula_where_agregada(){
        return " and proyusu_usu='".usuario_actual()."' ";
    }
}
?>