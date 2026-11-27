# Expediente de auditoría interna — Base comercial

## 1. Alcance

El presente expediente documenta la revisión de los mecanismos de registro, auditoría de datos, control de accesos y gobierno de la información implementados durante las prácticas de laboratorio.

### **Sistemas revisados**

### PostgreSQL

Motor: PostgreSQL 16.

Despliegue: contenedor mediante Docker Desktop y Docker Compose.

Sistema de administración: pgAdmin 4.

Entorno de trabajo: Windows.

Bases de datos utilizadas: academia y comercial.

Objetos relevantes: tabla public.clientes, esquema auditoria y tabla auditoria.cambios_clientes en academia.

La base academia fue utilizada para implementar y probar el mecanismo de auditoría de modificaciones sobre clientes. La base comercial se utilizó en pruebas de acceso y ejecución de operaciones con distintos roles. Por ello, los resultados de ambas bases se identifican por separado para evitar atribuir a una base objetos o eventos que pertenecen a la otra.

### MongoDB

Motor: MongoDB Community Edition, de acuerdo con el entorno documentado en las prácticas.

Evidencias consideradas: system-profile.json y bitacora-mongod.log.

Versión exacta y forma de despliegue: pendientes de confirmar mediante la evidencia de LAB-02.

### **Periodo revisado**

La revisión considera las evidencias generadas durante las prácticas de laboratorio, incluyendo los registros de PostgreSQL del 8 de noviembre de 2026 y los resultados de conciliación de cambios asociados al folio CAM-2026-014, correspondientes a noviembre de 2026.

Las marcas de tiempo de las bitácoras se conservan en UTC cuando así aparecen en los archivos originales. La fecha y hora de cada evento deben interpretarse considerando la zona horaria registrada por el servidor.

### **Responsable del expediente**

Responsable de elaboración: estudiante responsable de las prácticas de laboratorio.

Finalidad: integrar y organizar la evidencia técnica disponible para que auditoría interna pueda revisar los controles implementados, los eventos registrados, las diferencias detectadas y las limitaciones de los mecanismos de auditoría.

El expediente se limita a los resultados y evidencias obtenidos durante las prácticas. No constituye una certificación de seguridad ni demuestra por sí mismo que los controles hayan permanecido activos durante periodos en los que no se conservaron registros históricos.

## 2. Configuración de auditoría (A3)

### **2.1 PostgreSQL**

Durante las prácticas se configuró PostgreSQL 16 para registrar conexiones, desconexiones y determinadas instrucciones ejecutadas en el servidor.

En la revisión inicial del laboratorio se identificó la siguiente configuración:

- logging_collector: desactivado.
- log_connections: desactivado.
- log_disconnections: desactivado.
- log_statement: none.
- log_min_error_statement: error.
- log_line_prefix: %m [%p].

Posteriormente, se modificó la configuración para ampliar la información registrada:

- logging_collector: activado.
- log_connections: activado.
- log_disconnections: activado.
- log_statement: se utilizaron los valores ddl y posteriormente mod, según la etapa de la práctica.
- log_min_error_statement: error.
- log_line_prefix: %m [%p] user=%u db=%d app=%a client=%h.

La configuración inicial y los cambios se documentan en informe.md y en la bitácora de LAB-01 (bitacora-lab01.log). La evidencia E1 de LAB-03 debe contener la consulta actual a pg_settings; esta permite conocer la configuración vigente al momento de la extracción, pero no demuestra por sí sola que esos valores hayan permanecido activos durante todo el periodo revisado.

### Limitaciones de cobertura:

- Con log_statement = 'ddl' se registran instrucciones de definición de datos, pero no todas las modificaciones de registros.
- Con log_statement = 'mod' se registran instrucciones de modificación, pero no las consultas ordinarias de lectura (SELECT).
- Los errores pueden quedar registrados mediante log_min_error_statement, aunque el registro de una sentencia no demuestra que esta haya concluido correctamente.
- La configuración del registro puede modificarse por usuarios con privilegios administrativos.

### **2.2 Auditoría mediante disparadores**

En la base academia se implementó el esquema auditoria, con la tabla auditoria.cambios_clientes y un disparador asociado a las modificaciones de public.clientes.

