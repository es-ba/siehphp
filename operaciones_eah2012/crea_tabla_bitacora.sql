-- DROP TABLE encu.bitacora;

CREATE TABLE encu.bitacora
(
bit_ope character varying(50) NOT NULL,
bit_bit serial NOT NULL,
bit_proceso character varying NOT NULL,
bit_parametros character varying NOT NULL,
bit_resultado character varying,
bit_inicio timestamp NOT NULL default current_timestamp,
bit_fin timestamp,
bit_valor_respuesta boolean,
bit_tlg bigint NOT NULL,

CONSTRAINT bitacora_pkey PRIMARY KEY (bit_ope, bit_bit)
);
ALTER TABLE encu.bitacora OWNER TO tedede_php;