# 23. Actividad 17 — Reconstruir la cronología y responder a Dirección

## Cronología de eventos

#	|Fecha y hora (UTC)|	Usuario	|Cliente|	Tipo de evento	|Qué ocurrió	|¿Exitoso?|	Fuente
| --- | --- | --- | --- | --- | --- | --- | --- |
1|	19:01:23|	No identificado|	No identificado|	Configuración|	Se activaron los registros de conexiones y desconexiones, se modificó el prefijo de bitácora y se configuró log_statement = ddl.	|Sí, parámetros aplicados|	Líneas 1–4|
2|	19:28:00|	app_ventas|	127.0.0.1|	Acceso|	Intento de conexión a comercial con contraseña incorrecta.	|No|	Líneas 16–18|
3|	19:39:56|	u_16540549_paulina_aldana|	172.18.0.3|	Privilegio|	Se revocó UPDATE a soporte_ana y se concedió UPDATE a app_ventas sobre clientes.|	Sin error registrado|	Líneas 35–36|
4|	19:40:02|	u_16540549_paulina_aldana|	172.18.0.3|	Estructura|	Se agregó la columna segmento a la tabla clientes.|	Sin error registrado|	Línea 37|
5|	19:51:31|	app_ventas|	127.0.0.1|	Datos / Error|	Se intentó modificar el RFC del cliente 3 a GAMA780912XYZ en comercial, pero la tabla clientes no existía.|	No|	Líneas 53–58|
6|	20:17:55|	u_16540549_paulina_aldana|	172.18.0.3|	Error|	Se intentó eliminar el rol soporte_ana, pero PostgreSQL lo rechazó porque todavía tenía privilegios sobre clientes.|	No|	Líneas 81–84|
7|	21:27:55|	u_16540549_paulina_aldana|	172.18.0.3|	Datos|	Se registraron las sentencias para insertar y eliminar al cliente Pedro Ruiz en academia.|	No se observa error, pero falta confirmar el resultado en auditoría|	Líneas 194–199|
8|	22:03:40|	u_16540549_paulina_aldana|	172.18.0.3|	Datos|	Se modificó el RFC del cliente 3 a GAMA780912GHI en academia, después de deshabilitar el trigger de auditoría.|	No se observa error en la sentencia|	Líneas 220–222|
9|	22:16:44|	u_16540549_paulina_aldana|	172.18.0.3|	Datos|	Se ejecutó una actualización masiva: UPDATE clientes SET segmento = 'regular'.|	Sin error registrado|	Línea 244|

## Preguntas 

### 1. ¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?

- **Actividad 3:** No hay evidencia de que el RFC haya cambiado. La cuenta app_ventas, desde 127.0.0.1, intentó modificarlo a GAMA780912XYZ, pero la operación falló porque clientes no existía en comercial.
- **Actividad 7:** La bitácora muestra un intento de modificar el teléfono, no un cambio de RFC. También falló por la inexistencia de la tabla en comercial. No hay evidencia de un cambio exitoso de RFC en este registro.
- **Actividad 12:** La bitácora muestra intentos de modificar el RFC a GAMA780912ZZZ desde app_ventas, pero fallaron porque clientes no existía en comercial. No hay evidencia de que ese intento modificara el RFC.
- **Actividad 14:** La cuenta u_16540549_paulina_aldana, mediante pgAdmin desde 172.18.0.3, ejecutó el cambio del RFC del cliente 3 a GAMA780912GHI en academia, después de deshabilitar el trigger de auditoría. La bitácora no permite identificar a la persona física detrás de esa cuenta.

### 2. ¿Quién cambió el teléfono?

No hay evidencia de un cambio exitoso del teléfono en la bitácora proporcionada.

El registro de las 19:52:35 muestra que app_ventas, desde 127.0.0.1, intentó ejecutar:

UPDATE clientes SET telefono = '6679990000' WHERE id = 3

Sin embargo, la operación falló porque la tabla clientes no existía en comercial

### 3. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?

Sí. La bitácora registra:

- app_ventas: intento fallido desde 127.0.0.1, a las 19:28:00 UTC, por contraseña incorrecta.
- postgres: intento fallido desde una conexión local ([local]), a las 22:23:10 UTC, porque el rol no existía.
- estudiante: dos intentos fallidos desde una conexión local ([local]), a las 22:23:52 y 22:24:09 UTC, porque el rol no existía.

No se debe confundir el error de autenticación con los errores posteriores de consultas SQL: son eventos diferentes.

### 4. ¿Qué valor tenía el RFC antes de cada cambio?

- **Actividad 3:** No hay evidencia. La operación falló y no se registró un cambio.
- **Actividad 7:** No hay evidencia de un cambio de RFC en la bitácora.
- **Actividad 12:** No hay evidencia de un cambio exitoso. Los intentos registrados fallaron.
- **Actividad 14:** No hay evidencia del RFC anterior en la bitácora. La sentencia registra el nuevo valor (GAMA780912GHI), pero no conserva el valor previo.

## Conclusión

La evidencia permite identificar una modificación del RFC del cliente 3 ejecutada desde la cuenta u_16540549_paulina_aldana, pero no permite reconstruir todos los cambios históricos del RFC ni atribuirlos a una persona física. También se identificó una modificación masiva de cinco registros y dos operaciones sobre el cliente Pedro Ruiz que quedaron registradas en la auditoría.

El hallazgo más importante es que deshabilitar el trigger permitió modificar información sin generar el registro correspondiente en la tabla de auditoría. Por eso, la auditoría de base de datos, por sí sola, no garantiza la integridad del historial cuando una cuenta con privilegios administrativos puede desactivar sus mecanismos de registro.