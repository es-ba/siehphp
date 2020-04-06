-- Table: encu.semanas
-- DROP TABLE encu.semanas;

CREATE TABLE encu.semanas
(
  sem_ope character varying(50) NOT NULL,
  sem_sem integer NOT NULL,
  sem_semana_referencia_desde date,
  sem_semana_referencia_hasta date,
  sem_30dias_referencia_desde date,
  sem_30dias_referencia_hasta date, 
  sem_mes_referencia date,
  sem_carga_enc_desde date,
  sem_carga_enc_hasta date,
  sem_carga_recu_desde date,
  sem_carga_recu_hasta date,
  sem_tlg bigint NOT NULL,
  CONSTRAINT semanas_pkey PRIMARY KEY (sem_ope,sem_sem),
  CONSTRAINT semanas_tiempo_logico_fk FOREIGN KEY (sem_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE encu.semanas
  OWNER TO tedede_php;

ALTER TABLE encu.semanas ADD CONSTRAINT "El día de sem_mes_referencia debe ser 1"  CHECK (comun.es_dia_1(sem_mes_referencia));