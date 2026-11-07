# 8. Actividad 2 — Que el servidor administre su propia bitácora

## Preguntas

### **1. ¿Por qué logging_collector requiere reinicio y log_statement solo recarga?**

Porque ambos parámetros afectan diferentes componentes del funcionamiento de PostgreSQL.
- logging_collector requiere reiniciar el servidor porque controla el inicio de un proceso interno encargado de recibir, administrar y escribir los mensajes de registro en archivos. PostgreSQL necesita iniciar ese proceso desde el arranque.
- log_statement puede modificarse mediante una recarga de configuración porque únicamente determina qué tipos de sentencias SQL deben registrarse. No requiere iniciar un proceso adicional.
En otras palabras, logging_collector modifica la infraestructura de registro del servidor, mientras que log_statement modifica una regla de configuración que puede actualizarse sin detenerlo.

### **2. ¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?**

- **Ventaja:**

Permite consultar, filtrar y analizar los registros directamente desde PostgreSQL utilizando sentencias SQL, sin necesidad de acceder al sistema de archivos del servidor o del contenedor.

Por ejemplo, mediante la vista dba.bitacora se pueden buscar errores, identificar eventos específicos y ordenar las líneas cronológicamente.

Esto facilita el análisis desde pgAdmin y permite centralizar ciertas tareas de administración dentro del propio motor de base de datos.

- **Riesgo:**

La lectura mediante SQL requiere otorgar permisos para consultar el archivo de bitácora. Si estos permisos se conceden incorrectamente, usuarios sin autorización podrían acceder a información sensible, como nombres de usuarios, direcciones IP, consultas ejecutadas o datos que hayan quedado registrados en los mensajes de error.

Además, pg_read_file() permite leer archivos del servidor bajo las restricciones de permisos de PostgreSQL, por lo que debe manejarse con especial cuidado.

### **3. ¿Quién debería poder consultar dba.bitacora?**

Deberían poder consultarla exclusivamente los administradores de bases de datos y el personal de seguridad que tenga autorización para realizar auditorías o investigar incidentes.

No debería estar disponible para usuarios comunes ni para todos los roles de la base de datos, porque los registros pueden contener información confidencial sobre las conexiones, operaciones y errores del sistema.

La restricción es especialmente importante porque la vista permite consultar información que podría utilizarse para identificar usuarios, conocer operaciones realizadas o detectar vulnerabilidades.
