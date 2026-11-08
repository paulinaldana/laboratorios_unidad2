# 15. Actividad 9 — Sesiones activas con pg_stat_activity

## Preguntas 

### 1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

La columna pid de pg_stat_activity.

El PID (Process ID) identifica el proceso de PostgreSQL que atiende una sesión. En la bitácora también aparece ese identificador entre corchetes, por ejemplo, [769].

Así podemos relacionar la información de una sesión activa con sus registros correspondientes en la bitácora, siempre que el PID coincida.

### 2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

pg_stat_activity muestra información de las sesiones que están activas en ese momento. Cuando el reporte termina, su sesión desaparece de esa vista.

En cambio, la bitácora puede conservar evidencia de su conexión y desconexión, gracias a log_connections y log_disconnections.

Hay una precisión importante: como log_statement = 'mod' no registra consultas SELECT, no necesariamente quedará guardado el texto de SELECT pg_sleep(90). La bitácora puede demostrar que existió una sesión, pero no necesariamente qué consulta ejecutó.

### 3. ¿Por qué client_addr aparece vacío en la sesión del administrador?

Porque PostgreSQL muestra client_addr como NULL cuando la conexión se realiza mediante un socket local de Unix, en lugar de una conexión TCP/IP.

Sin embargo, hay que considerar tu configuración: anteriormente observamos que pgAdmin se conectaba desde 172.18.0.3. Si estás consultando desde esa misma conexión de pgAdmin, esperaríamos ver esa dirección y no un valor vacío.

Por tanto, no debemos asumir que es normal sin comprobar desde dónde se estableció la conexión.

## Conclusión

`pg_stat_activity` permite observar sesiones en tiempo real, mientras que la bitácora conserva determinados registros históricos. Ambas fuentes se complementan, pero ninguna por sí sola garantiza una auditoría completa de todas las operaciones.