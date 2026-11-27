# POL-05 — Política de uso de datos sensibles

**Objetivo:**

Reducir el riesgo de exposición, divulgación o utilización indebida de datos personales e información confidencial de clientes.

**Alcance:** 

Aplica a los datos personales almacenados en PostgreSQL y MongoDB, incluyendo nombres, correos electrónicos, teléfonos, RFC, ubicaciones y cualquier dato personal que aparezca en las bitácoras, auditorías, perfiles de consultas o respaldos.

**Regla:**
1. Únicamente los usuarios autorizados podrán consultar datos sensibles y deberán justificar su acceso mediante una finalidad operativa, administrativa, de auditoría o de investigación.
2. Los datos personales deberán limitarse a la información necesaria para cumplir la finalidad autorizada; cuando sea posible, se utilizarán vistas restringidas o información anonimizada.
3. Toda consulta o modificación de datos sensibles deberá quedar registrada cuando el mecanismo de auditoría correspondiente lo permita. El responsable de seguridad deberá revisar periódicamente estos registros.
Responsable: El propietario del dato autoriza los usos y accesos; el responsable de seguridad supervisa el cumplimiento; el DBA y el administrador de MongoDB implementan las restricciones correspondientes.

**Excepciones:**

Se permitirá el acceso extraordinario cuando sea indispensable para atender un incidente, una investigación o una obligación legal. Deberá existir autorización del responsable de seguridad y registro de la justificación.

**Evidencia:**
- LAB-01: registros de cambios en auditoria.cambios_clientes, que incluyen información anterior y nueva de los clientes.
- LAB-01: bitácora del servidor PostgreSQL con sentencias ejecutadas y datos de conexión.
- LAB-02: colección system.profile, que registra operaciones y consultas realizadas en MongoDB.
- LAB-02: instantáneas de privilegios en auditoria.instantaneas_privilegios.
- Actualmente no existe evidencia documentada de un registro formal de justificaciones para cada consulta de datos sensibles.

**Revisión:** 

Cada seis meses y cuando se incorporen nuevos tipos de datos personales o cambien las finalidades de su uso.