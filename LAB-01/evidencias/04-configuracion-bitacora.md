# 10. Actividad 4 — Configurar la bitácora

## Preguntas

### **1. ¿Por qué el proceso que registra el cambio es el principal y no tu sesión?**

Porque ALTER SYSTEM modifica la configuración persistente de PostgreSQL y pg_reload_conf() solicita al servidor que vuelva a cargarla.

El proceso principal de PostgreSQL (PID 1 en tu contenedor) recibe la señal de recarga, procesa los cambios de configuración y registra los mensajes correspondientes en la bitácora.

Por eso, aunque el cambio fue solicitado desde tu sesión de administrador, quien registra su aplicación es el proceso principal del servidor.

### **2. ¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'? ¿Quedaría rastro?**

Dependería de la configuración de registro que estuviera activa en ese momento.

Si log_statement todavía estuviera configurado en ddl, la sentencia ALTER SYSTEM podría quedar registrada porque es una operación de definición o modificación de configuración.

Sin embargo, una vez aplicada la configuración none, las siguientes sentencias SQL dejarían de registrarse de manera general.

Esto representa un riesgo de seguridad: alguien con privilegios suficientes podría reducir la capacidad de auditoría del servidor y dificultar la investigación de actividades posteriores.

Importante: el cambio de configuración todavía podría dejar un mensaje de registro del proceso principal, pero eso no garantiza que se conserve evidencia completa de las operaciones posteriores.

### **3. ¿Por qué no se recomienda editar postgresql.auto.conf a mano?**

Porque postgresql.auto.conf es un archivo que PostgreSQL administra automáticamente mediante instrucciones como ALTER SYSTEM.

Modificarlo manualmente puede provocar errores de sintaxis, inconsistencias o conflictos con los cambios realizados desde el propio motor.

Además, utilizar ALTER SYSTEM permite que PostgreSQL gestione los parámetros de configuración de manera controlada y persistente, reduciendo el riesgo de modificar incorrectamente el archivo.

Por ello, se recomienda utilizar las instrucciones SQL correspondientes para cambiar los parámetros y dejar que PostgreSQL administre el archivo.

## Conclusión

La actividad demuestra que PostgreSQL cuenta con mecanismos para registrar los cambios en su configuración y las operaciones realizadas por sus usuarios. Sin embargo, también evidencia que la propia configuración de auditoría puede modificarse, lo que representa un riesgo si no existen controles adecuados. Por esta razón, los cambios en los parámetros de registro deben estar restringidos a administradores autorizados, y los archivos de bitácora deben protegerse para evitar su alteración o eliminación.