-- CONFIGURACIÓN

-- **** 1. Revisar la configuración actual ****

-- 1. Versión de PostgreSQL
SELECT version();

-- 2. Parámetros importantes de seguridad
SELECT name, setting, unit, source, pending_restart
FROM pg_settings
WHERE name IN (
    'listen_addresses',
    'port',
    'password_encryption',
    'ssl',
    'max_connections',
    'log_connections',
    'log_disconnections',
    'logging_collector',
    'data_directory',
    'hba_file',
    'config_file'
)
ORDER BY name;

-- 3. Reglas de acceso configuradas en pg_hba.conf
SELECT *
FROM pg_hba_file_rules;

-- 4. Usuarios y roles existentes
SELECT
    rolname,
    rolsuper,
    rolcreatedb,
    rolcreaterole,
    rolcanlogin,
    rolreplication
FROM pg_roles
ORDER BY rolname;

-- 5. Conexiones activas
SELECT
    usename,
    datname,
    client_addr,
    application_name,
    state
FROM pg_stat_activity
ORDER BY datname, usename;

-- 6. Extensiones instaladas en la base de datos actual
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;

-- 7. Permisos de las tablas
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
ORDER BY grantee, table_schema, table_name;


-- **** 2. Crear roles con privilegios limitados ****

-- 1. Rol que agrupa permisos de lectura
CREATE ROLE rol_lectura NOLOGIN;


-- **** 3. Mejorar la autenticación y los registros ****

-- 1. SCRAM como método predeterminado para las contraseñas nuevas:
ALTER SYSTEM SET password_encryption = 'scram-sha-256';

SELECT pg_reload_conf();

-- 2. Habilitar el registro de conexiones y desconexiones:
ALTER SYSTEM SET log_connections = 'on';
ALTER SYSTEM SET log_disconnections = 'on';

SELECT pg_reload_conf();

-- 3. Para consultar qué configuración está activa:
SELECT name, setting, source, pending_restart
FROM pg_settings
WHERE name IN (
    'password_encryption',
    'log_connections',
    'log_disconnections'
)
ORDER BY name;

-- **** 4. Revisar la configuración de red ****

-- 1. Estas consultas permiten comprobar el puerto y las interfaces configuradas:
SHOW listen_addresses;
SHOW port;

-- 2. Revisar los parámetros de red
SELECT name, setting, pending_restart
FROM pg_settings
WHERE name IN ('listen_addresses', 'port')
ORDER BY name;

-- 3. Para revisar las reglas de autenticación:
SELECT
    line_number,
    type,
    database,
    user_name,
    address,
    auth_method,
    error
FROM pg_hba_file_rules
ORDER BY line_number;


-- **** 5. Revisar TLS y conexiones ****
-- Estado de TLS
SHOW ssl;

-- Conexiones actuales y si utilizan cifrado TLS
SELECT
    a.usename,
    a.datname,
    a.client_addr,
    s.ssl,
    s.version AS tls_version,
    s.cipher
FROM pg_stat_activity AS a
LEFT JOIN pg_stat_ssl AS s
    ON a.pid = s.pid
ORDER BY a.usename, a.datname;

-- Cantidad de conexiones por base de datos y estado
SELECT
    datname,
    state,
    COUNT(*) AS cantidad
FROM pg_stat_activity
GROUP BY datname, state
ORDER BY datname, state;


-- **** 6. Revisar permisos y protección de datos ****
-- Identificar roles con privilegios elevados
SELECT
    rolname,
    rolsuper,
    rolcreatedb,
    rolcreaterole,
    rolreplication
FROM pg_roles
WHERE rolsuper
   OR rolcreatedb
   OR rolcreaterole
   OR rolreplication
ORDER BY rolname;

-- Revisar permisos sobre esquemas
SELECT
    grantee,
    schema_name,
    privilege_type
FROM information_schema.schema_privileges
ORDER BY grantee, schema_name, privilege_type;

-- Revisar los privilegios predeterminados configurados
SELECT
    defaclrole::regrole AS propietario,
    defaclnamespace::regnamespace AS esquema,
    defaclobjtype AS tipo_objeto,
    defaclacl AS privilegios
FROM pg_default_acl;

SELECT
    n.nspname AS esquema,
    r.rolname AS rol,
    has_schema_privilege(r.rolname, n.oid, 'USAGE') AS puede_usar,
    has_schema_privilege(r.rolname, n.oid, 'CREATE') AS puede_crear
FROM pg_namespace AS n
CROSS JOIN pg_roles AS r
WHERE n.nspname NOT IN ('information_schema')
  AND n.nspname NOT LIKE 'pg_%'
ORDER BY n.nspname, r.rolname;

-- **** 7. Revisar extensiones instaladas ****
SELECT
    e.extname AS extension,
    e.extversion AS version,
    n.nspname AS esquema
FROM pg_extension AS e
JOIN pg_namespace AS n
    ON e.extnamespace = n.oid
ORDER BY e.extname;