La tabla de auditoría conserva metadatos del evento, entre ellos:

- Identificador del evento.

- Fecha y hora.

- Usuario de sesión.

- Usuario efectivo.

- Aplicación e IP del cliente, cuando están disponibles.

- Tipo de operación.

- Identificador del cliente afectado.

- Valores anteriores y posteriores.

La función del disparador utiliza SECURITY DEFINER. Por ello, se distingue entre session_user, que identifica el usuario que inició la sesión, y current_user, que puede corresponder al propietario de la función durante su ejecución.

La bitácora de LAB-01 documenta que el disparador pudo deshabilitarse y habilitarse durante las pruebas. También se identificó una modificación de RFC que no generó el registro correspondiente en la tabla de auditoría porque el disparador estaba deshabilitado durante esa operación.

**Evidencia:** bitacora-lab01.log e informe.md, LAB-01. La evidencia E3 de LAB-03 debe incorporar la consulta del estado actual de los disparadores. Si todavía no se ha generado, queda pendiente de adjuntar.

### **2.3 MongoDB**

Para MongoDB se consideran los mecanismos de registro disponibles en el entorno de prácticas:

- Bitácora del proceso mongod.
- Perfilado de operaciones mediante system.profile.

Estos mecanismos permiten observar determinados eventos y operaciones, pero no deben confundirse con un sistema integral de auditoría nativa. La cobertura depende de la configuración del perfilador, del nivel de registro y de la conservación de los archivos.

**Evidencia:** system-profile.json y bitacora-mongod.log, correspondientes a LAB-02. Su incorporación y verificación en el expediente se encuentran pendientes de confirmar mediante la evid

## 3. Bitácora interpretada (A3, A5)

La interpretación de las bitácoras considera tanto las operaciones registradas como sus resultados. Una sentencia que aparece en el registro no necesariamente fue ejecutada correctamente; por ello, se distingue entre intentos, operaciones exitosas y eventos cuya ejecución no pudo comprobarse.

### **3.1 Incidente de modificación del RFC de María García**


Sistema: PostgreSQL.
Base de datos: academia.
Objeto: public.clientes.
Usuario de sesión: u_16540549_paulina_aldana.
Cliente afectado: ID 3, identificado en la actividad como María García.

La bitácora de LAB-01 documenta la siguiente secuencia:

1. Deshabilitación del disparador trg_auditoria_clientes.
2. Modificación del RFC del cliente con ID 3 a GAMA780912GHI.
3. Habilitación nuevamente del disparador.

Los eventos aparecen en los siguientes momentos, según la bitácora:

- 2026-11-08 22:03:37.974: deshabilitación del disparador.
- 2026-11-08 22:03:40.947: modificación del RFC.
- 2026-11-08 22:03:44.535: habilitación del disparador.

La modificación no quedó registrada en auditoria.cambios_clientes, debido a que el mecanismo de auditoría estaba deshabilitado durante la operación.

**Interpretación:** este incidente demuestra una limitación importante del mecanismo implementado: un usuario con privilegios suficientes para modificar el estado del disparador puede realizar cambios que no generen el registro esperado en la tabla de auditoría.

La bitácora del servidor permitió reconstruir la secuencia de operaciones, pero no se cuenta con evidencia suficiente para establecer el valor anterior del RFC únicamente a partir de estos registros.

**Fuente:** bitacora-lab01.log e informe.md, LAB-01.

### **3.2 Intento de modificación en la base comercial**

Durante las pruebas se registraron intentos de actualización de información de clientes en la base comercial, utilizando el rol app_ventas.

Las operaciones no pudieron completarse debido a que PostgreSQL reportó que la relación clientes no existía en esa base de datos.

**Interpretación:** el registro permite identificar un intento de modificación y el error que impidió su ejecución. No debe interpretarse como una modificación exitosa ni como evidencia de que los datos hayan cambiado.

Este evento también evidencia la importancia de identificar correctamente la base de datos y los objetos sobre los que se ejecutan las operaciones, especialmente cuando se utilizan nombres de tablas similares en diferentes bases.

**Fuente:** bitacora-lab01.log e informe.md, LAB-01.

### **3.3 Intento de eliminación de un rol**

Durante las pruebas de administración se registró un intento de ejecutar DROP ROLE soporte_ana.

