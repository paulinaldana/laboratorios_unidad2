# 21. Actividad 15 — Límites: lecturas y volumen

## Preguntas

### 1. Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?

Se generarían aproximadamente un millón de registros nuevos en auditoria.cambios_clientes, porque el disparador está configurado para ejecutarse FOR EACH ROW, es decir, una vez por cada fila modificada.

Esto tendría varias consecuencias:
- El tamaño de la tabla de auditoría aumentaría considerablemente.
- Se necesitaría más espacio de almacenamiento.
- La operación tardaría más debido al trabajo adicional del disparador.
- Las consultas sobre la auditoría podrían volverse más lentas.
- Se conservaría una gran cantidad de información, incluidos datos personales anteriores y posteriores a la modificación.

Además, si la operación falla y se revierte mediante un ROLLBACK, los registros insertados por el disparador también se revierten, porque forman parte de la misma transacción.

### 2. Propón quién podría autorizar la depuración de auditoria.cambios_clientes.

La depuración debería ser autorizada por el responsable de seguridad de la información o el área de protección de datos, en coordinación con el administrador de bases de datos y el área jurídica cuando corresponda.

El administrador podría ejecutar técnicamente la depuración, pero no debería decidir por sí solo qué evidencias eliminar.

La autorización tendría que considerar:
- La antigüedad de los registros.
- Su utilidad para investigaciones o auditorías.
- Las obligaciones legales de conservación.
- La política institucional de retención de datos.
- La existencia de investigaciones o incidentes pendientes.

Esto permite evitar que se eliminen evidencias antes de tiempo o que se conserven datos personales indefinidamente.

### 3. ¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?

Porque esta configuración registra todas las sentencias SQL, incluidas las consultas que acceden a información personal o confidencial.

Por ejemplo, si un usuario consulta el RFC y el teléfono de un cliente mediante un SELECT, la sentencia puede quedar registrada en la bitácora.

Esto genera un riesgo adicional: la bitácora puede contener información sobre qué datos se consultaron, qué usuarios los consultaron e incluso valores sensibles incluidos directamente en las sentencias SQL.

Por lo tanto, deja de ser únicamente un registro de actividad y se convierte también en un repositorio que puede revelar información confidencial.

Esto implica que debe contar con controles de acceso, almacenamiento seguro, políticas de retención y supervisión similares a los de la base de datos original.

## Conclusión

La auditoría permite conocer y reconstruir modificaciones, pero también genera costos de almacenamiento y riesgos de exposición de información. Por eso, su diseño debe considerar el volumen de operaciones, el nivel de detalle necesario y las políticas de conservación de datos.