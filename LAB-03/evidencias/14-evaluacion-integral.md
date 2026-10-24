# 20. Actividad 14 — Escenario integral

Considera la siguiente situación:

> La empresa tiene una base de datos con información de 50,000 clientes.

> Todos los empleados del área de analítica pueden consultar directamente la tabla clientes.

> La tabla contiene nombre, correo, teléfono, RFC, edad, ciudad y código postal.

> El área de analítica únicamente genera estadísticas mensuales.

> Los datos se conservan desde hace 12 años.

> No existe una política documentada de retención.

> Los desarrolladores reciben copias completas de la base de datos para realizar pruebas.

> Las copias de desarrollo contienen información real.

> El área de marketing utiliza los correos electrónicos para campañas promocionales.

> No existe documentación clara sobre qué finalidad corresponde a cada dato.

> Identifica al menos 10 problemas o riesgos.

## Matriz generada

| **Problema** | **Principio afectado** | **Riesgo** | **Control propuesto** |
|---|---|---|---|
| Todos los empleados de Analítica pueden consultar directamente la tabla `clientes`. | Limitación del acceso y confidencialidad. | Acceso innecesario a datos personales y posible divulgación no autorizada. | Crear roles y permisos específicos en PostgreSQL y conceder acceso únicamente a los datos necesarios. |
| El área de Analítica consulta nombre, correo, teléfono y RFC, aunque solo genera estadísticas mensuales. | Minimización de datos. | Exposición de información personal que no es necesaria para los análisis. | Crear vistas con información limitada, utilizando únicamente los campos necesarios para generar estadísticas. |
| Los datos se conservan desde hace 12 años sin una justificación documentada. | Limitación del plazo de conservación. | Acumulación innecesaria de información y aumento del impacto de una posible filtración. | Revisar la necesidad de conservar los registros y establecer periodos de retención justificados. |
| No existe una política documentada de retención. | Responsabilidad proactiva y limitación del plazo de conservación. | Eliminación tardía o inconsistente de los datos y falta de criterios para determinar cuándo deben eliminarse. | Documentar los periodos de conservación, las excepciones legales, los responsables y los procedimientos de eliminación. |
| Los desarrolladores reciben copias completas de la base de datos para realizar pruebas. | Minimización de datos y confidencialidad. | Exposición de información personal a personas que no necesitan acceder a ella para desarrollar o probar el sistema. | Proporcionar conjuntos de datos reducidos o sintéticos, limitando los permisos de acceso. |
| Las copias de desarrollo contienen información real de los clientes. | Privacidad por diseño y seguridad de los datos. | Filtración de datos personales en entornos con controles de seguridad posiblemente inferiores a los de producción. | Sustituir los datos reales por datos sintéticos o anonimizados antes de utilizarlos en desarrollo. |
| Marketing utiliza los correos electrónicos para campañas promocionales sin que se documente su finalidad. | Limitación de la finalidad y transparencia. | Uso de los datos para fines no informados o no justificados adecuadamente. | Documentar la finalidad de las campañas, verificar la base legal aplicable y establecer mecanismos para gestionar las preferencias y solicitudes de los clientes. |
| No existe documentación clara sobre la finalidad de cada dato. | Limitación de la finalidad y responsabilidad proactiva. | Uso de información personal para actividades incompatibles con los fines para los que fue recopilada. | Crear un inventario de datos que especifique su finalidad, responsable, usuarios autorizados y periodo de conservación. |
| El RFC está disponible para todo el personal de Analítica. | Confidencialidad y minimización de datos. | Exposición de información de identificación fiscal sin una necesidad funcional. | Restringir el acceso al RFC a los roles que lo requieran y ocultarlo en reportes analíticos. |
| Los números telefónicos están disponibles para empleados que únicamente elaboran estadísticas. | Minimización de datos y confidencialidad. | Consulta, extracción o divulgación innecesaria de información de contacto. | Excluir el teléfono de las vistas analíticas y utilizar datos agregados cuando sea suficiente. |
| No se especifican controles de auditoría sobre las consultas de los empleados. | Responsabilidad proactiva y seguridad. | Dificultad para detectar accesos indebidos, investigar incidentes y determinar quién consultó información personal. | Configurar registros de auditoría para operaciones relevantes, revisar los accesos periódicamente y establecer responsables de seguimiento. |
| No se describe un procedimiento para eliminar o anonimizar los datos que ya no son necesarios. | Limitación del plazo de conservación y minimización. | Permanencia de información personal en sistemas, copias de desarrollo, respaldos y otros repositorios sin justificación. | Definir un procedimiento de eliminación o anonimización que contemple las distintas ubicaciones de los datos y las obligaciones legales aplicables. |

## Conclusión

En el escenario analizado se presentan deficiencias importantes en el gobierno y la protección de los datos personales, principalmente por el acceso excesivo a la información, la conservación prolongada sin una política definida y el uso de datos reales en entornos de desarrollo. Estas prácticas incrementan los riesgos de acceso no autorizado, filtraciones y uso de la información para finalidades no justificadas.

Para corregir estas deficiencias es necesario aplicar controles técnicos y administrativos que en conjunto limiten los accesos según las funciones de cada área, reduzcan la cantidad de datos disponibles y  establezcan periodos de retención justificados. Asimismo, deben documentarse las finalidaes de cada tratamiento y establecerse mecanismos de auditoría y seguimiento.