La operación fue rechazada porque el rol todavía tenía privilegios o dependencias asociados.

**Interpretación:** la bitácora permite identificar una operación administrativa intentada y su resultado fallido. El evento no demuestra que el rol haya sido eliminado. También muestra la utilidad de conservar los errores de ejecución para reconstruir acciones administrativas que no concluyeron correctamente.

**Fuente:** bitacora-lab01.log e informe.md, LAB-01.

### **3.4 Modificaciones registradas en la tabla de auditoría**

En las pruebas de LAB-01 se identificaron operaciones de inserción y eliminación relacionadas con un registro temporal de Pedro Ruiz, así como cinco modificaciones de clientes que actualizaron el campo segmento a regular.

Estas operaciones quedaron representadas en auditoria.cambios_clientes.

**Interpretación:** a diferencia del incidente del RFC, estas modificaciones sí generaron registros en la tabla de auditoría. Esto permite contrastar el funcionamiento esperado del disparador con el caso en el que fue deshabilitado.

**Fuente:** informe.md, LAB-01. La consulta y exportación de los últimos diez registros deben incorporarse como evidencia E4 de LAB-03.

## 4. Elementos de gobierno (A1, A2)

Los elementos de gobierno documentados durante las prácticas comprenden la identificación de los datos, su descripción técnica, la asignación de responsabilidades y los mecanismos de control sobre su uso y modificación.

### **4.1 Catálogo y diccionario de datos**

Se trabajó con metadatos obtenidos directamente del motor PostgreSQL para describir las tablas y sus columnas.

En la tabla de clientes se documentaron campos como:

- telefono

- ciudad

- codigo_postal

- fecha_alta

- segmento

Se utilizaron comentarios mediante COMMENT ON para incorporar descripciones a las columnas. Asimismo, se consultaron las vistas del catálogo del sistema y de information_schema para recuperar información técnica de los objetos.

El diccionario de datos permite identificar el significado y las características de los campos, mientras que el catálogo técnico proporciona información sobre los objetos existentes en el motor.

**Fuentes:** actividades de diccionario y catálogo de datos de LAB-03; archivo diccionario-clientes.csv y evidencia del catálogo, cuando se encuentren incorporados al expediente.

### **4.2 Responsabilidades y control de acceso**

El gobierno de los datos requiere diferenciar las responsabilidades de quienes solicitan, autorizan, administran y utilizan la información.

Para las políticas del laboratorio se consideran las siguientes funciones:

- Responsable del dato: determina quién puede acceder a la información y con qué finalidad.

- Administrador de base de datos: ejecuta los cambios técnicos autorizados y mantiene los mecanismos de registro.

- Usuario solicitante: justifica la necesidad de acceso o modificación.

- Responsable de seguridad o auditoría: revisa los registros, privilegios y cumplimiento de los controles.

La existencia de roles y privilegios técnicos no demuestra por sí sola que exista una asignación formal de responsabilidades. Para acreditar dicha asignación se requiere conservar la matriz de roles y responsabilidades correspondiente.

**Fuente:** actividades de gobierno y control de acceso de LAB-03. La matriz de roles debe incorporarse como evidencia documental si forma parte de A1 o A2.

### **4.3 Solicitudes de cambio**

Se identificó el registro de una solicitud de cambio en la tabla gobierno.solicitudes_cambio:

- Folio: CAM-2026-014.

- Descripción: agregar la columna canal_alta a clientes.

- Solicitado por: Gerencia Comercial.

- Aprobado por: Comité de cambios.

- Ambiente indicado: produccion.

- Fecha de aprobación registrada: 2026-11-26 05:56:32.043686+00.

- Ventana de inicio: 2026-11-27 05:51:32.043686+00.

- Ventana de fin: 2026-11-27 06:56:32.043686+00.

Este registro permite identificar la solicitud, su aprobación y la ventana autorizada. Sin embargo, la existencia de una solicitud aprobada no demuestra por sí misma que la modificación se haya ejecutado correctamente ni que se haya realizado dentro de la ventana.

**Fuente:** consulta a gobierno.solicitudes_cambio, evidencia de la Actividad 7.

## 5. Conservación (A3)

