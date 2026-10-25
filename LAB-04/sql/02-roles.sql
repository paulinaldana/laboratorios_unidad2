SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- Pregunta
-- ¿Por qué no debería utilizarse una cuenta SUPERUSER como cuenta normal de una aplicación?
-- Porque se estaría omitiendo el principio del privilegio mínimo, por ende un usuario
-- "promedio" tendría acceso más grande del requerido y errores podrían pasar.