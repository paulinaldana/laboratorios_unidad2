# 11. Actividad 5 — Criterio de conservación de bitácoras

## Tabla de criterios de conservación

| Registro | Ubicación actual | Riesgo de pérdida observado | Sensibilidad | Periodo propuesto | Justificación | Dónde se conserva | Quién puede leerlo | Acción al vencer |
|---|---|---|---|---|---|---|---|---|
| Accesos de PostgreSQL | Archivo del colector (`pg_current_logfile()`) | Rotación del archivo; reinstalación o recreación del servidor | Alta | 12 meses | Permite investigar accesos no autorizados, intentos fallidos y actividad de usuarios. Su utilidad es importante para detectar incidentes, aunque no todos los accesos requieren conservación prolongada. | Repositorio central de bitácoras, separado del servidor PostgreSQL | DBA y personal autorizado de seguridad | Eliminación segura; conservar únicamente estadísticas anonimizadas si son necesarias. |
| Cambios de privilegios y estructura | Archivo del colector | Rotación, eliminación de archivos o pérdida del servidor | Alta | 24 meses | Los cambios de roles, permisos, objetos y estructuras pueden alterar la seguridad de todo el sistema. Es importante conservar evidencia suficiente para investigar modificaciones indebidas y determinar responsabilidades. | Repositorio central de bitácoras con protección contra modificaciones | DBA y responsable de seguridad; auditoría con autorización | Eliminación segura al vencer el plazo, salvo investigación o retención autorizada pendiente. |
| Modificaciones de datos (`log_statement = 'mod'`) | Archivo del colector | Rotación del archivo; reinstalación o recreación del servidor | Alta | 12 meses | Permite reconstruir operaciones de inserción, actualización y eliminación. Puede registrar valores personales e incluso información sensible incluida en las sentencias SQL. | Repositorio central de bitácoras con acceso restringido | DBA y personal de auditoría autorizado | Eliminar de forma segura o anonimizar los registros que deban conservarse con fines estadísticos. |
| `auditoria.cambios_clientes` | Tabla en `comercial` | Eliminación de la base de datos, manipulación de registros o desactivación del trigger de auditoría | Alta; contiene datos personales | 24 meses | Conserva evidencia estructurada de las operaciones INSERT, UPDATE y DELETE, incluyendo valores anteriores y nuevos. Es útil para investigar modificaciones, pero requiere controlar la información personal almacenada. | Base de auditoría y repositorio externo protegido contra modificaciones | Responsable de auditoría y DBA autorizado; no usuarios ordinarios de ventas | Eliminar o anonimizar los datos personales cuando corresponda; conservar solo la evidencia mínima permitida por la política y las obligaciones aplicables. |
| Bitácora de `mongod` | `systemLog.path` o salida estándar; `getLog` solo en memoria | Rotación, reinicio del servicio o pérdida del archivo. `getLog` no constituye almacenamiento histórico permanente. | Alta | 12 meses | Registra eventos operativos, errores, conexiones y situaciones relevantes para investigar fallas o incidentes de seguridad. | Repositorio central de bitácoras, separado del servidor MongoDB | Administrador de MongoDB y personal autorizado de seguridad | Eliminación segura; conservar métricas anonimizadas cuando sean necesarias. |
| `system.profile` | Colección limitada de 1 MB | Se sobrescribe sola al alcanzar su límite | Alta; puede contener consultas y valores personales | 30 días | Su finalidad principal es diagnosticar el rendimiento. Puede revelar consultas, identificadores y datos personales, por lo que no justifica una conservación prolongada. | Colección temporal y exportación controlada de eventos relevantes a un repositorio restringido | Administrador de MongoDB y personal técnico autorizado | Eliminar los registros vencidos y las exportaciones que ya no sean necesarias. |
| Instantáneas de privilegios (MongoDB) | `auditoria.instantaneas_privilegios` | Eliminación o modificación de la colección; pérdida de la base de datos | Alta | 24 meses | Permiten comparar los permisos en distintos momentos e identificar cambios de roles o privilegios que podrían comprometer la seguridad. | Repositorio de auditoría separado y protegido contra modificaciones | Administrador de seguridad, auditoría y DBA autorizado | Eliminar de forma segura al vencer el plazo, excepto cuando exista una investigación o retención autorizada. |

