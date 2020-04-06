--EAH2013 nueva tabla dicvar
--DROP TABLE IF EXISTS encu.dicvar;
CREATE TABLE encu.dicvar
(
  dicvar_dic text NOT NULL,
  dicvar_var text NOT NULL,
  dicvar_tlg bigint,
  CONSTRAINT dicvar_pk PRIMARY KEY (dicvar_dic, dicvar_var),
  CONSTRAINT dicvar_diccionario_fk FOREIGN KEY (dicvar_dic)
  REFERENCES encu.diccionario (dic_dic) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT dicvar_tiempo_logico_fk FOREIGN KEY (dicvar_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE encu.dicvar
  OWNER TO tedede_php;
  
INSERT INTO encu.dicvar(
            dicvar_dic, dicvar_var, dicvar_tlg)
    VALUES ('serv_dom_txt', 't37', 1),
           ('barrio', 't39_barrio', 1);