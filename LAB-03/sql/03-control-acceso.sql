-- 9. Actividad 3 — Separación por finalidad
-- Diseña una consulta que proporcione información agregada:
SELECT
    ciudad,
    COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

-- Ahora crea rangos de edad:
SELECT
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    COUNT(*) AS cantidad
FROM clientes
GROUP BY
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END
ORDER BY rango_edad;

-- Pregunta
-- ¿Por qué esta información puede ser más apropiada para analítica que entregar directamente
-- la tabla completa de clientes?
-- Porque así pueden observar los datos de forma que sea posible su análisis pero 1. se ahorra
-- el paso de ellos hacer conjuntos y cálculos apatir de ellos y 2. disminuimos el riesgo de
-- fugas de datos o mal uso de ellos al ejecutar una separación por la finalidad que tiene dicho departamento.