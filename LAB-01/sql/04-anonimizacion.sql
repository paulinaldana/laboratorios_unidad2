-- 12. Actividad 5 — Anonimización (anonymization)
-- 12.1 Generalizar la edad
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 12.2 Generalizar la región
SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

-- 12.3 Combinar atributos
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2;

-- 12.4 Suprimir grupos pequeños
-- Como ejercicio didáctico se utilizará un umbral de cinco registros:
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2

HAVING COUNT(*) >= 5;

-- Reto:
-- Modificar la consulta anterior para reducir aún más el riesgo de reidentificación.

-- Cambio realizado: 1. Ampliar rango de edad, 2. Código postal genera ubicación más general
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 35 THEN '18-35'
        WHEN edad BETWEEN 36 AND 55 THEN '36-55'
        WHEN edad >= 56 THEN '56+'
        ELSE 'No especificada'
    END AS rango_edad,

    LEFT(codigo_postal, 1) AS region_general,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2

HAVING COUNT(*) >= 5;