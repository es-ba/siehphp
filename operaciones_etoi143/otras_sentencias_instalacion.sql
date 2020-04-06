CREATE SEQUENCE encu.numeros_de_carga
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
/*OTRA*/
CREATE OR REPLACE FUNCTION dbo.ope_actual() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 'etoi143';
end;
$$;
/*OTRA*/
ALTER FUNCTION dbo.ope_actual() OWNER TO tedede_php;
    