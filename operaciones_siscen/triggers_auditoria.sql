create or replace function siscen.requerimientos_his_trg() returns trigger
  language plpgsql
  as
$BODY$
begin
  if tg_op='UPDATE' then
    if old.req_proy is distinct from new.req_proy then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_proy', new.req_proy, old.req_proy, current_user, 'U');
    end if;
    if old.req_req is distinct from new.req_req then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_req', new.req_req, old.req_req, current_user, 'U');
    end if;
    if old.req_titulo is distinct from new.req_titulo then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_titulo', new.req_titulo, old.req_titulo, current_user, 'U');
    end if;
    if old.req_tiporeq is distinct from new.req_tiporeq then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_tiporeq', new.req_tiporeq, old.req_tiporeq, current_user, 'U');
    end if;
    if old.req_detalles is distinct from new.req_detalles then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_detalles', new.req_detalles, old.req_detalles, current_user, 'U');
    end if;
    if old.req_grupo is distinct from new.req_grupo then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_grupo', new.req_grupo, old.req_grupo, current_user, 'U');
    end if;
    if old.req_componente is distinct from new.req_componente then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_componente', new.req_componente, old.req_componente, current_user, 'U');
    end if;
    if old.req_prioridad is distinct from new.req_prioridad then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_prioridad', new.req_prioridad, old.req_prioridad, current_user, 'U');
    end if;
    if old.req_costo is distinct from new.req_costo then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_costo', new.req_costo, old.req_costo, current_user, 'U');
    end if;
    if old.req_tlg is distinct from new.req_tlg then 
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_tlg', new.req_tlg, old.req_tlg, current_user, 'U');
    end if;
    return new;
  elsif tg_op='INSERT' then
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_proy', new.req_proy, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_req', new.req_req, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_titulo', new.req_titulo, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_tiporeq', new.req_tiporeq, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_detalles', new.req_detalles, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_grupo', new.req_grupo, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_componente', new.req_componente, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_prioridad', new.req_prioridad, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_costo', new.req_costo, null, current_user, 'I');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (new.req_proy,new.req_req, 'req_tlg', new.req_tlg, null, current_user, 'I');
      return new;
  elsif tg_op='DELETE' then
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_proy', null, old.req_proy, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_req', null, old.req_req, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_titulo', null, old.req_titulo, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_tiporeq', null, old.req_tiporeq, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_detalles', null, old.req_detalles, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_grupo', null, old.req_grupo, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_componente', null, old.req_componente, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_prioridad', null, old.req_prioridad, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_costo', null, old.req_costo, current_user, 'D');
      insert into siscen.his_requerimientos(req_proy,req_req, campo, valor_actual, valor_anterior, usuario, operacion) values (old.req_proy,old.req_req, 'req_tlg', null, old.req_tlg, current_user, 'D');
      return null;
  end if;
end;
$BODY$;
/*OTRA*/
CREATE TRIGGER his_requerimientos_trg AFTER INSERT or UPDATE or DELETE
    ON siscen.requerimientos
    FOR EACH ROW 
    EXECUTE PROCEDURE siscen.requerimientos_his_trg();