SELECT version();

SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- Obtén también información sobre las conexiones:
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;

-- Consulta:
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
-- /etc/postgresql/postgresql.conf
-- /var/lib/postgresql/data/pg_hba.conf
-- /var/lib/postgresql/data/pg_ident.conf

-- Identifica otros parámetros importantes:
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

-- Consulta:
SHOW listen_addresses;

-- Consulta las reglas configuradas:
SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;

-- Consulta:
SHOW password_encryption;
