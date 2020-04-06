create extension dblink;

CREATE SCHEMA link_siscen
       AUTHORIZATION trac;

CREATE OR REPLACE VIEW link_siscen.trac_req_resumen AS 
        SELECT req_proy, req_req, req_titulo, req_tiporeq, req_detalles, req_grupo, req_componente, 
         req_prioridad, req_costo, req_tlg, req_id, req_estado, reqest_lado 
         from dblink('host=localhost dbname=siscen_db user=siscen_php password=laclave',
        'SELECT req_proy, req_req, req_titulo, req_tiporeq, req_detalles, req_grupo, req_componente, 
         req_prioridad, req_costo, req_tlg, req_id, req_estado, reqest_lado
         FROM siscen.req_resumen;') as (req_proy character varying(50), req_req character varying(10), req_titulo character varying(100), req_tiporeq character varying(50), 
         req_detalles text, req_grupo character varying(50), req_componente character varying(50), 
         req_prioridad integer, req_costo integer, req_tlg bigint, req_id text, req_estado text, reqest_lado character varying(50));
ALTER TABLE link_siscen.trac_req_resumen
  OWNER TO trac;

