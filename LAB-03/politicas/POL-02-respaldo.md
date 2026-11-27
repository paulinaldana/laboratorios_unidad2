# POL-02 — Política de respaldo

**Objetivo:** 

Reducir el riesgo de pérdida permanente de información ante fallas técnicas, errores humanos, corrupción de datos o incidentes de seguridad.

**Alcance:** 

Aplica a las bases de datos PostgreSQL y MongoDB, incluyendo los datos operativos, las tablas de auditoría, las colecciones de control y los metadatos necesarios para recuperar los servicios.

**Regla:**
1. Las bases de datos operativas deberán respaldarse diariamente y las tablas y colecciones de auditoría deberán incluirse en el respaldo.
2. El DBA y el administrador de MongoDB deberán verificar semanalmente que los respaldos se hayan generado correctamente y que puedan identificarse y recuperarse.
3. Se conservará al menos una copia fuera del servidor de origen para reducir el riesgo de pérdida simultánea.
Responsable: El propietario del dato determina qué información debe respaldarse y sus prioridades; el DBA y el administrador de MongoDB ejecutan y verifican los respaldos.

**Excepciones:** 

Cualquier exclusión de datos o modificación de la frecuencia deberá justificarse y ser aprobada por el propietario del dato y el responsable de seguridad.

**Evidencia:**
- Actualmente no existe un registro documentado de respaldos periódicos ni evidencia de pruebas de recuperación en los LAB-01 a LAB-03.
- Se deberá generar un registro de ejecución de respaldos, resultados de verificación y responsables.

**Revisión:** 

Cada seis meses y después de cambios importantes en la infraestructura o en los datos administrados.

*El procedimiento técnico se definirá en la Unidad V.*