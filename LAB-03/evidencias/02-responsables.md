# 8. Actividad 2 — Propietarios, custodios y usuarios

## 1. Matriz de propietarios, custodios y usuarios

| **Conjunto de datos** | **Propietario** | **Custodio** | **Usuarios autorizados** | **Quién aprueba accesos** | **Quién aprueba correcciones** |
|---|---|---|---|---|---|
| `comercial.public.clientes` (PostgreSQL) | Responsable del área comercial | DBA | Personal de ventas y personal autorizado de administración | Responsable del área comercial | Responsable del área comercial, previa validación con el cliente cuando corresponda |
| `auditoria.cambios_clientes` (PostgreSQL) | Responsable de seguridad de la información o auditoría | DBA independiente de la operación comercial | Auditores y personal de seguridad autorizado | Responsable de seguridad de la información o auditoría | Responsable del área comercial, con autorización y justificación documentada; nunca se deben modificar registros históricos de auditoría para ocultar cambios |
| Bitácora de PostgreSQL | Responsable de seguridad de la información | DBA o administrador de infraestructura | Auditores, personal de seguridad y administradores autorizados | Responsable de seguridad de la información | No aplica como corrección de datos operativos; los registros deben conservarse íntegros |
| `comercial.clientes` (MongoDB) | Responsable del área comercial | Administrador de MongoDB o DBA | Personal de ventas y aplicaciones autorizadas | Responsable del área comercial | Responsable del área comercial, previa validación de la información |
| `comercial.system.profile` (MongoDB) | Responsable de seguridad de la información o auditoría | Administrador de MongoDB o DBA | Auditores, personal de seguridad y administradores autorizados | Responsable de seguridad de la información o auditoría | No aplica como corrección de datos operativos; los registros de perfilado deben conservarse según la política de retención |

## Preguntas

1. **¿Por qué el propietario de auditoria.cambios_clientes no debería ser el mismo que opera clientes?**

Porque se generaría un conflicto de intereses. Si la misma persona o área tiene control sobre los datos operativos y sobre sus registros de auditoría, podría modificar información y alterar o eliminar la evidencia de esos cambios.

Separar ambas responsabilidades permite establecer controles independientes, reducir el riesgo de manipulación y facilitar la detección de actividades indebidas. El DBA puede administrar técnicamente ambos objetos, pero no debería tener autoridad unilateral para modificar o eliminar los registros de auditoría.

2. **¿Quién debería poder leer las bitácoras y la vista dba.bitacora? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).**

El acceso debería limitarse al DBA, al personal de seguridad de la información y a los auditores autorizados, de acuerdo con sus responsabilidades. Los usuarios comerciales y las aplicaciones no necesitan consultar directamente estos registros.

En el LAB-01 se observó que las bitácoras podían registrar sentencias SQL que contenían información sensible, como contraseñas incluidas en instrucciones de administración de usuarios. Esto demuestra que los registros pueden convertirse en una fuente de exposición de información confidencial.

Por ello, se deben restringir los permisos de lectura, proteger los archivos, evitar registrar secretos cuando sea posible y establecer políticas de conservación y acceso. No basta con proteger la base de datos si las bitácoras contienen información que puede comprometer su seguridad.

3. **¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.**

Cuando ningún responsable tiene asignada la propiedad de un dato, no existe una autoridad claramente identificada para validar su calidad, aprobar correcciones o decidir quién puede acceder a él. Esto provoca que los errores permanezcan sin resolver, que diferentes áreas realicen modificaciones sin coordinación y que resulte difícil determinar quién debe responder por la información.

Esto se relaciona con el problema inicial de la unidad, donde se identificaron inconsistencias en los datos de los clientes, como registros duplicados, RFC incompletos y correos inválidos. Sin responsables definidos, el DBA puede detectar estos problemas, pero no necesariamente tiene la autoridad para decidir cómo corregirlos.

Por lo tanto, asignar propietarios y custodios permite establecer responsabilidades claras, mejorar la calidad de los datos y evitar que la información quede sin supervisión.

## Conclusión

Esta actividad permitió comprender la importancia de establecer responsabilidades claras sobre la administración y el uso de los datos dentro de una organización. Diferenciar entre propietarios, custodios y usuarios autorizados ayuda a evitar conflictos de intereses, controlar los accesos y garantizar que las correcciones sean aprobadas por las personas responsables de la información. Asimismo, se identificó que las bitácoras y los registros de auditoría requieren protección especial, ya que pueden contener información sensible y constituyen evidencia de las operaciones realizadas. En conclusión, una adecuada asignación de responsabilidades permite fortalecer la seguridad, la integridad y la calidad de los datos, evitando que su administración dependa únicamente del personal técnico.