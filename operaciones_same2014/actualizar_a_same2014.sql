
CREATE OR REPLACE FUNCTION dbo.ope_actual() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 'same2013';
end;
$$;
/*OTRA*/
ALTER FUNCTION dbo.ope_actual() OWNER TO tedede_php;
