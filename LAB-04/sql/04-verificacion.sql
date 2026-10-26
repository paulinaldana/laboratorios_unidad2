-- **** Comprobar el estado final ****
SELECT
    current_database() AS base_datos,
    current_user AS usuario_actual,
    version() AS version_postgresql;

SELECT name, setting, source, pending_restart
FROM pg_settings
WHERE name IN (
    'listen_addresses',
    'port',
    'password_encryption',
    'ssl',
    'max_connections',
    'log_connections',
    'log_disconnections'
)
ORDER BY name;