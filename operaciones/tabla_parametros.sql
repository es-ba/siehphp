-- Table: encu.parametros

-- DROP TABLE encu.parametros;
create table encu.parametros
(
    par_unicoregistro boolean NOT NULL DEFAULT true,
    par_ope character varying(50) NOT NULL,
    par_anio integer NOT NULL,
    par_periodo_ipcba character varying(11),  
    par_anio_ipcba integer,
    par_mes_ipcba integer,
    par_tlg bigint NOT NULL,
    CONSTRAINT parametros_pkey PRIMARY KEY (par_unicoregistro),
    CONSTRAINT parametros_unicoregistro_check CHECK (par_unicoregistro),
    CONSTRAINT parametros_operativos_fk FOREIGN KEY (par_ope)
        REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT parametros_tiempo_logico_fk FOREIGN KEY (par_tlg)
        REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE encu.parametros
  OWNER TO tedede_php;
  
--para etoi162
--insert into encu.parametros(par_unicoregistro,par_ope, par_anio,par_periodo_ipcba,par_anio_ipcba,par_mes_ipcba, par_tlg ) values (TRUE,'etoi162',2016,'a2016m05',2016,5,1); 