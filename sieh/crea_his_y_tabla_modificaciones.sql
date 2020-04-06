CREATE SCHEMA his;
ALTER SCHEMA his OWNER TO tedede_owner;


CREATE TABLE his.modificaciones (
    mdf_mdf serial NOT NULL,
    mdf_tabla character varying(50) NOT NULL,
    mdf_operacion character varying(1) NOT NULL,
    mdf_pk character varying(2000) NOT NULL,
    mdf_campo character varying(2000) NOT NULL,
    mdf_actual text,
    mdf_anterior text,
    mdf_tlg bigint
);

ALTER TABLE rrhh.sesiones ADD COLUMN ses_tipo text;
ALTER TABLE rrhh.sesiones ALTER COLUMN ses_tipo SET NOT NULL;
ALTER TABLE rrhh.sesiones ALTER COLUMN ses_tipo SET DEFAULT 'php'::text;
