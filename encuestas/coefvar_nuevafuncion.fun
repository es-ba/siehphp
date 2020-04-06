--TABLA
--DROP TABLE IF EXISTS encu.coef_var_b;

CREATE TABLE encu.coef_var_b
(
  coefvarb_tabla character varying(50) NOT NULL,
  coefvarb_grzona character varying(1) NOT NULL,
  coefvarb_zona integer NOT NULL,
  coefvarb_b0 numeric,
  coefvarb_b1 numeric,
  coefvarb_formula integer,
  coefvarb_tlg bigint NOT NULL,
  CONSTRAINT coefvarb_pkey PRIMARY KEY ( coefvarb_tabla, coefvarb_grzona, coefvarb_zona),
  CONSTRAINT coefvarb_tiempo_logico_fk FOREIGN KEY (coefvarb_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 CONSTRAINT "valor invalido en coefvarb_formula (1,2)" CHECK (coefvarb_formula in (1,2)),
 CONSTRAINT "valor invalido en coefvarb_grzona(T,C,Z)" CHECK (coefvarb_grzona in ('T','C','Z'))
);
ALTER TABLE encu.coef_var_b
  OWNER TO tedede_php;


--CARGA eah2017
insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula,coefvarb_tlg) values ('personas','T',0,-0.000011275,213.544,1,1);
insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',1,0.000253037,183.994,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',2,-0.000867942,162.789,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',3,5.82003,-1.06091,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',4,-0.000008042,165.503,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',5,-0.000549434,216.864,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',6,-0.000167985,208.423,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',7,6.07909,-1.08962,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',8,3.55315,-0.84628,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',9,0.000065322,180.326,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',10,5.68931,-1.05991,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',11,-0.000066297,215.4,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',12,0.000256748,254.638,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',13,-0.000353635,276.939,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',14,-0.000783962,301.369,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','C',15,6.55022,-1.13712,2,1);
insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','Z',1,-0.000229446,267.145,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','Z',2,5.34105,-0.99842,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,coefvarb_formula, coefvarb_tlg) values ('personas','Z',3,0.000026971,166.351,1,1);

insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1, coefvarb_formula,coefvarb_tlg) values ('hogares','T',0,6.52403,-1.11781,2,1);
insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',1,7.72209,-1.30274,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',2,-0.001440623,154.5,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',3,-0.001600411,190.459,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',4,-0.00147882,151.258,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',5,7.63367,-1.27668,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',6,-0.001631944,213.538,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',7,6.46925,-1.14124,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',8,-0.000089829,103.004,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',9,-0.003434399,251.677,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',10,-0.002610174,218.394,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',11,-0.002833747,288.45,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',12,-0.002232027,286.617,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',13,-0.001621466,270.348,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',14,-0.000822487,260.589,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1,  coefvarb_formula,coefvarb_tlg) values ('hogares','C',15,-0.001864132,272.742,1,1);
insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1, coefvarb_formula,coefvarb_tlg) values ('hogares','Z',1,6.45177,-1.11446,2,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1, coefvarb_formula,coefvarb_tlg) values ('hogares','Z',2,-0.000173193,201.736,1,1);	insert into encu.coef_var_b(coefvarb_tabla, coefvarb_grzona,coefvarb_zona, coefvarb_b0,coefvarb_b1, coefvarb_formula,coefvarb_tlg) values ('hogares','Z',3,-0.000262619,159.973,1,1);


select * from encu.coef_var_b
where coefvarb_grzona='C' and c;
select *
from encu.coef_var_b
where coefvarb_tabla='personas';


--FUNCIONES
set search_path= dbo, encu;
CREATE OR REPLACE FUNCTION dbo.coef_var_b(
    p_tabla text,
    p_grzona text,
    p_zona integer,
    p_poblacion numeric)
  RETURNS numeric AS
$BODY$
select (case when coefvarb_formula=1 then sqrt(coefvarb_b0+ coefvarb_b1/ p_poblacion) else sqrt(exp(coefvarb_b0+ coefvarb_b1*ln( p_poblacion)))end * 100)::numeric
    from coef_var_b
    where coefvarb_tabla=p_tabla and coefvarb_grzona=p_grzona and coefvarb_zona=p_zona;
    -- where tabcoefvar_tabla='personas' and tabcoefvar_grzona='C' and tabcoefvar_zona=3;

$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.coef_var_b(text, text, integer, numeric)
  OWNER TO tedede_php;

select *
from tab_coef_var
where tabcoefvar_tabla='personas' and tabcoefvar_grzona='C' and tabcoefvar_zona=3;

select coef_var_b('personas', 'C', 3, 210001), 2.83, 'personas, C,3, 210001' param 
union select coef_var_b('personas', 'C', 3, 159999), 3.186, 'personas, C,3, 159999' param 
union select coef_var_b('personas', 'C', 3, 140001), 3.42, 'personas, C,3, 140001' param 
union select coef_var_b('personas', 'C', 3,   2000), 28.93, 'personas, C,3, 2000' param 
union select coef_var_b('personas', 'C', 3, 700000), 999, 'personas, C,3, 700000' param;

-- Function: dbo.coef_var_b_tasa(text, text, integer, numeric, text, integer, numeric)
-- DROP FUNCTION dbo.coef_var_b_tasa(text, text, integer, numeric, text, integer, numeric);

CREATE OR REPLACE FUNCTION dbo.coef_var_b_tasa(
    p_tabla text,
    p_grzona_n text,
    p_zona_n integer,
    p_numerador numeric,
    p_grzona_d text,
    p_zona_d integer,
    p_denominador numeric)
  RETURNS numeric AS
$BODY$
  select round(sqrt(v_n*v_n-v_d*v_d),16)
    from (select dbo.coef_var_b(p_tabla, p_grzona_n, p_zona_n, p_numerador) as v_n,
                 dbo.coef_var_b(p_tabla, p_grzona_d, p_zona_d, p_denominador) as v_d) x;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.coef_var_b_tasa(text, text, integer, numeric, text, integer, numeric)
  OWNER TO tedede_owner;
  
----------------prueba nueva actualización----------------------  
--42,2437588640744866
--42,2437588640744866	
set search_path=encu;
select dbo.coef_var_b_tasa('hogares', 'Z' ,2, 1145, 'Z' ,2 , 708554), 42.2437588640744866,  'hogares, Z ,2, 1145, Z ,2 , 708554' param  
--42.2437588640744866;42.2437588640744866;"hogares, Z ,2, 1145, Z ,2 , 708554"
----------------------------------------------------------------
 
--para tratamiento de excepciones. NO IMPLEMENTADO 
EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                          text_var2 = PG_EXCEPTION_DETAIL,
                          text_var3 = PG_EXCEPTION_HINT;
  RAISE EXCEPTION 'Error al calcular CV tasa parametros ('||
    p_tabla ||','||p_grzona_n||','||p_zona_n::text||','||p_numerador::text||','||
    p_grzona_d||','||p_zona_d::text||','||p_denominador::text||
    'MENS:'|| MESSAGE_TEXT || ' EXC DETALLE:'|| text_var2||' EXC AYUDA:'||text_var3 ;
    