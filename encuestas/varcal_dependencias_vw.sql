--generado usando IA 
-- hay varcals que no aparecen en la vista porque se construyen por una funcion ( nadeq, tot_mi, sexoj, etc)
--posibles mejoras
    --poner en tabla las funciones utilizadas y reemplazar la busqueda con left join

--DROP VIEW IF EXISTS encu.varcal_dependencias_vw;
CREATE OR REPLACE VIEW encu.varcal_dependencias_vw
 AS
 WITH fuente AS (
         -- Saco los literales entre comillas simples ('activo', 'texto', etc.)
         -- antes de tokenizar, para que no se cuelen como si fueran variables.
         SELECT
            f.varcalopc_ope AS ope,
            f.varcalopc_varcal AS variable,
            regexp_replace(
                concat_ws(' '::text, f.varcalopc_expresion_valor, f.varcalopc_expresion_condicion),
                '''[^'']*'''::text, ' '::text, 'g'::text
            ) AS expresion
           FROM encu.varcalopc f
        ), extraidas AS (
         SELECT DISTINCT
            fuente.ope,
            fuente.variable,
            TRIM(BOTH FROM regexp_split_to_table(fuente.expresion, '[\s+\-*/()%,;<>!=^]+'::text)) AS dependencia
           FROM fuente
        ), filtradas AS (
         SELECT
            extraidas.ope,
            lower(extraidas.variable::text) AS varcal,
            lower(extraidas.dependencia) AS dependencia
           FROM extraidas
          WHERE lower(extraidas.dependencia) !~ '^(or|and|is|end|in|not|then|like|between|exists|as|any|all|some|true|false|null|case|when|else|distinct|from|@)$'::text
            AND extraidas.dependencia <> ''::text
            AND extraidas.dependencia !~ '^\d+(\.\d+)?$'::text
            AND lower(extraidas.dependencia) !~ '^(enc|hog|mie|nmiembro|encues|nhogar|p_mie)$'::text
            --AND lower(extraidas.dependencia) !~ '^(comuna|dominio|semana)$'::text
            AND lower(extraidas.dependencia) !~ '^\$\$(pais|provincia|partido|barrio|anio|mes)\$\$$'::text
            AND lower(extraidas.dependencia) !~ '^(coalesce|mod|round|trunc|nullif|max|min|greatest|least|floor|ceil|date_part|age|concat|concat_ws)$'::text
            AND lower(extraidas.dependencia) !~ '^(blanco|informado|nsnc|ignorado|enrango|a_texto|boolint|completar_fecha|concato_ad|digitos|es_numero|negado|nulo_a_neutro|rango|fechadma)$'::text
            AND lower(extraidas.dependencia) !~ '^(dbo.)*(anio|anionac|cant_i1_x_hog|dic_parte|dic_tradu|edadjefe|edad_a_la_fecha|estadojefe|fecha_30junio|form_familiar|mie_bu|parte_fecha_dma|obt_valor_hog|obtener_valor_mie_asoc|sexojefe|suma_adulteq|suma_coef_trans_c|suma_coef_trans_p|texto_a_fecha)$'::text
        ), limpia_pesos AS (
         SELECT
            filtradas.ope,
            filtradas.varcal,
                CASE
                    WHEN filtradas.dependencia ~ '\$\$'::text THEN replace(filtradas.dependencia, '$$'::text, ''::text)
                    ELSE filtradas.dependencia
                END AS dependencia
           FROM filtradas
          WHERE COALESCE(TRIM(BOTH FROM filtradas.dependencia), ''::text) <> ''::text
        ), extraer_dbx AS (
         SELECT
            limpia_pesos.ope,
            limpia_pesos.varcal,
            regexp_split_to_table(limpia_pesos.dependencia, '@'::text) AS dependencia
           FROM limpia_pesos
        ), filtrar_func_dbx AS (
         SELECT DISTINCT
            extraer_dbx.ope,
            extraer_dbx.varcal,
            extraer_dbx.dependencia
           FROM extraer_dbx
          WHERE extraer_dbx.dependencia !~ '^(sumap|contarc|sumapd|contarc_per|maxip|minip|relacionmax|relacionmin|relacioncontar)$'::text
            AND COALESCE(extraer_dbx.dependencia, ''::text) <> ''::text
            AND extraer_dbx.dependencia <> extraer_dbx.varcal  -- saco auto-referencias (variable "dependiendo" de si misma)
        ), agregar_dataorig AS (
         SELECT DISTINCT
            v.ope,
            v.varcal,
            v.dependencia AS origen,
            CASE WHEN v.dependencia~* '^(comuna|dominio|semana)$'::text  THEN 'TEM' ELSE d.ori_tipo END ori_tipo,
            d.ori_destino,
            d.ori_activa,
			d.ori_orden,
			d.ori_grupo
           FROM filtrar_func_dbx v
             LEFT JOIN ( SELECT
                    varcal.varcal_ope AS ope,
                    varcal.varcal_varcal AS dependencia,
                        CASE varcal.varcal_tipo
                            WHEN 'normal'::text THEN 'calculada'::character varying
                            ELSE varcal.varcal_tipo
                        END AS ori_tipo,
                    varcal.varcal_destino AS ori_destino,
                    varcal.varcal_activa AS ori_activa,
					varcal.varcal_orden AS ori_orden,
					varcal.varcal_grupo AS ori_grupo
                   FROM encu.varcal

                UNION

                 SELECT
                    variables.var_ope AS ope,
                    variables.var_var AS dependencia,
                        CASE
                            WHEN variables.var_for::text = 'TEM'::text THEN variables.var_for
                            ELSE 'cuestionario'::character varying
                        END AS ori_tipo,
                    NULL::character varying AS ori_destino,
                    true AS ori_activa,
					null ari_orden,
					null ori_grupo
                   FROM encu.variables) d
               ON v.ope = d.ope AND v.dependencia = d.dependencia::text
        )
 SELECT
    ope,
    varcal,
    origen,
    ori_tipo,
    ori_destino,
    ori_activa,
	ori_orden,
	ori_grupo
   FROM agregar_dataorig
  ORDER BY ope, varcal, ori_tipo, ori_destino, origen;
/*otra*/
ALTER TABLE encu.varcal_dependencias_vw
    OWNER TO tedede_php;
