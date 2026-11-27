# POL-06 — Política de cambios en producción

**Objetivo:** 

Reducir el riesgo de interrupciones, pérdida de información, modificaciones no autorizadas y alteraciones de la seguridad de los sistemas durante cambios en producción.

**Alcance:** 

Aplica exclusivamente al ambiente de producción definido en la Unidad I, incluyendo los servicios PostgreSQL 16 y MongoDB 7, sus bases de datos, esquemas, colecciones, privilegios, configuraciones y mecanismos de auditoría.

**Regla:**
1. Antes de ejecutar cualquier cambio en producción, deberá existir una solicitud documentada que describa su justificación, alcance, impacto, riesgos y plan de reversión. El propietario del dato o responsable del sistema deberá aprobarla.
2. Durante la ejecución, el DBA o administrador responsable deberá realizar únicamente las modificaciones autorizadas y asegurar que las operaciones queden registradas en las bitácoras correspondientes.
3. Después del cambio, el responsable deberá verificar el funcionamiento del sistema, la integridad de los datos y la continuidad de los mecanismos de auditoría; los resultados deberán incorporarse a la solicitud de cambio.
Responsable: El propietario del dato o responsable del sistema aprueba el cambio; el DBA o administrador de MongoDB lo ejecuta; el responsable de seguridad verifica que no se comprometan los controles de acceso y auditoría.

**Excepciones:** 

Los cambios urgentes para corregir fallas críticas o vulnerabilidades podrán ejecutarse mediante un procedimiento de emergencia autorizado por el responsable del sistema y el responsable de seguridad. Deberán documentarse y revisarse posteriormente.

**Evidencia:**
- LAB-01: bitácora de PostgreSQL con sentencias ejecutadas, incluyendo cambios de estructura y privilegios cuando están registrados.
- LAB-01: tabla auditoria.cambios_clientes, que permite revisar modificaciones de datos capturadas por el trigger.
- LAB-02: bitácora de mongod y colección system.profile.
- Actualmente no existe evidencia de un registro formal de solicitudes, aprobaciones, planes de reversión y validaciones posteriores de cambios en producción.

**Revisión:** 

Cada seis meses y después de incidentes o cambios importantes en la infraestructura.