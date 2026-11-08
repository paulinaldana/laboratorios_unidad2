REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

-- 12.1 La bitácora también puede filtrar secretos
-- Crea un rol desechable escribiendo la contraseña en la sentencia, y elimínalo:

CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';
DROP ROLE rol_temporal;

-- Consulta las sentencias registradas:

SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;

-- Resultado:
-- "2026-11-08 19:02:00.518 UTC [342] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8054128 client=172.18.0.3 LOG:  statement: ALTER SYSTEM SET log_connections = on;"
-- "2026-11-08 19:39:56.105 UTC [511] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8718351 client=172.18.0.3 LOG:  statement: REVOKE UPDATE ON clientes FROM soporte_ana;"
-- "2026-11-08 19:39:58.803 UTC [511] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8718351 client=172.18.0.3 LOG:  statement: GRANT UPDATE ON clientes TO app_ventas;"
-- "2026-11-08 19:40:02.331 UTC [511] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8718351 client=172.18.0.3 LOG:  statement: ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);"
-- "2026-11-08 19:41:01.341 UTC [511] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8718351 client=172.18.0.3 LOG:  statement: CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';"
-- "2026-11-08 19:41:04.489 UTC [511] user=u_16540549_paulina_aldana db=academia app=pgAdmin 4 - CONN:8718351 client=172.18.0.3 LOG:  statement: DROP ROLE rol_temporal;"