## Preguntas

1. **¿Por qué la bitácora de cambios de privilegios merece más tiempo de conservación que la de consultas rutinarias?**

Porque los cambios de privilegios pueden modificar quién tiene acceso a la información y qué operaciones puede realizar dentro del sistema. Una modificación indebida de permisos puede facilitar accesos no autorizados, alterar datos o incluso permitir que alguien desactive los mecanismos de auditoría.

Por eso, conservar estos registros durante más tiempo permite investigar incidentes que podrían descubrirse meses después. En cambio, las consultas rutinarias suelen tener menor valor para investigaciones prolongadas y pueden contener datos personales, por lo que su conservación debe limitarse a lo necesario.

2. **¿Qué control de integridad aplicarás a las bitácoras exportadas?**

Aplicaría un mecanismo de hashes criptográficos, como SHA-256, para generar una huella digital de cada archivo exportado. También conservaría el hash, la fecha de exportación, el origen y la persona responsable de realizarla en un registro separado.

De esta manera, si alguien modifica el archivo posteriormente, se puede comparar su hash actual con el original y detectar la alteración. Además, almacenaría las exportaciones en un repositorio con permisos restringidos y protección contra modificaciones o eliminaciones no autorizadas.

Es importante aclarar que un hash por sí solo no impide que alguien modifique un archivo y genere otro hash. Por eso, el registro original de las huellas también debe protegerse.

3. **¿Qué diferencia hay entre conservar una bitácora y respaldar una base de datos?**

Conservar una bitácora significa mantener evidencia histórica de las actividades realizadas en un sistema, como accesos, modificaciones, errores y cambios de privilegios. Su finalidad principal es permitir auditorías e investigaciones de incidentes.

Respaldar una base de datos significa generar una copia de la información y, según el tipo de respaldo, de los elementos necesarios para recuperar el sistema ante una pérdida, corrupción o falla.

Por lo tanto, son mecanismos complementarios, pero no equivalentes: una bitácora permite conocer qué ocurrió, mientras que un respaldo permite recuperar información. Tener una copia de seguridad no garantiza que exista evidencia histórica suficiente para investigar las operaciones realizadas.

## Conclusión

La actividad permitió establecer que la conservación de bitácoras debe responder a la finalidad de cada registro, su sensibilidad y su utilidad para investigar incidentes de seguridad. Se propusieron periodos diferenciados para los registros de accesos, modificaciones, auditoría y perfilado, considerando que no todos requieren conservarse durante el mismo tiempo. También se identificó la importancia de proteger las exportaciones mediante hashes criptográficos, restringir su acceso y almacenarlas fuera del servidor de origen. Finalmente, se reconoció que la conservación de evidencias debe equilibrarse con la protección de datos personales: mantener una auditoría no justifica conservar indefinidamente información personal que ya no sea necesaria.

Una observación que no debes pasar por alto: en el LAB-01 se observó que las sentencias registradas podían incluir contraseñas y otros valores sensibles. Por tanto, no basta con definir cuánto tiempo conservar los archivos: también debes considerar qué información se registra, quién puede consultarla y cómo se evita exponer secretos. Además, el caso de auditoria.cambios_clientes presenta un conflicto real entre conservar los valores anteriores y nuevos para fines de auditoría y cumplir con la eliminación de datos personales. La solución no debe ser conservarlos indefinidamente, sino definir qué evidencia mínima puede mantenerse y cuándo corresponde anonimizar o eliminar los datos personales.