La conservación de evidencias debe permitir reconstruir eventos relevantes durante un periodo suficiente, sin almacenar información indefinidamente ni exponer datos personales innecesarios.

Para las prácticas se establecieron los siguientes periodos propuestos:

| Tipo de evidencia | Periodo propuesto |
|---|---:|
| Bitácoras de acceso de PostgreSQL | 12 meses |
| Cambios de privilegios y estructura | 24 meses |
| Registros de modificaciones de datos | 12 meses |
| Tabla `auditoria.cambios_clientes` | 24 meses |
| Bitácoras del proceso `mongod` | 12 meses |
| Colección `system.profile` | 30 días |
| Evidencias de privilegios de MongoDB | 24 meses |

Estos periodos son criterios propuestos para el ejercicio académico y no deben presentarse como plazos legales obligatorios. Su aplicación en una organización real requiere revisar las obligaciones normativas, contractuales y operativas correspondientes.

### **5.1 Controles de conservación**

Se proponen los siguientes controles:

- Almacenar las evidencias en una ubicación centralizada y separada del servidor de origen.
- Restringir el acceso a los archivos de acuerdo con las responsabilidades asignadas.
- Registrar las consultas, exportaciones y modificaciones realizadas sobre el repositorio de evidencias.
- Calcular hashes SHA-256 para comprobar la integridad de los archivos.
- Conservar los hashes en un registro protegido y separado de los archivos originales.
- Aplicar eliminación segura o anonimización al concluir el periodo de conservación, siempre que no exista una investigación, obligación legal o retención justificada.

El cálculo de un hash permite detectar modificaciones respecto de una huella previamente conservada, pero no impide por sí solo que una persona con acceso suficiente modifique tanto el archivo como el registro del hash.

### **5.2 Estado de implementació**n

Los periodos anteriores constituyen criterios de conservación documentados. No se cuenta con evidencia suficiente para afirmar que exista un proceso automatizado de eliminación, un repositorio centralizado permanente o una política institucional formalmente aprobada.

Por tanto, deben distinguirse los criterios propuestos de los controles cuya implementación y operación hayan sido verificadas.

**Fuente:** Actividad 5 de LAB-03 y documentación de conservación del expediente.

## 6. Políticas (A4)

Las siguientes políticas establecen criterios mínimos para administrar el acceso, respaldo, conservación, recuperación, tratamiento de información sensible y ejecución de cambios.

### **POL-01. Control de acceso**

Todo acceso a información deberá responder a una necesidad de trabajo identificable y contar con autorización del responsable del dato.

Las solicitudes deberán especificar:

- Usuario o rol que requiere acceso.
- Base de datos, esquema, tabla o colección.
- Privilegios solicitados.
- Finalidad del acceso.
- Periodo durante el cual se requiere.

El administrador ejecutará los cambios autorizados y conservará evidencia de las operaciones de concesión o revocación de privilegios.

Se recomienda revisar los privilegios al menos trimestralmente y retirar los que ya no sean necesarios.

**Evidencia relacionada:** registros de PostgreSQL, consultas de privilegios y snapshots de permisos de MongoDB, cuando estén disponibles.

### **POL-02. Respaldo de información**

Las bases de datos operativas y sus estructuras de auditoría deberán contar con respaldos periódicos.

Como criterio propuesto, se establece:

- Respaldo diario de la información operativa y de auditoría.
- Verificación semanal de la integridad de los respaldos.
- Conservación de una copia separada del servidor de origen.
- Registro de fecha, responsable, alcance y resultado de cada respaldo.

La existencia de archivos de respaldo no demuestra que estos puedan recuperarse correctamente; por ello, deben realizarse pruebas periódicas de restauración.

**Estado:** no se cuenta con evidencia de pruebas periódicas de respaldo y restauración en LAB-01 a LAB-03.

### **POL-03. Conservación y eliminación**

Los registros y evidencias deberán conservarse de acuerdo con los periodos definidos en la política de retención.

Antes de eliminar información se deberá verificar que:

- El periodo de conservación haya concluido.
- No exista una investigación o incidente que justifique su conservación temporal.
- No exista una obligación legal o contractual pendiente.
- La eliminación o anonimización quede documentada.

