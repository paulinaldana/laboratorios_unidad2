# Actividad 1 — Revisar la configuración de registro por defecto

## Preguntas

### **1. ¿Con esta configuración se registra quién se conecta?**
No. El parámetro log_connections está en off, por lo que PostgreSQL no registra los eventos de conexión de los clientes mediante esta opción.

Además, log_disconnections también está en off, por lo que tampoco registra los eventos de desconexión.

### **2. ¿Se registran las sentencias UPDATE?**
No. El parámetro log_statement está configurado en none, lo que significa que PostgreSQL no registra las sentencias SQL por su tipo de operación.

Por lo tanto, las sentencias UPDATE no se registran de manera general. Sin embargo, si una sentencia produce un error, puede registrarse debido a que log_min_error_statement está configurado en error.

### **3. ¿La línea de bitácora incluye el usuario o la dirección IP del cliente?**
No. El parámetro log_line_prefix tiene el valor %m [%p].

Esto significa que cada línea de bitácora incluye:
- %m: fecha y hora del evento, con milisegundos.
- %p: identificador del proceso (PID) de PostgreSQL.
No incluye el nombre del usuario ni la dirección IP del cliente. Para incluirlos se podrían utilizar los identificadores %u (usuario) y %h (host o dirección IP).

### **4. ¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?**
Los eventos se registran utilizando la zona horaria Etc/UTC, según el parámetro log_timezone.

Esto es importante porque permite establecer una referencia horaria uniforme para analizar los eventos y relacionarlos con otras bitácoras o sistemas. Si se utilizan diferentes zonas horarias sin considerar sus diferencias, se pueden interpretar incorrectamente el orden y el momento en que ocurrieron los incidentes.

### **5. Con logging_collector = off, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?**
Principalmente, el mecanismo con que se desplegó y ejecutó PostgreSQL.

Con logging_collector = off, PostgreSQL no utiliza su propio colector para administrar los archivos de bitácora. En su lugar, envía los mensajes de registro a stderr (salida estándar de errores).

Por ello, el destino final depende del entorno de ejecución. Por ejemplo, si PostgreSQL se ejecuta en Docker, los mensajes pueden ser capturados por el sistema de registros del contenedor y consultarse mediante docker logs.