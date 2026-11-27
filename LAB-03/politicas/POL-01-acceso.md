## POL-01 — Política de control de acceso

**Objetivo:** 

Reducir el riesgo de accesos no autorizados, uso indebido de información y asignación excesiva de privilegios en los sistemas de bases de datos.

**Alcance:**

Aplica a PostgreSQL 16 y MongoDB 7, incluyendo las bases de datos, colecciones, tablas, esquemas, bitácoras y ambientes definidos para el proyecto.

**Regla:**
1. Toda solicitud de acceso debe identificar al usuario, los recursos requeridos, los privilegios necesarios y la justificación de negocio.
2. El propietario del dato debe aprobar o rechazar la solicitud; el DBA o administrador correspondiente ejecuta los cambios autorizados.
3. El responsable de seguridad y el DBA deben revisar trimestralmente los privilegios asignados y retirar aquellos que ya no estén justificados.
Responsable: El propietario del dato decide y autoriza; el DBA de PostgreSQL o administrador de MongoDB ejecuta los cambios. El responsable de seguridad supervisa las revisiones.

**Excepciones:** 

Los accesos de emergencia pueden otorgarse temporalmente cuando exista un incidente que afecte la operación o seguridad. Deben ser autorizados por el responsable de seguridad y documentados posteriormente.

**Evidencia:**
- LAB-01: bitácora de PostgreSQL con intentos de autenticación y sentencias de cambios de privilegios (GRANT y REVOKE), cuando estén registradas.
- LAB-02: instantáneas de privilegios de MongoDB en auditoria.instantaneas_privilegios.
- Actualmente no existe evidencia documentada de una revisión trimestral de privilegios ni un registro formal completo de solicitudes y aprobaciones.

**Revisión:** 

Cada seis meses o cuando cambien los responsables, sistemas o requisitos de acceso.