Los datos personales deberán conservarse únicamente durante el tiempo necesario para la finalidad correspondiente, considerando las obligaciones aplicables.

**Evidencia relacionada:** criterios de conservación de la Actividad 5. No se cuenta con evidencia de un proceso formal de eliminación ejecutado durante las prácticas.

### **POL-04. Restauración de información**

Toda restauración deberá responder a una solicitud identificable y contar con autorización del responsable correspondiente.

El procedimiento deberá contemplar:

- Identificación del respaldo requerido.
- Justificación de la restauración.
- Autorización del responsable del dato o de seguridad.
- Ejecución por el administrador autorizado.
- Validación de integridad y funcionamiento posterior.
- Registro de fecha, responsable y resultado.

**Estado:** no se cuenta con evidencia de solicitudes formales ni de pruebas documentadas de restauración en LAB-01 a LAB-03.

### **POL-05. Tratamiento de información sensible**

El acceso a información sensible deberá limitarse a usuarios autorizados y a las finalidades justificadas.

Se deberán aplicar los principios de minimización de datos y acceso restringido. Las consultas y modificaciones relevantes deberán registrarse mediante los mecanismos disponibles.

Cuando una investigación requiera revisar información personal, deberá limitarse la exposición de los datos a lo estrictamente necesario.

**Evidencia relacionada:** bitácoras de PostgreSQL, tabla `auditoria.cambios_clientes` y registros de MongoDB disponibles. No se cuenta con evidencia de un procedimiento formal que exija justificar individualmente cada consulta.

### **POL-06. Gestión de cambios en producción**

Toda modificación en el entorno de producción deberá contar con una solicitud documentada y autorización previa.

La solicitud deberá incluir:

- Descripción del cambio.
- Responsable solicitante.
- Responsable que autoriza.
- Ambiente afectado.
- Evaluación de riesgos e impacto.
- Ventana de ejecución.
- Plan de reversión.
- Validaciones posteriores.

El administrador ejecutará únicamente los cambios autorizados. Las modificaciones urgentes deberán documentarse y justificarse mediante un procedimiento excepcional.

Después de cada cambio se deberá verificar su resultado y conservar la evidencia técnica correspondiente.

**Evidencia relacionada:** tabla `gobierno.solicitudes_cambio`, bitácoras de PostgreSQL y evidencia de estructura de la base de datos.

La solicitud `CAM-2026-014` constituye un registro de autorización, pero la evidencia disponible no permite demostrar que la modificación de `canal_alta` haya sido ejecutada y conciliada correctamente.

## 7. Conciliación de cambios (A5)

La conciliación compara las solicitudes aprobadas con las operaciones observadas en las bitácoras y con el estado actual de los objetos de la base de datos.

### **7.1 Solicitud revisada**

Se revisó el folio `CAM-2026-014`, cuya descripción indica:

**Agregar la columna `canal_alta` a la tabla `clientes`.**

La solicitud identifica como solicitante a Gerencia Comercial y como aprobador al Comité de cambios. El ambiente indicado es `produccion`.

La ventana registrada es:

- Inicio: `2026-11-27 05:51:32.043686+00`.
- Fin: `2026-11-27 06:56:32.043686+00`.

### **7.2 Evidencia observada**

La consulta a `gobierno.solicitudes_cambio` devolvió un registro correspondiente al folio señalado.

La consulta a `dba.bitacora`, filtrando sentencias `CREATE`, `ALTER`, `DROP`, `GRANT` y `REVOKE`, devolvió únicamente el siguiente evento:

| Número | Momento | Usuario | Sentencia |
|---:|---|---|---|
| 94 | 2026-11-27 05:56:09.531 | `u_16540549_paulina_aldana` | `CREATE SCHEMA gobierno;` |

Este evento se encuentra dentro de la ventana de ejecución registrada, pero no corresponde a la modificación de la tabla `clientes` descrita en la solicitud.

Por otra parte, la consulta a `information_schema.columns` confirmó la existencia de la columna:

- Nombre: `canal_alta`.
- Tipo: `character varying`.
- Longitud: `20`.

La consulta a la bitácora buscando referencias a `trg_auditoria_clientes` no devolvió registros.

### **7.3 Resultado de la conciliación**

La evidencia permite confirmar que:

