# POL-03 — Política de retención y eliminación de datos

**Objetivo:** 

Evitar la conservación indefinida de información, reducir la exposición de datos personales y garantizar la disponibilidad de registros necesarios para auditorías e investigaciones.

**Alcance:**

Aplica a las bases de datos PostgreSQL y MongoDB, los registros de auditoría, las bitácoras del motor, las exportaciones y los respaldos que contengan información del proyecto.

**Regla:**
1. Los datos operativos y las bitácoras deberán conservarse de acuerdo con los periodos establecidos en el catálogo y el criterio de conservación de registros de la Actividad 5.
2. Al vencer el periodo, el responsable deberá evaluar si existe una obligación de conservación, una investigación abierta o una solicitud legal que justifique mantener la información; de no existir, deberá autorizarse su eliminación segura o anonimización.
3. Ningún registro relacionado con un incidente abierto podrá eliminarse mientras sea necesario para su investigación. La retención extraordinaria deberá estar documentada y tener una fecha de revisión.

**Responsable:** 

El propietario del dato determina la necesidad de conservación; el responsable de seguridad supervisa los registros de auditoría y el DBA ejecuta las acciones autorizadas. El área jurídica confirma las obligaciones legales aplicables.

**Excepciones:** 

Se permite ampliar temporalmente la conservación cuando exista una investigación de seguridad, auditoría o requerimiento legal. La ampliación debe ser aprobada por el responsable de seguridad y, cuando corresponda, por el área jurídica.

**Evidencia:**
- LAB-01: tabla auditoria.cambios_clientes, que contiene los valores anteriores y nuevos de las modificaciones.
- LAB-01: archivo de bitácora de PostgreSQL, identificado mediante pg_current_logfile().
- LAB-02: registros de mongod y colección system.profile.
- Actualmente no existe un registro formal de eliminación, anonimización ni vencimiento de periodos de conservación.

**Revisión:** 

Anualmente y cuando cambien las obligaciones legales, las finalidades del tratamiento o los sistemas que almacenan información.