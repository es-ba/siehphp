<?php
//UTF-8:SÍ
// require_once "tabla_formularios.php";
require_once "tablas.php";

class Tabla_req_nov extends Tabla{
    function definicion_estructura(){
        $this->definir_prefijo('reqnov');
        $this->definir_esquema($GLOBALS['esquema_principal']);
        $this->definir_campo('reqnov_proy'      ,array('hereda'=>'proyectos','modo'=>'pk'));
        $this->definir_campo('reqnov_req'       ,array('hereda'=>'requerimientos','modo'=>'pk'));
        $this->definir_campo('reqnov_reqnov'    ,array('es_pk'=>true,'tipo'=>'entero'));
        $this->definir_campo('reqnov_comentario',array('tipo'=>'texto','largo'=>1000));
        $this->definir_campo('reqnov_reqest'    ,array('hereda'=>'req_est','modo'=>'fk_optativa')); // es optativa porque puede haber un comentario sin cambio de estado. 
        $this->definir_campo('reqnov_campo'     ,array('tipo'=>'texto','largo'=>30));
        $this->definir_campo('reqnov_anterior'  ,array('tipo'=>'texto','largo'=>100));
        $this->definir_campo('reqnov_actual'    ,array('tipo'=>'texto','largo'=>100));
    }
    function restricciones_especificas(){
        $BODY='$BODY';
        $todas=<<<SQL
        create or replace function siscen.reqnov_ins_trg()
        returns trigger as
        $BODY$ 
        DECLARE
        v_max_tlg int;
        v_ultimo_reqest text;
        v_cuantos_0 int;
        v_cuantos int;
        BEGIN
         select count(*) into v_cuantos_0 from siscen.req_nov where reqnov_proy = new.reqnov_proy and reqnov_req=new.reqnov_req;
         if v_cuantos_0 > 0 then
           select max(reqnov_tlg) into v_max_tlg from siscen.req_nov where reqnov_proy = new.reqnov_proy and reqnov_req = new.reqnov_req and reqnov_tlg <= new.reqnov_tlg;
           select reqnov_reqest into v_ultimo_reqest from siscen.req_nov where reqnov_proy = new.reqnov_proy and reqnov_req=new.reqnov_req and reqnov_tlg=v_max_tlg;
           select count(*) into v_cuantos from siscen.req_est_flu where reqestflu_origen = v_ultimo_reqest and reqestflu_destino = new.reqnov_reqest;
           if v_cuantos = 0 then 
                  RAISE 'reqnov_ins_trg : Fuera de flujo. % - % ', v_ultimo_reqest, new.reqnov_reqest;
           end if;
         end if;
        RETURN new;
        END
        $BODY$ 
        LANGUAGE plpgsql;
/*OTRA*/
        ALTER FUNCTION siscen.reqnov_ins_trg() OWNER TO siscen_php;
/*OTRA*/
        CREATE TRIGGER reqnov_ins_trg
          BEFORE INSERT
          ON siscen.req_nov
          FOR EACH ROW
          EXECUTE PROCEDURE siscen.reqnov_ins_trg();
SQL;
        $sqls=new Sqls();
        foreach(explode('/*OTRA*/',$todas) as $sentencia){
            $sqls->agregar(new Sql($sentencia));
        }
        return $sqls;
    }
}
?>