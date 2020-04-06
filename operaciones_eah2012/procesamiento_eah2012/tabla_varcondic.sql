--EAH2013 nueva tabla varcondic
--DROP TABLE IF EXISTS encu.varcondic;
CREATE TABLE encu.varcondic
(
  varcondic_dic text NOT NULL,
  varcondic_origen text NOT NULL,
  varcondic_destino integer,
  varcondic_cantidad integer,
  CONSTRAINT varcondic_pk PRIMARY KEY (varcondic_dic, varcondic_origen)
);

ALTER TABLE encu.varcondic
  OWNER TO tedede_php;