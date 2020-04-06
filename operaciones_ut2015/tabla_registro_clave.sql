--drop table encu.registro_claves;
create table encu.registro_claves
 (
    regcla_ope              character varying(50) NOT NULL,
    regcla_usu              character varying(30) NOT NULL,
    regcla_fecha            date DEFAULT current_date ,
    regcla_enc              integer NOT NULL,
    regcla_pedido_recep     text,
    regcla_solucion_mues    integer,
    regcla_fecha_mues       date,
    regcla_comentario_mues  text,
    regcla_tlg              bigint NOT NULL,
    CONSTRAINT regcla_pkey PRIMARY KEY (regcla_ope, regcla_usu, regcla_fecha, regcla_enc),
    CONSTRAINT regcla_operativos_fk FOREIGN KEY (regcla_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT regcla_usuarios_fk FOREIGN KEY (regcla_usu)
      REFERENCES encu.usuarios (usu_usu) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,  
    CONSTRAINT regcla_tiempo_logico_fk FOREIGN KEY (regcla_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION, 
    CONSTRAINT "texto invalido en regcla_pedido_recep de tabla registro_claves" CHECK (comun.cadena_valida(regcla_pedido_recep::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en regcla_comentario_mues de registro_claves" CHECK (comun.cadena_valida(regcla_comentario_mues::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en regcla_ope de tabla registro_claves" CHECK (comun.cadena_valida(regcla_ope::text, 'codigo'::text)),
    CONSTRAINT "valor invalido en solucion_mues(1:Pendiente,2:Resuelto,3:No corresp.)"  CHECK (regcla_solucion_mues::integer in (1, 2, 3))
 );
 ALTER TABLE encu.registro_claves  OWNER TO tedede_php;
 
-- Trigger para controlar si existe la encuesta solicitada
 
-- Function: encu.verificar_existencia_enc_trg()

-- DROP FUNCTION encu.verificar_existencia_enc_trg();

CREATE OR REPLACE FUNCTION encu.verificar_existencia_enc_trg()
  RETURNS trigger AS
$BODY$
DECLARE
v_existe integer;
BEGIN
  v_existe:=0;
  if new.regcla_enc is distinct from old.regcla_enc then
    select 1 into v_existe
      from encu.plana_tem_
      where pla_enc=new.regcla_enc;
    raise notice 'enc, existe % ,%',new.regcla_enc,v_existe;
  
    if v_existe is distinct from 1  then
       raise exception 'No existe el número de encuesta : %', new.regcla_enc;
    end if; 
  end if;    
  return new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.verificar_existencia_enc_trg()
  OWNER TO tedede_php;
----   
CREATE TRIGGER verificar_existencia_enc_trg
 BEFORE UPDATE
  ON encu.registro_claves
  FOR EACH ROW
  EXECUTE PROCEDURE encu.verificar_existencia_enc_trg(); 