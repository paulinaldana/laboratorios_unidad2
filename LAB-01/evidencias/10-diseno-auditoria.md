# 16. Actividad 10 — Diseñar y crear el registro de auditoría

|Campo propuesto|	Tipo|	¿Qué pregunta responde?|	¿Puede ser nulo? ¿Por qué?|
| --- | --- | --- | --- |
id_evento|	BIGSERIAL|	¿Cuál es el identificador único del evento?|	No. Se genera automáticamente y es la llave primaria.|
momento|	TIMESTAMPTZ	|¿Cuándo ocurrió la modificación?|	No. Todo evento debe tener una fecha y hora registradas.
usuario_sesion|	TEXT|	¿Con qué usuario se inició la sesión?|	No. Permite identificar la cuenta que estableció la conexión.
usuario_efectivo|	TEXT|	¿Con qué usuario se ejecutó la operación?|	No. Permite identificar el usuario efectivo, que puede cambiar durante una sesión mediante SET ROLE.
aplicacion|	TEXT|	¿Qué aplicación originó la operación?|	Sí. Algunas conexiones no proporcionan un nombre de aplicación.
ip_cliente|	INET|	¿Desde qué dirección IP se realizó la conexión?|	Sí. Las conexiones locales mediante sockets pueden no tener una dirección IP.
operacion|	TEXT|	¿Qué tipo de modificación se realizó (INSERT, UPDATE o DELETE)?|	No. Es necesario identificar el tipo de evento auditado.
id_cliente|	BIGINT|	¿Qué cliente fue afectado?|	Sí. Puede ser nulo si el evento no corresponde a un cliente identificable.
valores_antes|	JSONB|	¿Cómo estaba el registro antes de la modificación?|	Sí. En una inserción no existe un estado anterior.
valores_despues|	JSONB|	¿Cómo quedó el registro después de la modificación?|	Sí. En una eliminación no existe un estado posterior.

## Preguntas 

### 1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?

Porque TIMESTAMPTZ almacena el instante de tiempo considerando la zona horaria y permite representar correctamente cuándo ocurrió un evento, independientemente de la ubicación del servidor o del usuario.

En cambio, TIMESTAMP almacena fecha y hora sin información de zona horaria.

Esto es importante en auditoría porque permite comparar eventos de diferentes servidores y ubicaciones sin confundir sus horarios.

### 2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?

Porque permite conservar una fotografía completa del registro antes y después de una modificación.

Esto ofrece varias ventajas:
- Permite conocer qué información tenía el cliente antes del cambio.
- Facilita identificar diferencias entre el estado anterior y el posterior.
- Conserva información aunque posteriormente se agreguen, eliminen o modifiquen columnas en la tabla original.
- Permite consultar y analizar los datos almacenados mediante funciones y operadores JSONB de PostgreSQL.

Sin embargo, guardar el registro completo también implica almacenar más información y duplicar datos sensibles. Por eso, debe evaluarse qué campos realmente necesitan conservarse.

### 3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

Implica que la tabla de auditoría debe tratarse como información sensible, porque contiene datos personales de los clientes, como sus RFC, además de información sobre sus modificaciones.

Por lo tanto:
- Su acceso debe limitarse al personal autorizado, como administradores y responsables de auditoría.
- Los usuarios de las aplicaciones no deberían tener permisos para consultar o modificar directamente los registros de auditoría.
- Deben protegerse las copias de seguridad y los archivos que contengan esta información.
- Es necesario conservar los registros de acuerdo con las políticas de seguridad y protección de datos aplicables.
- Debe evitarse que los propios usuarios auditados puedan alterar o eliminar las evidencias de sus operaciones.

## Conclusión

El registro de auditoría no solo debe permitir identificar quién realizó una modificación y cuándo ocurrió, sino también reconstruir qué información cambió. Como puede contener datos personales, su protección debe ser tan rigurosa como la de la propia base de datos.