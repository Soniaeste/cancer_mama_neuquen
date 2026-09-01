-- ============================================================
-- Proyecto: Cáncer de mama - Neuquén
-- Script: 06_TME_por_AP.sql
-- Objetivo: estudiar la persistencia de la TME por AP
-- ============================================================

SELECT
    ZS,
    AP,
    COUNT(*) AS años_observados,
    ROUND(AVG(TME), 3) AS tme_media,
    ROUND(MIN(TME), 3) AS tme_minima,
    ROUND(MAX(TME), 3) AS tme_maxima,

    SUM(
        CASE
            WHEN TME = 0 THEN 1
            ELSE 0
        END
    ) AS años_con_cero,

    SUM(
        CASE
            WHEN TME > 0 THEN 1
            ELSE 0
        END
    ) AS años_con_tme_positiva

FROM base_cancer
GROUP BY
    ZS,
    AP
ORDER BY
    tme_media DESC;
    
