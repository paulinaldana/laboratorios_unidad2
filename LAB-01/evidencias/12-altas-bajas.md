# 19. Actividad 13 — Altas y bajas

## Preguntas

### 1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?

La evidencia permanece en la tabla auditoria.cambios_clientes, porque el disparador registró tanto su inserción como su eliminación.

En el evento INSERT (id_evento 1) se conserva el registro completo en valores_despues, incluyendo su nombre, correo, RFC, edad, ciudad y código postal.

En el evento DELETE (id_evento 2) se conserva el registro completo en valores_antes, es decir, la información que tenía Pedro Ruiz justo antes de ser eliminado.

Esto demuestra que eliminar un registro de la tabla principal no elimina automáticamente su evidencia histórica de auditoría.

### 2. ¿Por qué ip_cliente está vacía en los eventos 2 y 3?

La dirección obtenida en mi práctica corresponde a la conexión de pgAdmin desde el contenedor hacia PostgreSQL.

Si en algún otro evento aparece vacía (NULL), puede deberse a que la conexión se realizó mediante un socket local, sin una dirección IP asociada.

Por lo tanto, para la ejecución en mi práctica, sí se registró la dirección IP del cliente.

**Para el caso didáctico de este laboratorio:** la dirección IP no se registra porque la conexión del administrador probablemente se realizó mediante un socket Unix local, que permite la comunicación entre procesos del mismo equipo sin utilizar el protocolo TCP/IP. 

Como no existe una dirección IP asociada a esa conexión, la función inet_client_addr() devuelve NULL. Esto demuestra que no todas las conexiones a PostgreSQL tienen necesariamente una dirección IP identificable.

### 3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?

Aparece un conflicto entre dos necesidades:
- **Protección de datos y privacidad:** eliminar información personal cuando ya no sea necesaria para su finalidad.
- **Auditoría y seguridad:** conservar evidencia histórica para investigar modificaciones, eliminaciones y posibles incidentes.

En este ejercicio, aunque Pedro Ruiz fue eliminado de clientes, sus datos personales siguen almacenados en la tabla de auditoría. Esto significa que eliminar un registro de la tabla principal no equivale a eliminar toda la información personal relacionada con él.

La resolución corresponde a la organización responsable del tratamiento de los datos, con participación de las áreas de seguridad informática, administración de bases de datos y protección de datos personales.

Deben establecer una política que defina qué información se conserva, durante cuánto tiempo, con qué finalidad, quién puede consultarla y cuándo debe eliminarse o anonimizarse.

## Conclusión

La auditoría no debe convertirse en un mecanismo para conservar indefinidamente información personal. La trazabilidad y la protección de datos deben equilibrarse mediante políticas claras de acceso, conservación y eliminación.