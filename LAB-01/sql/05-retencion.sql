-- 14. Actividad 7 — Retención de datos
--La organización debe definir qué información conserva y durante cuánto tiempo.
--Primero identificar los registros que hipotéticamente superan el periodo de conservación establecido.

-- Para este ejercicio se utilizará un periodo de cinco años:
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';

