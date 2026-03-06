set role tedede_php;
--CREATE TEMP TABLE operaciones.metadatos_tablas(
drop table if exists operaciones.metadatos_tablas;
CREATE  TABLE operaciones.metadatos_tablas(
  tabla             text PRIMARY KEY,
  orden_descarga    integer,
  orden_carga       integer
  );
INSERT INTO
  operaciones.metadatos_tablas(tabla, orden_descarga, orden_carga)
VALUES
('bloques',1,40),
('con_opc',3,50),
('filtros',5,60),
('formularios',7,10),
('matrices',9,30),
('opciones',11,70),
('preguntas',13,80),
('saltos',15,100),
('ua',17,20),
('variables',19,90)
;
--CREATE TEMP TABLE operaciones.metadatos_acciones(
drop table if exists operaciones.metadatos_acciones;
CREATE TABLE operaciones.metadatos_acciones(
  accion    text PRIMARY KEY,
  esquema_origen   text,
  esquema_destino  text,
  pattern   text
  --operativo_origen text
  );
INSERT INTO
  operaciones.metadatos_acciones(accion, esquema_origen, esquema_destino, pattern)
    --,operativo_origen)
VALUES
('cargar_nuevo_ope_desde_anterior','encu_anterior','encu',$$INSERT INTO ##esquema_destino##.##tabla##(##campos##)
  SELECT ##campos_valores##
    FROM ##esquema_origen##.##tabla##
    WHERE ##campo_ope##=(SELECT ope_ope_anterior FROM ##esquema_destino##.operativos WHERE ope_ope=dbo.ope_actual());
$$),--'etoi254')
('cargar_nuevo_ope_desde_viejo', 'operaciones_metadatos','encu',$$INSERT INTO ##esquema_destino##.##tabla##(##campos##)
  SELECT ##campos_valores##
    FROM ##esquema_origen##.##tabla##;
$$),
('extraer_ope_actual','encu','operaciones_metadatos',$$SELECT * INTO ##esquema_destino##.##tabla## 
   FROM ##esquema_origen##.##tabla## WHERE ##campo_ope##=dbo.ope_actual();
$$)
;


CREATE OR REPLACE FUNCTION operaciones.generar_metadatos_funciones(
    paccion TEXT)
    RETURNS void
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    vcodigo     text;
    vnombrefun  text;
    vqesquema   text;
    vaccion     RECORD;
    vpattern    text; 
    vtablas     RECORD;
    vqtablas    text;
    vqlatabla   text;
    vcampos     text;
    vcampos_valores     text;
    vcampo_ope  text;
    
BEGIN
/* primera version reproduce la factorizacion de lo que estaba dentro de 3 funciones.
Trabajo con los mismos esquemas operaciones_metadatos, encu_anterior y encu, pero se podría modificar
--Consultar con GRa:
-esquemas origen y destino. Si el esquema de extraccion existe salta error
-confirmar: en los cargar se generan los insert con los campos definidos en el esquema_destino
-operativo actual para la carga desde operativo anterior, primero hay que setearlo en operativos
-la funcion de extraccion podria contemplar descargas parciales: un formulario, bloque y el esquema de destino seria sufijado por seleccion
-se podria agregar parametros convenientes a las funciones por ejemplo el operativo_origen (anterior o viejo) y el operativo_nuevo
-se podrian incluir validaciones por ejemplo que el esquema quue se toam como origen , tenga un determinado  operativo
- se podrian agregar controles de cantidad de registros del ope_anterior y ope_nuevo en cada tabla. Si coinciden en todas las tablas, la copia estaría ok
*/
vqesquema=null;
--VER tema si hay que agregar parametros a cada funcion
IF paccion not in ('cargar_nuevo_ope_desde_viejo','extraer_ope_actual','cargar_nuevo_ope_desde_anterior') theN
    RAISE EXCEPTION 'ACCION NO CONSIDERADA';
    RETURN;
END IF;
vnombrefun=concat('operaciones.metadatos_',paccion,'_fun', '()');
vcodigo=
E'CREATE OR REPLACE FUNCTION ##nombrefun##
    RETURNS void
    LANGUAGE \'sql\'
AS \$BODY\$
-- codigo generado por operaciones.generar_metadatos_funciones()
' ;
vcodigo= replace(vcodigo,'##nombrefun##', vnombrefun);
--raise notice 'codigo: %', vcodigo;

select * into vaccion
    from operaciones.metadatos_acciones
    where accion=paccion;
--raise notice 'vaccion: %', vaccion;

if paccion='extraer_ope_actual' then
    /* cambio enfoque a extraer ope actual
    vcodigo=concat_ws(chr(10)||chr(13), vcodigo
        ,'--ATENCION! Cargar la funcion generada en la base asociada al viejo operativo'
    );
    */
    vqesquema=replace($cad$CREATE SCHEMA  ##esquema_destino##
  AUTHORIZATION tedede_php;
$cad$, '##esquema_destino##',quote_ident(vaccion.esquema_destino));  
end  if;

FOR vtablas IN 
    select *, case 
            when paccion~'extraer' then orden_descarga 
            else orden_carga end orden
        from operaciones.metadatos_tablas
        order by orden
