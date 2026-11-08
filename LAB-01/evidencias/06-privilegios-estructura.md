# 12. Actividad 6 — Cambios de privilegios y de estructura

## Preguntas 

### 1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

Las tres sentencias corresponden a dos categorías:
| Sentencia | Tipo de evento | ¿Qué realiza? | 
| --- | --- | --- |
REVOKE UPDATE ON clientes FROM soporte_ana;|Privilegio|	Revoca el permiso de actualización sobre la tabla clientes al rol soporte_ana.
|GRANT UPDATE ON clientes TO app_ventas;|	Privilegio	|Concede el permiso de actualización sobre la tabla clientes al rol app_ventas.|
|ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);	|Estructura	|Modifica la estructura de la tabla clientes, agregando una columna llamada segmento.|

La diferencia principal es que las dos primeras sentencias modifican los permisos de acceso, mientras que la tercera modifica la estructura de la base de datos.

### 2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?

Porque PostgreSQL clasifica las instrucciones GRANT y REVOKE dentro de las operaciones de definición de datos (DDL), ya que modifican los privilegios y las reglas de acceso a los objetos de la base de datos.

Por ello, aunque no modifican directamente los registros almacenados en las tablas, sí modifican la configuración de seguridad de la base de datos y quedan registradas cuando log_statement = 'ddl'.

Esto permite mantener evidencia de los cambios realizados sobre los permisos de los usuarios y roles.

### 3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.

La bitácora debería estar disponible exclusivamente para administradores de bases de datos y personal de seguridad autorizado que tenga responsabilidades de auditoría o investigación de incidentes.

Esto se debe a que los registros pueden contener información confidencial, como contraseñas, nombres de usuarios, direcciones IP y sentencias SQL ejecutadas.

La situación observada demuestra un riesgo relacionado con la gestión de secretos de la Unidad II: almacenar contraseñas directamente en sentencias SQL puede provocar que estas queden expuestas en archivos de registro, incluso después de eliminar el rol correspondiente.

Para reducir este riesgo, se recomienda:
- Utilizar \password en lugar de escribir contraseñas directamente en sentencias SQL cuando se administran roles desde psql.
- Evitar incluir credenciales en scripts, archivos de configuración o consultas que puedan quedar registradas.
- Restringir el acceso a los archivos de bitácora.
- Proteger los registros mediante políticas de almacenamiento, retención y eliminación segura.
- Utilizar mecanismos seguros de almacenamiento y administración de secretos.

## Conclusión

La actividad demuestra que PostgreSQL registra tanto los cambios en los privilegios como las modificaciones en la estructura de las tablas cuando se configura log_statement = 'ddl'. Sin embargo, también evidencia que la bitácora puede convertirse en un punto de exposición de información confidencial cuando se ejecutan sentencias que contienen contraseñas en texto claro. Por esta razón, la auditoría debe complementarse con buenas prácticas de gestión de secretos, control de acceso y protección de los archivos de registro.