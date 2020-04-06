--- estos son cambios que se corren por separado con cada variable que se agregue en la TEM, para no correr calculo_estado que borra respuestas
-- alter table encu.plana_tem_ add column pla_per integer;
alter table encu.plana_tem_ alter column pla_rol TYPE text;
alter table encu.plana_tem_ drop column pla_fecha_carga_enc;      alter table encu.plana_tem_ add column pla_fecha_carga_enc       timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_primcarga_enc;  alter table encu.plana_tem_ add column pla_fecha_primcarga_enc   timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_descarga_enc;   alter table encu.plana_tem_ add column pla_fecha_descarga_enc    timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_carga_recu;     alter table encu.plana_tem_ add column pla_fecha_carga_recu      timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_primcarga_recu; alter table encu.plana_tem_ add column pla_fecha_primcarga_recu  timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_descarga_recu;  alter table encu.plana_tem_ add column pla_fecha_descarga_recu   timestamp without time zone;
alter table encu.plana_tem_ drop column pla_fecha_carga_supr;     alter table encu.plana_tem_ add column pla_fecha_carga_supr      timestamp without time zone;
alter table encu.plana_tem_ drop column pla_comenzo_ingreso;      alter table encu.plana_tem_ add column pla_comenzo_ingreso       timestamp without time zone;
alter table encu.plana_tem_ add column pla_en_campo integer;
alter table encu.plana_tem_ add column pla_fecha_comenzo_descarga timestamp without time zone;
