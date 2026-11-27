# 9. Actividad 3 — Diccionario de datos operativo dentro del motor

## Diccionario con las columnas que el motor no conoce:

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| id | Dato identificador interno | Identificar de manera única a cada cliente | Clave primaria y generación automática | Sí, LAB-01 Parte B | Unicidad e identificación no nula |
| nombre | Dato personal identificador directo | Identificación del cliente | Acceso restringido por permisos | Sí, LAB-01 Parte B | Completitud y formato válido |
| correo | Dato personal | Contacto y notificaciones | Validación de formato y control de acceso | Sí, LAB-01 Parte B | Formato válido y unicidad |
| telefono | Dato personal | Comunicación y seguimiento comercial | Acceso restringido por permisos | Sí, LAB-01 Parte B | Formato telefónico válido |
| rfc | Dato personal | Facturación | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato RFC |
| edad | Dato personal | Análisis estadístico y segmentación | Acceso restringido y uso en análisis agregado | Sí, LAB-01 Parte B | Rango permitido de 18 a 120 años |
| ciudad | Dato personal de ubicación | Segmentación geográfica | Acceso restringido por permisos | Sí, LAB-01 Parte B | Completitud y catálogo de ciudades válido |
| codigo_postal | Dato personal de ubicación | Identificación de zona geográfica | Acceso restringido por permisos | Sí, LAB-01 Parte B | Formato de cinco dígitos |
| fecha_alta | Dato administrativo | Registrar el ingreso del cliente al sistema | Generación y control de fechas | Sí, LAB-01 Parte B | Fecha válida y no futura |
| segmento | Dato de clasificación interna | Clasificación comercial de clientes | Acceso restringido por permisos | Sí, LAB-01 Parte B | Valores pertenecientes a categorías autorizadas |

## Preguntas

1. **¿Qué ventaja tiene guardar el significado en COMMENT en lugar de solo en un documento aparte?**

Guardar los comentarios directamente en PostgreSQL permite que la documentación permanezca asociada a la tabla y sus columnas. De esta manera, cualquier administrador o usuario autorizado que consulte la estructura puede conocer el significado y la finalidad de los campos sin tener que buscar un documento externo.

Además, los comentarios pueden consultarse mediante los catálogos del sistema, exportarse para generar diccionarios de datos y mantenerse junto con la estructura de la base de datos.

2. **¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel de log_statement?**

Los comandos COMMENT ON son instrucciones de definición de objetos de la base de datos (DDL).

Por lo tanto, con log_statement = 'ddl' deben quedar registrados en la bitácora, ya que este nivel registra las instrucciones de definición de datos.

En cambio, con log_statement = 'mod' no se registran normalmente, porque este nivel está destinado a operaciones de modificación de datos, como INSERT, UPDATE y DELETE.

Para comprobarlo, se debe revisar la bitácora correspondiente al momento en que se ejecutaron los comentarios y verificar que las instrucciones COMMENT ON COLUMN aparezcan registradas.

3. **¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**

Aunque PostgreSQL permite documentar tablas y columnas, cierta información de gobierno debe mantenerse también en documentación externa.

Por ejemplo:
- Nombre y responsabilidad del propietario de los datos.
- Identidad y responsabilidades del custodio.
- Clasificación de confidencialidad y políticas de acceso.
- Justificación del uso de los datos.
- Periodos de conservación y eliminación.
- Procedimientos para autorizar correcciones.
- Reglas de calidad y responsables de validarlas.
- Políticas legales y de protección de datos personales.
Esto se debe a que los comentarios de PostgreSQL son principalmente descriptivos y no sustituyen un sistema formal de gobierno de datos. Además, no todos los usuarios tienen acceso a los metadatos y las políticas organizacionales pueden cambiar independientemente de la estructura de la base de datos.

## Conclusión

Esta actividad permitió comprender que un diccionario de datos no solamente describe la estructura técnica de una base de datos, sino que también proporciona información sobre el significado, la finalidad, la clasificación y los controles aplicados a cada campo. Mediante COMMENT ON fue posible documentar directamente en PostgreSQL el propósito de las columnas, mientras que la consulta a information_schema.columns y col_description permitió combinar esa información y generar un diccionario exportable. Finalmente, se identificó que los metadatos técnicos deben complementarse con documentación externa sobre responsabilidades, políticas de acceso y reglas de calidad para lograr una administración adecuada de la información.