-- ============================================================
-- Proyecto: Cáncer de mama - Neuquén
-- Script: 01_exploracion.sql
-- Objetivo: exploración inicial de la base
-- ============================================================


-- ------------------------------------------------------------
-- 1. Primeros registros
-- ------------------------------------------------------------

SELECT
    ZS,
    COUNT(DISTINCT AP) AS cantidad_ap
FROM base_cancer
GROUP BY ZS
ORDER BY ZS;
