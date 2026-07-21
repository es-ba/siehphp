--generado con ayuda de IA
-- =====================================================================
-- 1) Materializar varcal_dependencias_vw, con es_hoja precalculado
--    (el WITH ... AS MATERIALIZED fuerza a que "base" se calcule
--     UNA sola vez, aunque se referencie dos veces abajo)
-- =====================================================================
DROP MATERIALIZED VIEW IF EXISTS encu.varcal_dependencias_mv;

CREATE MATERIALIZED VIEW encu.varcal_dependencias_mv AS
 WITH base AS MATERIALIZED (
        SELECT ope, varcal, origen, ori_tipo, ori_destino, ori_activa
            , ori_orden, ori.grupo
          FROM encu.varcal_dependencias_vw
       )
 SELECT
    b.ope,
    b.varcal,
    b.origen,
    b.ori_tipo,
    b.ori_destino,
    b.ori_activa,
    NOT EXISTS (
        SELECT 1 FROM base h
         WHERE h.ope = b.ope AND h.varcal = b.origen
    ) AS es_hoja,
    b.ori_orden,
    b.ori.grupo

   FROM base b;

-- Necesario para poder hacer REFRESH ... CONCURRENTLY (no bloquea lecturas)
CREATE UNIQUE INDEX ix_mv_dependencias_pk
    ON encu.varcal_dependencias_mv
 (ope, varcal, origen);

-- Soporta el JOIN recursivo (d.varcal = a.dependencia) y el chequeo de hoja
CREATE INDEX ix_mv_dependencias_varcal
    ON encu.varcal_dependencias_mv
 (ope, varcal);

ALTER TABLE IF EXISTS encu.varcal_dependencias_mv
    OWNER TO tedede_php;
-- =====================================================================
-- 2) Reescribir el árbol para que use la tabla materializada
--    en vez de la vista pesada, y el es_hoja ya calculado
--    (nada de NOT EXISTS por fila acá)
-- =====================================================================
CREATE OR REPLACE VIEW encu.varcal_arbol_construccion_vw
 AS
 WITH RECURSIVE arbol AS (

         SELECT
            d.ope,
            d.varcal AS variable_raiz,
            1 AS nivel,
            d.varcal AS variable,
            d.origen AS dependencia,
            d.ori_tipo,
            d.es_hoja,
            false AS ciclo_detectado,
            ARRAY[d.varcal] AS camino,
            d.ori_activa,
            d.ori_orden,
            d.ori_grupo

           FROM encu.varcal_dependencias_mv
         d

        UNION ALL

         SELECT
            d.ope,
            a.variable_raiz,
            a.nivel + 1,
            d.varcal,
            d.origen,
            d.ori_tipo,
            d.es_hoja,
            d.varcal = ANY(a.camino) AS ciclo_detectado,
            a.camino || d.varcal AS camino,
            d.ori_activa,
            d.ori_orden,
            d.ori_grupo
           FROM arbol a
           JOIN encu.varcal_dependencias_mv
         d
             ON d.ope = a.ope AND d.varcal = a.dependencia
          WHERE NOT a.es_hoja
            AND NOT a.ciclo_detectado

        )
 SELECT
    ope,
    variable_raiz,
    nivel,
    variable,
    dependencia,
    ori_tipo,
    es_hoja,
    ciclo_detectado,
    camino,
    ori_activa,
    ori_orden,
    ori_grupo
   FROM arbol
  ORDER BY ope, variable_raiz, nivel, variable, dependencia;


-- =====================================================================
-- 3) Refrescar la materializada cada vez que cambien varcal / varcalopc
--    (manual o desde un job programado; CONCURRENTLY evita bloquear
--     lecturas mientras se refresca)
-- =====================================================================
-- REFRESH MATERIALIZED VIEW CONCURRENTLY encu.varcal_dependencias_mv;

ALTER TABLE encu.varcal_arbol_construccion_vw
    OWNER TO tedede_php;