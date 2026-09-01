-- ============================================================
-- Proyecto: Cáncer de mama - Neuquén
-- Script: 05_TME_extremos.sql
-- Objetivo: identificar los valores más altos de TME
-- ============================================================

SELECT
    Año,
    ZS,
    AP,
    ROUND(TME, 3) AS TME
FROM base_cancer
ORDER BY TME DESC
LIMIT 20;

