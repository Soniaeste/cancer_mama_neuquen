-- ============================================================
-- Proyecto: Cáncer de mama - Neuquén
-- Script: 04_TME_por_anio.sql
-- Objetivo: explorar la TME por año
-- ============================================================

SELECT
    Año,
    COUNT(*) AS n,
    ROUND(MIN(TME), 3) AS minimo,
    ROUND(AVG(TME), 3) AS media,
    ROUND(MAX(TME), 3) AS maximo,
    SUM(
        CASE
            WHEN TME = 0 THEN 1
            ELSE 0
        END
    ) AS cantidad_ceros,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN TME = 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS porcentaje_ceros
FROM base_cancer
GROUP BY Año
ORDER BY Año;

