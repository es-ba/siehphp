set search_path=encu, comun, public;
alter table encu.dictra
  add column dictra_texto character varying(100);

ALTER TABLE encu.dictra
 ADD CONSTRAINT "texto de diccionario inválido" CHECK (comun.cadena_valida(dictra_texto::text, 'castellano'::text));

  