LOOP
    vcampos='';
    vqlatabla=replace(
        replace(
            replace(
                vaccion.pattern
                ,'##esquema_origen##', quote_ident(vaccion.esquema_origen)
            ),'##esquema_destino##',quote_ident(vaccion.esquema_destino)
        )
        ,'##tabla##',quote_ident(vtablas.tabla)
    );
    --raise notice '1 tabla % %',vtablas.tabla, vqlatabla;
    IF paccion~'extraer' THEN
        SELECT string_agg(column_name, ',') filter( where column_name like '%_ope') 
          INTO  vcampo_ope
          FROM information_schema.columns 
          WHERE table_schema=vaccion.esquema_origen
            AND table_name=vtablas.tabla;
        --raise notice 'campo_ope %', vcampo_ope; 
        vqlatabla=replace(vqlatabla,'##campo_ope##', vcampo_ope);
    ELSE   
        if paccion~'carga' and (vaccion.pattern  like '%##campos##%' OR vaccion.pattern  like '%##campo_ope##%') then
            SELECT string_agg(column_name, ', ' ORDER BY ordinal_position),
                string_agg(case 
                    when column_name like '%_tlg' then '1'
                    when column_name like '%_ope' then 'dbo.ope_actual()' 
                    else column_name 
                    end, ', ' ORDER BY ordinal_position
                ), string_agg(column_name, ',') filter( where column_name like '%_ope') 
                INTO vcampos,  vcampos_valores, vcampo_ope
                FROM information_schema.columns 
                WHERE table_schema=vaccion.esquema_destino
                    AND table_name=vtablas.tabla;
            vqlatabla=replace(replace(replace(vqlatabla,'##campos##',vcampos),
                '##campos_valores##',vcampos_valores),
                '##campo_ope##', vcampo_ope);
        end if;
    END IF;
    --raise notice 'variables ope % campos %', vcampo_ope, vcampos;
    vqtablas=concat(vqtablas ,vqlatabla);
    --raise notice '2 tabla % %',vtablas.tabla, vqlatabla;
END LOOP;
vcodigo=concat_ws(chr(10)||chr(13)
        ,vcodigo, vqesquema,vqtablas
        ,E'\$BODY\$;'
        ,concat('ALTER FUNCTION ',vnombrefun)
        ,'    OWNER TO tedede_php;');
--almacenar funcion en la base
  --raise notice '%',vcodigo;
EXECUTE vcodigo;
END;  
$BODY$;
ALTER FUNCTION operaciones.generar_metadatos_funciones(paccion text)
    OWNER TO tedede_php;


--select operaciones.generar_metadatos_funciones('cargar_nuevo_ope_desde_anterior')
--select operaciones.generar_metadatos_funciones('extraer_ope_actual')
--select operaciones.generar_metadatos_funciones('cargar_nuevo_ope_desde_viejo')

------------------------------------
--Juego de datos de prueba
/*
CREATE SCHEMA IF NOT EXISTS prueba_carga_desde_anterior
    AUTHORIZATION tedede_php;
CREATE TABLE prueba_carga_desde_anterior.bloques (LIKE encu_anterior.bloques INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.con_opc (LIKE encu_anterior.con_opc INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.filtros (LIKE encu_anterior.filtros INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.formularios (LIKE encu_anterior.formularios INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.matrices (LIKE encu_anterior.matrices INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.opciones (LIKE encu_anterior.opciones INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.preguntas (LIKE encu_anterior.preguntas INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.saltos (LIKE encu_anterior.saltos INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.ua (LIKE encu_anterior.ua INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.variables (LIKE encu_anterior.variables INCLUDING ALL);
CREATE TABLE prueba_carga_desde_anterior.operativos (LIKE encu.operativos INCLUDING ALL);

CREATE SCHEMA IF NOT EXISTS prueba_carga_desde_viejo
    AUTHORIZATION tedede_php;
CREATE TABLE prueba_carga_desde_viejo.bloques (LIKE encu_anterior.bloques INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.con_opc (LIKE encu_anterior.con_opc INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.filtros (LIKE encu_anterior.filtros INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.formularios (LIKE encu_anterior.formularios INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.matrices (LIKE encu_anterior.matrices INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.opciones (LIKE encu_anterior.opciones INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.preguntas (LIKE encu_anterior.preguntas INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.saltos (LIKE encu_anterior.saltos INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.ua (LIKE encu_anterior.ua INCLUDING ALL);
CREATE TABLE prueba_carga_desde_viejo.variables (LIKE encu_anterior.variables INCLUDING ALL);

delete from operaciones.metadatos_acciones;
INSERT INTO operaciones.metadatos_acciones (accion, esquema_origen, esquema_destino, pattern) VALUES 
('cargar_nuevo_ope_desde_anterior', 'encu_anterior', 'prueba_carga_desde_anterior', 'INSERT INTO ##esquema_destino##.##tabla##(##campos##)
  SELECT ##campos_valores##
    FROM ##esquema_origen##.##tabla##
    WHERE ##campo_ope##=(SELECT ope_ope_anterior FROM ##esquema_destino##.operativos WHERE ope_ope=dbo.ope_actual());
'),
('extraer_ope_actual', 'encu', 'prueba_extraer', 'SELECT * INTO ##esquema_destino##.##tabla## 
   FROM ##esquema_origen##.##tabla## WHERE ##campo_ope##=dbo.ope_actual();
'),
('cargar_nuevo_ope_desde_viejo', 'prueba_extraer', 'prueba_carga_desde_viejo', 'INSERT INTO ##esquema_destino##.##tabla##(##campos##)
  SELECT ##campos_valores##
    FROM ##esquema_origen##.##tabla##;
');
select operaciones.generar_metadatos_funciones('extraer_ope_actual')
select operaciones.generar_metadatos_funciones('cargar_nuevo_ope_desde_anterior')
--correr luego de haber corrido extraer_ope_actual para que cree y cargue el esquema origen
select operaciones.generar_metadatos_funciones('cargar_nuevo_ope_desde_viejo')
*/
