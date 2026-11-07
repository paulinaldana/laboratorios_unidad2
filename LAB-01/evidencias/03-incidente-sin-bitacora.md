# 9. Actividad 3 — El incidente sin bitácora

## Preguntas

### **1. ¿Puedes demostrar quién modificó el RFC?**

No. Aunque se ejecutó correctamente el UPDATE, la bitácora no contiene evidencia de esa operación.

En la configuración actual:
- log_statement = none: no registra las sentencias SQL ejecutadas.
- log_connections = off: no registra las conexiones de los usuarios.
- log_line_prefix = '%m [%p]': no incluye el nombre del usuario ni la dirección IP del cliente.
Por lo tanto, no es posible identificar mediante la bitácora quién modificó el RFC.

### **2. ¿Puedes demostrar que el cambio no lo hizo soporte_ana?**

No. La ausencia de registros no demuestra que soporte_ana no haya realizado el cambio.

Aunque la operación se ejecutó utilizando las credenciales de app_ventas, eso solamente demuestra qué cuenta se utilizó en esa conexión, no qué persona estaba detrás de ella.

Para atribuir una operación a una persona se necesitarían registros de auditoría y controles adicionales que relacionaran la cuenta utilizada con el responsable.

### **3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?**

No. Los privilegios no impidieron la modificación porque el usuario app_ventas tenía permisos suficientes para ejecutar la sentencia UPDATE sobre la tabla clientes.

Esto no necesariamente representa un error: si la aplicación de ventas necesita actualizar los RFC de sus clientes como parte de sus funciones, debe contar con ese permiso.

Sin embargo, los privilegios deberían seguir el principio de mínimo privilegio: cada usuario debe tener únicamente los permisos necesarios para cumplir sus responsabilidades.

Es importante distinguir entre dos objetivos:
- Control de acceso: determina quién puede realizar una operación.
- Auditoría: permite registrar quién ejecutó una operación y cuándo ocurrió.

Una cosa no sustituye a la otra.

### **4. ¿Qué tendría que haber estado configurado antes del incidente?**

Para poder reconstruir lo ocurrido, PostgreSQL tendría que haber contado previamente con mecanismos de registro y auditoría.

Por ejemplo:
1. logging_collector = on: para que PostgreSQL administre sus propios archivos de bitácora.
2. log_connections = on: para registrar las conexiones de los usuarios.
3. log_disconnections = on: para registrar las desconexiones.
4. log_statement = 'mod': para registrar sentencias que modifican datos, como INSERT, UPDATE, DELETE y TRUNCATE.
5. log_line_prefix con %u, %d, %h y %a: para identificar usuario, base de datos, dirección del cliente y aplicación.
6. Un mecanismo de auditoría con mayor detalle, como la extensión pgAudit, si se necesita registrar eventos y operaciones específicas.

Además, los registros deberían conservarse de forma segura, con acceso restringido y políticas de retención adecuadas.

## Conclusión
El incidente demuestra que los privilegios de acceso, aunque permiten controlar las operaciones autorizadas, no garantizan la trazabilidad de los cambios realizados. En este caso, el usuario app_ventas pudo modificar el RFC del cliente porque contaba con los permisos necesarios; sin embargo, debido a que la configuración de registro no contemplaba las conexiones ni las sentencias de modificación, no existe evidencia suficiente en la bitácora para identificar quién realizó el cambio. Por ello, los mecanismos de auditoría deben configurarse antes de que ocurra un incidente, ya que no es posible reconstruir retroactivamente información que nunca fue registrada.

Una precisión técnica: aunque log_statement = 'mod' habría permitido registrar el UPDATE, por sí solo no constituye una auditoría completa ni demuestra la identidad de la persona que utilizó la cuenta. Para eso también se necesitan controles sobre las credenciales y una adecuada protección de los registros.