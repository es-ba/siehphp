CREATE OR REPLACE FUNCTION dbo.ope_actual()
  RETURNS text AS
$BODY$
begin
    return 'etoi191';
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION dbo.ope_actual()
  OWNER TO tedede_php;
CREATE OR REPLACE FUNCTION dbo.anio()
  RETURNS integer AS
$BODY$
begin
    return 2019;
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

ALTER FUNCTION dbo.anio()
  OWNER TO tedede_php;
