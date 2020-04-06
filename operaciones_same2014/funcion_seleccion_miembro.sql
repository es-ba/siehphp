-- Function: dbo.seleccion_miembro(integer)

-- DROP FUNCTION dbo.seleccion_miembro(integer, integer);

CREATE OR REPLACE FUNCTION dbo.seleccion_miembro(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
DECLARE v_tabla_aleatoria_miembro text[10][10];
DECLARE v_fila_aleatoria_miembro text[10];
DECLARE v_cantidad_candidatos integer;
DECLARE v_ultimo_digito integer;
DECLARE v_candidatos record;
DECLARE v_letra_elegida text;
DECLARE v_numero_letra integer;
DECLARE v_miembros_ordenados integer[];
DECLARE v_letras_ordenadas text[];
DECLARE v_ubicacion integer;
DECLARE v_miembro_elegido integer;
DECLARE i integer;
BEGIN
    -- armamos la tabla con codificacion de letras
    v_tabla_aleatoria_miembro[1]:= array['A','A','A','A','A','A','A','A','A','A'];
    v_tabla_aleatoria_miembro[2]:= array['B','A','B','A','A','B','A','A','B','B'];
    v_tabla_aleatoria_miembro[3]:= array['A','C','C','B','B','A','B','B','A','C'];
    v_tabla_aleatoria_miembro[4]:= array['B','A','A','C','C','B','D','C','D','A'];
    v_tabla_aleatoria_miembro[5]:= array['C','B','E','D','A','E','A','D','C','B'];
    v_tabla_aleatoria_miembro[6]:= array['F','D','B','A','E','C','E','A','F','D'];
    v_tabla_aleatoria_miembro[7]:= array['E','C','D','G','G','F','C','B','B','A'];
    v_tabla_aleatoria_miembro[8]:= array['D','G','A','E','C','D','B','F','H','C'];
    v_tabla_aleatoria_miembro[9]:= array['G','E','H','C','B','I','H','D','A','F'];
    v_tabla_aleatoria_miembro[10]:=array['A','H','F','B','D','J','G','C','I','E'];
    -- obtenemos ultimo digito de nro de encuesta
    v_ultimo_digito:=mod(p_enc,10);
    if v_ultimo_digito=0 then
      v_ultimo_digito:=10;
    end if;
    -- contamos personas en el rango
    v_cantidad_candidatos:=0;
    select count(distinct(pla_mie)) 
       into v_cantidad_candidatos 
       from encu.plana_s1_p
       where pla_enc=p_enc 
         and pla_hog=p_hog
         and pla_exm=0
         and pla_edad between 16 and 65;
    if v_cantidad_candidatos>0 then
        -- obtenemos los miembros candidatos ordenador por edad
        v_numero_letra:=ascii('A');
        v_ubicacion:=1;
        FOR v_candidatos IN
            select pla_mie
            from encu.plana_s1_p
                where pla_enc=p_enc 
                    and pla_hog=p_hog
                    and pla_exm=0
                    and pla_edad between 16 and 65 
                    order by pla_edad desc, case when dbo.es_fecha(dbo.texto_a_fecha(comun.fechadma(pla_f_nac_d,pla_f_nac_m,pla_f_nac_a))::text)= 1 then dbo.texto_a_fecha(comun.fechadma(pla_f_nac_d,pla_f_nac_m,pla_f_nac_a)) else null end, pla_mie
        LOOP
            v_miembros_ordenados[v_ubicacion]:=v_candidatos.pla_mie;
            v_letras_ordenadas[v_ubicacion]:=chr(v_numero_letra);
            v_numero_letra:=v_numero_letra + 1;
            v_ubicacion:=v_ubicacion + 1;
        END LOOP;
        v_fila_aleatoria_miembro:=v_tabla_aleatoria_miembro[v_cantidad_candidatos];    
        v_letra_elegida:= v_fila_aleatoria_miembro[v_ultimo_digito];
        v_miembro_elegido:=0;
        i:=1;
        while v_miembro_elegido=0 LOOP
            if v_letra_elegida = v_letras_ordenadas[i] then
                v_miembro_elegido:= v_miembros_ordenados[i];
            end if;
            i:=i+1;
        END LOOP;
    end if;
    return v_miembro_elegido;  
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.seleccion_miembro(integer,integer)
  OWNER TO tedede_php;