1. Existe una solicitud registrada y aprobada con el folio `CAM-2026-014`.
2. La columna `canal_alta` existe en la estructura consultada.
3. Se encontró un evento `CREATE SCHEMA gobierno` dentro de la ventana registrada.
4. No se encontró en el resultado de la consulta a `dba.bitacora` la sentencia `ALTER TABLE` correspondiente a la solicitud.
5. No se encontraron registros relacionados con `trg_auditoria_clientes` mediante la consulta ejecutada.

No es posible demostrar con la evidencia disponible quién ejecutó la creación de `canal_alta`, en qué momento exacto se realizó ni si se ejecutó dentro de la ventana autorizada. La ausencia de una sentencia en la consulta de bitácora tampoco demuestra que la operación no haya ocurrido.

**Observación de integridad temporal:** los registros proporcionados contienen fechas del 27 de noviembre de 2026, posteriores a la fecha de corte del presente expediente, 26 de noviembre de 2026. Antes de cerrar la conciliación deberá verificarse la fecha real de generación de las evidencias, la zona horaria y la consistencia del reloj del servidor.

**Conclusión de conciliación:** el cambio se considera parcialmente comprobado. La existencia de la columna está verificada, pero no se cuenta con evidencia suficiente para acreditar su ejecución conforme a la solicitud aprobada.

**Fuente:** consulta de `gobierno.solicitudes_cambio`, consultas a `dba.bitacora`, `information_schema.columns` y búsqueda de `trg_auditoria_clientes`, Actividad 7.

## 8. Hallazgos

Los hallazgos se clasifican según su impacto potencial sobre la integridad, trazabilidad, disponibilidad y control de la información.

| ID | Hallazgo | Fuente | Severidad | Impacto | Recomendación | Decisión requerida de |
|---|---|---|---|---|---|---|
| H-01 | El disparador de auditoría pudo deshabilitarse antes de modificar el RFC de un cliente. | `bitacora-lab01.log`; `informe.md`, LAB-01. | Alta | Una modificación puede no generar el registro esperado en la tabla de auditoría. | Restringir privilegios para modificar o deshabilitar disparadores y generar alertas ante estos eventos. | Responsable de base de datos y responsable de seguridad. |
| H-02 | La modificación del RFC no quedó registrada en `auditoria.cambios_clientes`. | `bitacora-lab01.log`; `informe.md`, LAB-01. | Alta | Se pierde trazabilidad en el mecanismo de auditoría de datos. | Revisar el incidente y establecer controles complementarios que permitan detectar cambios realizados sin disparador. | Responsable de auditoría y responsable del dato. |
| H-03 | La configuración de registro cambió durante las prácticas y no se cuenta con evidencia histórica continua de todos sus valores. | `informe.md`; evidencia E1 pendiente de incorporación. | Media | No es posible asegurar que todos los eventos hayan sido registrados durante todo el periodo. | Conservar cambios de configuración, fechas, responsables y evidencia histórica verificable. | Administrador de base de datos. |
| H-04 | La configuración `log_statement = 'mod'` no registra consultas ordinarias de lectura. | Configuración documentada en `informe.md`, LAB-01. | Media | No se dispone de trazabilidad completa de las consultas de lectura. | Evaluar mecanismos adicionales, como `pgaudit`, considerando volumen, privacidad y capacidad de almacenamiento. | Responsable de seguridad y administrador de base de datos. |
| H-05 | La conciliación del folio `CAM-2026-014` no cuenta con evidencia directa de la sentencia `ALTER TABLE` correspondiente. | Consultas de Actividad 7 a `dba.bitacora` e `information_schema.columns`. | Media | No puede acreditarse quién ejecutó el cambio ni si ocurrió dentro de la ventana autorizada. | Investigar el origen del cambio y conservar una bitácora completa de las modificaciones estructurales. | Comité de cambios y administrador de base de datos. |
| H-06 | No se encontraron registros del disparador `trg_auditoria_clientes` en la consulta específica de la Actividad 7. | Consulta `ILIKE '%trg_auditoria_clientes%'`, Actividad 7. | Media | La consulta no permite reconstruir eventos relacionados con el disparador en ese conjunto de registros. | Revisar la cobertura de registro y complementar la evidencia con el estado actual de los disparadores. | Administrador de base de datos. |
| H-07 | No se cuenta con evidencia de pruebas periódicas de restauración de respaldos. | Actividad 6 y documentación de LAB-01 a LAB-03. | Media | Un respaldo podría no ser recuperable cuando se necesite. | Establecer y documentar pruebas periódicas de restauración. | Responsable de infraestructura y administrador de base de datos. |
| H-08 | Los criterios de conservación están documentados, pero no se ha demostrado su aplicación automatizada. | Actividad 5. | Media | Podrían conservarse datos más tiempo del necesario o eliminarse antes de cumplir su finalidad. | Aprobar formalmente los periodos y documentar los procesos de eliminación, anonimización y excepciones. | Responsable de gobierno de datos y área jurídica. |
| H-09 | Los mecanismos de registro de MongoDB no equivalen necesariamente a auditoría nativa integral. | LAB-02; evidencia E6 pendiente de incorporación y verificación. | Media | Determinados eventos podrían no quedar registrados o conservarse durante un periodo insuficiente. | Verificar la edición, configuración y cobertura de los mecanismos utilizados; evaluar alternativas según los requisitos de auditoría. | Administrador de MongoDB y responsable de seguridad. |

