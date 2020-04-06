--EAH2013 nueva tabla diccionario
--DROP TABLE IF EXISTS encu.diccionario;
CREATE TABLE encu.diccionario
(
  dic_dic text NOT NULL,
  dic_completo boolean default false,
  dic_tlg bigint,
  CONSTRAINT diccionario_pk PRIMARY KEY (dic_dic),
  CONSTRAINT diccionario_tiempo_logico_fk FOREIGN KEY (dic_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE encu.diccionario
  OWNER TO tedede_php;
  
INSERT INTO encu.diccionario(
            dic_dic, dic_completo, dic_tlg)
    VALUES ('serv_dom_txt', false, 1),
           ('barrio', true, 1);