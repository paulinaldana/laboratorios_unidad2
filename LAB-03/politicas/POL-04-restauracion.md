# POL-04 — Política de restauración de información

**Objetivo:** 

Reducir el riesgo de pérdida prolongada de información y evitar restauraciones no autorizadas que provoquen inconsistencias o sobrescritura de datos válidos.

**Alcance:** 

Aplica a las bases de datos PostgreSQL y MongoDB, sus respaldos, tablas de auditoría y colecciones relacionadas con la operación.

**Regla:**
1. Toda restauración deberá contar con una solicitud documentada que indique el sistema afectado, la causa, la información que se necesita recuperar y el momento al que se desea regresar.
2. El propietario del dato y el responsable de seguridad deberán autorizar la restauración antes de su ejecución, salvo una emergencia que requiera autorización extraordinaria documentada.
3. Después de restaurar, el DBA o administrador responsable deberá verificar la integridad de la información y documentar los resultados antes de permitir nuevamente su uso operativo.
Responsable: El propietario del dato y el responsable de seguridad autorizan la restauración; el DBA o administrador de MongoDB la ejecuta y verifica.

**Excepciones:** 

En caso de una falla crítica que interrumpa la operación, el responsable de seguridad podrá autorizar una restauración de emergencia. La justificación y las validaciones posteriores deberán documentarse.

**Evidencia:**
- Actualmente no existe evidencia de solicitudes de restauración, autorizaciones ni pruebas de recuperación en los LAB-01 a LAB-03.
- Se deberá mantener un registro de solicitudes, aprobaciones, ejecución, validaciones y resultados de cada restauración.

**Revisión:** 

Anualmente y después de cada restauración o incidente que evidencie deficiencias en el proceso.

*El procedimiento técnico se definirá en la Unidad V.*