Los hallazgos se mantienen abiertos hasta que exista evidencia suficiente de su atención. La recomendación no implica que el control se haya implementado ni que el riesgo haya sido aceptado formalmente.

## 9. Limitaciones conocidas y riesgos aceptados (A6)

### **9.1 Limitaciones verificadas en las prácticas**

**PostgreSQL**

- La configuración `log_statement = 'mod'` no registra las consultas ordinarias de lectura.
- Los registros del servidor pueden contener sentencias que fallaron; por tanto, deben interpretarse junto con sus resultados.
- Un usuario con privilegios administrativos puede modificar la configuración de registro y los mecanismos de auditoría.
- El disparador de auditoría pudo deshabilitarse durante las pruebas, lo que permitió realizar una modificación sin generar el registro esperado en `auditoria.cambios_clientes`.
- La vista `pg_stat_activity` representa actividad de sesiones en curso y no sustituye una bitácora histórica.
- La función de auditoría con `SECURITY DEFINER` distingue al usuario de sesión del usuario efectivo, pero no garantiza por sí sola que la identidad técnica corresponda a una persona física.

**MongoDB**

- El perfilador `system.profile` registra operaciones de acuerdo con su configuración y nivel de perfilado.
- Las bitácoras del proceso `mongod` dependen de la configuración y del nivel de registro.
- Estos mecanismos no deben considerarse equivalentes a un sistema de auditoría nativa integral.
- La edición Community de MongoDB no incluye la funcionalidad de auditoría nativa disponible en las ediciones Enterprise. La edición y versión exactas del entorno deben respaldarse con la evidencia de LAB-02.

### **9.2 Controles documentados, pero no demostrados como practicados**

Los siguientes controles forman parte de las políticas o recomendaciones del expediente, pero no se cuenta con evidencia suficiente para afirmar que fueron ejecutados durante las prácticas:

- Revisión trimestral formal de privilegios.
- Respaldo diario automatizado y verificación semanal.
- Pruebas periódicas de restauración.
- Eliminación o anonimización automatizada al concluir los periodos de conservación.
- Aprobación institucional de las políticas de gobierno.
- Repositorio centralizado con acceso restringido para conservar evidencias.
- Registro protegido y separado de hashes de integridad.
- Procedimiento formal de autorización, evaluación de riesgos y reversión para todos los cambios en producción.
- Auditoría nativa de MongoDB Enterprise, que se considera una alternativa documentada, pero no implementada ni probada en el entorno Community de las prácticas.

### **9.3 Riesgos aceptados y decisiones pendientes**

La existencia de limitaciones técnicas no significa que el riesgo haya sido aceptado formalmente por una organización.

Para considerar un riesgo como aceptado se requiere identificar a la persona responsable, documentar la justificación, establecer el impacto tolerado y definir una fecha de revisión.

En este expediente se registran las siguientes decisiones pendientes:

