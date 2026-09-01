SELECT
    COUNT(*) AS n,
    ROUND(MIN(TME), 3) AS minimo,
    ROUND(AVG(TME), 3) AS media,
    ROUND(MAX(TME), 3) AS maximo,
    SUM(CASE WHEN TME = 0 THEN 1 ELSE 0 END) AS cantidad_ceros
FROM base_cancer;
