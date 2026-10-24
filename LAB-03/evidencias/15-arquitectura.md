# 21. Actividad 15 — Propuesta de arquitectura de datos protegidos

## 1. Propuesta conceptual

- **Base de datos**
  - **Operación**
    - Datos necesarios para atender a los clientes.
    - Acceso restringido mediante roles y permisos.
  - **Analítica**
    - Datos mínimos y agregados para generar reportes.
    - Uso de vistas limitadas y anonimización cuando corresponda.
  - **Auditoría**
    - Registros de accesos y cambios relevantes.
    - Acceso exclusivo para personal autorizado.

- **Gobierno y protección de datos**
  - **Acceso:** permisos según las funciones de cada usuario.
  - **Minimización:** recopilación y uso únicamente de los datos necesarios.
  - **Protección de información sensible:** restricciones de acceso, cifrado y ocultamiento de datos cuando corresponda.
  - **Retención:** periodos de conservación definidos y justificados.
  - **Trazabilidad:** registro y revisión de operaciones relevantes.
  - **Eliminación:** procedimientos controlados para eliminar o anonimizar datos.
  - **Atención de solicitudes:** procedimientos para gestionar solicitudes ARCO.

## 2. Controles propuestos

- **Acceso:** crear roles y permisos específicos para cada área, de modo que cada usuario consulte únicamente la información necesaria para sus funciones.
- **Minimización:** separar los datos operativos de los analíticos y utilizar vistas que expongan solo los campos necesarios para generar estadísticas.
- **Protección de información sensible:** restringir el acceso a datos como el RFC, correo y teléfono; aplicar cifrado cuando corresponda y ocultar identificadores en los reportes.
- **Retención:** definir periodos de conservación según la finalidad de cada dato y las obligaciones legales aplicables.
- **Trazabilidad:** registrar accesos y operaciones relevantes, identificar a los usuarios responsables y revisar los registros periódicamente.
- **Eliminación:** establecer procedimientos para eliminar o anonimizar los datos cuando dejen de ser necesarios, considerando también respaldos y copias.
- **Atención de solicitudes:** definir un procedimiento para localizar los datos de una persona y gestionar solicitudes de acceso, rectificación, cancelación y oposición (ARCO), según corresponda.

## 3. Funcionamiento de la arquitectura
- ***Operación:*** conserva los datos necesarios para identificar a los clientes, atender sus solicitudes y realizar las actividades propias del servicio.
- ***Analítica:*** utiliza información limitada, preferentemente agregada o anonimizada, para elaborar estadísticas sin exponer innecesariamente datos personales.
- ***Auditoría:*** conserva registros de actividades relevantes para supervisar accesos, detectar posibles incidentes y facilitar investigaciones. Estos registros también deben tener acceso y retención controlados.


Las tres áreas deben contar con permisos independientes y reglas documentadas. La separación lógica mediante esquemas, vistas y roles de PostgreSQL puede ser suficiente para un diseño inicial; no es obligatorio utilizar bases de datos físicas diferentes. Además, los datos agregados no siempre son anónimos: si permiten identificar a una persona, deben continuar protegidos.

## 4. Conclusión
La arquitectura propuesta traduce los principios de privacidad en decisiones concretas de diseño, separando la información según su finalidad y limitando el acceso a los datos personales. La implementación de roles, vistas restringidas, controles de retención, auditoría y procedimientos de eliminación permite reducir la exposición innecesaria de información y mejorar su administración. De esta manera, la organización puede realizar sus operaciones y análisis sin otorgar acceso indiscriminado a los datos de sus clientes, manteniendo la protección durante todo su ciclo de vida.