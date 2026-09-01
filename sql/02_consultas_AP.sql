-- ============================================================
-- Proyecto: Cáncer de mama - Neuquén
-- Script: 02_consultas_AP.sql
-- Objetivo: consultas por Área Programática
-- ============================================================

SELECT
    b.ZS,
    b.AP,
    ROUND(AVG(b.TME), 3) AS tme_promedio,
    e.n AS establecimientos
FROM base_cancer AS b
LEFT JOIN establecimientos_por_ap AS e
    ON b.AP = e.AP
GROUP BY
    b.ZS,
    b.AP,
    e.n
ORDER BY
    b.ZS,
    tme_promedio DESC;
    

