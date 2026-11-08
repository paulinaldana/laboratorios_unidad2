CREATE OR REPLACE FUNCTION auditoria.registrar_cambio_cliente()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria.cambios_clientes (operacion, id_cliente, valores_despues)
        VALUES (TG_OP, NEW.id, to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria.cambios_clientes (operacion, id_cliente, valores_antes, valores_despues)
        VALUES (TG_OP, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria.cambios_clientes (operacion, id_cliente, valores_antes)
        VALUES (TG_OP, OLD.id, to_jsonb(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;

REVOKE ALL ON FUNCTION auditoria.registrar_cambio_cliente() FROM PUBLIC;

CREATE TRIGGER trg_auditoria_clientes
AFTER INSERT OR UPDATE OR DELETE ON clientes
FOR EACH ROW EXECUTE FUNCTION auditoria.registrar_cambio_cliente();

-- Verifica: 
SELECT tgname, tgenabled, tgrelid::regclass FROM pg_trigger WHERE NOT tgisinternal;

-- "trg_auditoria_clientes"	"O"	"clientes"

-- O indica que el disparador está habilitado.

-- Preguntas

-- 1. ¿Por qué se ejecuta REVOKE ALL ON FUNCTION ... FROM PUBLIC si el disparador seguirá funcionando para app_ventas?

-- Porque se busca evitar que cualquier usuario pueda ejecutar directamente la función de auditoría.
-- Al utilizar REVOKE ALL ON FUNCTION ... FROM PUBLIC, se retiran los permisos que PostgreSQL concede por defecto a todos los usuarios sobre esa función.
-- Sin embargo, esto no impide que el disparador se ejecute cuando app_ventas realiza un INSERT, UPDATE o DELETE sobre clientes.
-- La diferencia es que el disparador invoca la función como parte de la operación sobre la tabla, mientras que el usuario no necesita tener permiso para ejecutarla directamente.

-- 2. ¿Qué pasaría si la función no fuera SECURITY DEFINER? Formula una hipótesis antes de la Actividad 12.

-- Si la función no tuviera SECURITY DEFINER, se ejecutaría con los privilegios del usuario que realiza la operación, es decir, con los de app_ventas.
-- Mi hipótesis es que, si app_ventas no tiene permisos para insertar registros en auditoria.cambios_clientes, el disparador generaría un error al intentar guardar la auditoría.
-- Como consecuencia, la modificación original en clientes también fallaría, ya que el disparador se ejecuta como parte de la misma operación.
-- SECURITY DEFINER permite que la función se ejecute con los privilegios de su propietario, quien debe tener los permisos necesarios para insertar en la tabla de auditoría.

-- 3. Consulta dba.bitacora. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?

-- Sí, deberían quedar registradas las cuatro operaciones, siempre que se hayan ejecutado con log_statement = 'ddl' o log_statement = 'all' y la configuración estuviera activa en ese momento.
-- Esto se debe a que las siguientes instrucciones corresponden a operaciones de definición de datos (DDL):
-- - CREATE SCHEMA: creación del esquema.
-- - CREATE TABLE: creación de la tabla.
-- - CREATE OR REPLACE FUNCTION: creación o modificación de la función.
-- - CREATE TRIGGER: creación del disparador.
-- Además, REVOKE ALL es una operación de modificación de privilegios que también puede quedar registrada.