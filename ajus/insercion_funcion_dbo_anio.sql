CREATE OR REPLACE FUNCTION dbo.anio()
  RETURNS integer AS
$BODY$
begin
	return 2012;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;