1. Determinar si se implementará un mecanismo complementario para registrar consultas de lectura en PostgreSQL.
2. Restringir y supervisar las operaciones administrativas capaces de deshabilitar los mecanismos de auditoría.
3. Definir si la cobertura de auditoría de MongoDB satisface las necesidades del entorno o requiere una solución adicional.
4. Aprobar formalmente los periodos de conservación y los procedimientos de eliminación.
5. Completar la conciliación de los cambios estructurales cuya ejecución no pudo acreditarse con la bitácora disponible.

## 10. Índice de evidencias

El índice de evidencias identifica los archivos que respaldan los resultados y conclusiones del expediente. Cada archivo deberá conservarse en su formato original siempre que sea posible.

| ID | Archivo o evidencia | Actividad / origen | Contenido | Hash SHA-256 |
|---|---|---|---|---|
| E1 | `E1-configuracion-registro.txt` | LAB-03, Actividad 8 | Configuración actual de registro de PostgreSQL. | Pendiente de calcular. |
| E2 | `E2-privilegios.txt` | LAB-03, Actividad 8 | Privilegios sobre tablas y objetos de las bases de datos. | Pendiente de calcular. |
| E3 | `E3-disparadores.txt` | LAB-03, Actividad 8 | Estado de los disparadores no internos de PostgreSQL. | Pendiente de calcular. |
| E4 | `E4-muestra-auditoria.txt` | LAB-03, Actividad 8 | Últimos diez registros de `auditoria.cambios_clientes`, con metadatos. | Pendiente de calcular. |
| E5 | `E5-bitacora-postgresql.log` | LAB-03, Actividad 8 | Extracto de bitácora PostgreSQL con datos sensibles sustituidos. | Pendiente de calcular. |
| E6 | `system-profile.json` y `bitacora-mongod.log` | LAB-02 | Evidencias de perfilado y bitácora del proceso MongoDB. | Pendiente de calcular. |
| E7 | `bitacora-lab01.log` | LAB-01 | Bitácora de eventos de PostgreSQL, incluidos intentos fallidos y el incidente del RFC. | Pendiente de calcular. |
| E8 | `informe.md` | LAB-01 | Descripción del entorno, configuración, auditoría y resultados de las pruebas. | Pendiente de calcular. |
| E9 | `diccionario-clientes.csv` | Actividad de diccionario de datos | Descripción de campos y metadatos de la tabla de clientes. | Pendiente de calcular. |
| E10 | Evidencia de catálogo de datos | Actividad de catálogo de datos | Información técnica de tablas y columnas obtenida del motor. | Pendiente de identificar. |
| E11 | Consulta de `gobierno.solicitudes_cambio` | LAB-03, Actividad 7 | Registro de la solicitud `CAM-2026-014`. | Pendiente de exportar y calcular. |
| E12 | Consulta de `dba.bitacora` | LAB-03, Actividad 7 | Eventos de creación, modificación y administración encontrados en la bitácora. | Pendiente de exportar y calcular. |
| E13 | Consulta de `information_schema.columns` | LAB-03, Actividad 7 | Existencia y tipo de la columna `canal_alta`. | Pendiente de exportar y calcular. |
| E14 | Consulta de búsqueda del disparador | LAB-03, Actividad 7 | Resultado de búsqueda de `trg_auditoria_clientes` en la bitácora. | Pendiente de exportar y calcular. |

### **10.1 Criterio de integridad**

Los hashes SHA-256 deberán calcularse una vez que los archivos estén completos y en su versión definitiva.

Los valores obtenidos se incorporarán al índice o a un archivo independiente de hashes. Cualquier modificación posterior de una evidencia requerirá generar una nueva huella y conservar la relación con la versión anterior.

Los campos señalados como pendientes no representan hashes calculados. No deberán sustituirse por valores estimados ni inventados.

### **10.2 Estado de cierre del expediente**

El expediente integra los mecanismos de auditoría, los elementos de gobierno, las políticas, los resultados de conciliación y las limitaciones identificadas durante las prácticas.

Su cierre definitivo requiere verificar que todas las evidencias estén incorporadas, que sus hashes hayan sido calculados y que los hallazgos abiertos cuenten con una decisión documentada.

Mientras existan evidencias pendientes o diferencias sin resolver, el expediente deberá considerarse **integrado parcialmente y sujeto a validación**.