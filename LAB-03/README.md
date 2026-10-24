# Informe final

## 1. Introducción

La protección de datos personales es un aspecto fundamental en el
diseño, implementación y administración de bases de datos. Una
organización puede contar con mecanismos técnicos de seguridad y, aun
así, poner en riesgo la privacidad si recopila información innecesaria,
permite accesos excesivos, conserva datos indefinidamente o los utiliza
para finalidades que no han sido debidamente justificadas.

En las actividades realizadas se analizó una base de datos de clientes
que contiene información personal, como nombre, correo electrónico,
teléfono, RFC, edad, ciudad y código postal. Se identificaron riesgos
relacionados con los permisos de acceso, el uso de información en
actividades de analítica, la conservación de datos durante periodos
prolongados, las copias utilizadas en desarrollo y la falta de políticas
documentadas.

El objetivo del informe es proponer medidas técnicas y administrativas
que permitan proteger los datos personales durante todo su ciclo de
vida, desde su recopilación hasta su eliminación, considerando los
principios de minimización, limitación de la finalidad,
confidencialidad, privacidad por diseño y responsabilidad proactiva.

## 2. Inventario de datos

Los datos identificados se clasifican de acuerdo con su naturaleza, su finalidad y el nivel de protección que requieren.

| **Dato** | **Clasificación** | **Sensibilidad y consideraciones** |
|---|---|---|
| Nombre | Dato personal identificativo | Permite identificar a un cliente y debe protegerse frente a accesos no autorizados. |
| Correo electrónico | Dato personal de contacto | Puede utilizarse para comunicación y, bajo condiciones justificadas, para campañas promocionales. |
| Teléfono | Dato personal de contacto | Debe limitarse a los usuarios que necesiten contactar al cliente. |
| RFC | Dato personal de identificación fiscal | Requiere acceso restringido cuando se utiliza en procesos fiscales o administrativos. |
| Edad | Dato personal | Puede utilizarse para análisis estadísticos cuando exista una finalidad justificada. |
| Ciudad | Dato de ubicación general | Puede utilizarse para análisis geográficos y estadísticas de distribución de clientes. |
| Código postal | Dato de ubicación | Puede contribuir a identificar zonas geográficas y, combinado con otros datos, aumentar el riesgo de identificación. |
| Dirección | Dato personal de ubicación | Debe recopilarse cuando sea necesaria para prestar un servicio, realizar entregas o cumplir otra finalidad justificada. |
| Fecha de nacimiento | Dato personal | Puede ser necesaria para verificar requisitos de edad, pero no debe recopilarse automáticamente. |
| Ocupación | Dato personal relacionado con actividad laboral | Requiere una finalidad concreta que justifique su recopilación. |
| Salario | Dato personal de carácter económico | Puede revelar información financiera y requiere una justificación y protección adecuadas. |
| Estado civil | Dato personal sobre situación familiar | Debe recopilarse únicamente cuando exista una necesidad específica y legítima. |

La clasificación debe servir para definir los permisos, las medidas de protección y los periodos de conservación. No todos los datos personales tienen el mismo nivel de riesgo, y la sensibilidad depende también del contexto, de las combinaciones posibles y de las consecuencias de una exposición.

## 3. Finalidades

Cada dato debe utilizarse para una finalidad específica, informada y justificada. No es suficiente conservar información bajo el argumento de que podría ser útil en el futuro.

| **Área** | **Finalidad** | **Datos necesarios según la actividad** |
|---|---|---|
| Atención al cliente | Identificar al cliente, responder consultas y dar seguimiento a solicitudes. | Nombre, correo y teléfono cuando sean necesarios. |
| Facturación  | Gestionar procesos fiscales y emitir comprobantes cuando corresponda. | Nombre y RFC, además de los datos fiscales requeridos. |
| Analítica  | Elaborar estadísticas mensuales y analizar tendencias de clientes. | Datos agregados o información mínima pertinente para cada análisis. |
| Desarrollo  | Probar funcionalidades, corregir errores y verificar el funcionamiento de la aplicación. | Preferentemente datos sintéticos; datos reales solo si existe una necesidad justificada y controles adecuados. |
| Auditoría  | Registrar y revisar actividades relevantes para detectar accesos indebidos e investigar incidentes. | Identificador del usuario, operación realizada, fecha y otros metadatos necesarios. |
| Marketing  | Gestionar comunicaciones promocionales cuando exista una base legal apropiada. | Correo electrónico y preferencias de comunicación, según corresponda. |

La organización debe evaluar si cada uso es compatible con la finalidad original y si cumple las obligaciones aplicables. En particular, el uso de correos electrónicos para marketing no debe asumirse automáticamente autorizado por el hecho de que estén almacenados en la base de datos.

## 4. Minimización

El principio de minimización establece que los datos personales deben ser adecuados, pertinentes y limitados a lo necesario para cumplir con la finalidad correspondiente.

En el escenario analizado, el área de analítica genera estadísticas mensuales, por lo que no necesita necesariamente acceder a todos los datos identificativos de los clientes.

| Dato | Medida propuesta | Justificación |
|---|---|---|
| Nombre | Excluir de los reportes estadísticos cuando no sea necesario. | Las estadísticas normalmente no requieren identificar a cada cliente. |
| Correo | Restringir al área que gestiona comunicaciones autorizadas. | No es necesario para la mayoría de los análisis agregados. |
| Teléfono | Excluir de las vistas analíticas. | No contribuye directamente a las estadísticas generales. |
| RFC | Restringir al personal que realiza actividades fiscales autorizadas. | Es un identificador fiscal que no necesita utilizarse en estadísticas ordinarias. |
| Edad | Utilizar rangos de edad cuando sean suficientes. | Reduce el detalle individual sin perder necesariamente utilidad estadística. |
| Ciudad | Conservar cuando sea relevante para los análisis geográficos. | Permite estudiar la distribución de clientes por localidad. |
| Código postal | Limitar el detalle geográfico cuando no sea necesario. | Puede sustituirse por agrupaciones territoriales para reducir el riesgo de identificación. |
| Dirección | No recopilar si no se necesita para prestar el servicio. | Evita almacenar información de ubicación detallada sin justificación. |
| Fecha de nacimiento | Recopilar únicamente cuando sea necesaria. | Puede ser suficiente conocer una condición de edad sin conservar la fecha completa. |
| Ocupación | Excluir si no existe una finalidad concreta. | Evita recopilar información laboral innecesaria. |
| Salario | Excluir si no se requiere para un servicio específico. | Reduce la exposición de información económica. |
| Estado civil | Excluir si no es necesario para la finalidad del servicio. | Evita conservar información personal sin utilidad demostrada. |

La minimización también debe aplicarse a las copias de bases de datos. Los desarrolladores deberían utilizar datos sintéticos o conjuntos reducidos y adecuadamente protegidos, en lugar de recibir automáticamente copias completas de producción.

## 5. Control de acceso

El control de acceso debe basarse en el principio de mínimo privilegio: cada usuario debe tener únicamente los permisos necesarios para cumplir sus responsabilidades.

Se propone establecer roles diferenciados en PostgreSQL y evitar que todos los empleados tengan acceso directo a la tabla completa clientes.

| Rol | Permisos propuestos | Restricciones |
|---|---|---|
| Atención al cliente | Consultar y actualizar los datos necesarios para atender solicitudes. | Sin acceso general a datos fiscales o económicos que no requiera su función. |
| Facturación | Consultar y utilizar los datos requeridos para procesos fiscales. | Sin acceso general a información ajena a sus actividades. |
| Analítica | Consultar vistas con datos mínimos, agregados o anonimizados. | Sin acceso directo a identificadores personales cuando no sean necesarios. |
| Desarrolladores | Acceder a entornos de prueba con datos sintéticos. | Sin copias completas de producción por defecto. |
| DBA | Administrar estructuras, permisos, respaldos y disponibilidad de la base de datos. | El acceso a los datos personales debe estar justificado y controlado. |
| Dirección | Consultar indicadores y reportes necesarios para la toma de decisiones. | Sin acceso general a registros personales individuales por defecto. |
| Auditoría | Consultar los registros necesarios para revisar operaciones e investigar incidentes. | Acceso restringido según las responsabilidades asignadas. |

Los permisos deben implementarse mediante roles, privilegios sobre tablas y vistas, y controles adicionales cuando sean necesarios. También deben revisarse periódicamente y revocarse cuando cambien las funciones de un empleado.

El DBA puede administrar técnicamente los permisos, pero las áreas responsables deben determinar qué accesos requiere cada función. La administración de la base de datos no implica autorización automática para utilizar cualquier dato personal.

## 6. Derechos ARCO

Los derechos ARCO corresponden a los derechos de acceso, rectificación, cancelación y oposición al tratamiento de datos personales, conforme al marco jurídico aplicable.

Su atención tiene implicaciones técnicas porque la información de una persona puede estar distribuida en diferentes tablas, respaldos, réplicas, reportes, exportaciones y sistemas externos.

| Derecho | Implicación técnica |
|---|---|
| Acceso | Localizar los datos personales de la persona y proporcionar la información que corresponda mediante un procedimiento seguro. |
| Rectificación | Identificar los registros afectados y actualizar los datos incorrectos en los sistemas correspondientes. |
| Cancelación | Identificar dónde se encuentran los datos y aplicar las medidas de cancelación, bloqueo o eliminación que correspondan legalmente. |
| Oposición | Identificar los tratamientos afectados y detener o limitar aquellos a los que proceda la oposición, conforme a las condiciones legales aplicables. |

Para atender estas solicitudes, la organización necesita un inventario de datos, identificadores que permitan localizar registros, procedimientos documentados y mecanismos para verificar que las acciones se hayan completado.

La cancelación no implica necesariamente borrar de inmediato todos los registros. Algunos datos pueden estar sujetos a obligaciones legales de conservación, mientras que otros pueden permanecer temporalmente en respaldos sujetos a controles. Estas excepciones deben justificarse y gestionarse conforme a las disposiciones aplicables.

## 7. Retención

La retención debe determinarse de acuerdo con la finalidad del tratamiento, las necesidades operativas y las obligaciones legales aplicables. No resulta suficiente justificar la conservación indefinida con la posibilidad de que los datos sean útiles en el futuro.

La organización debería:

1. Identificar la finalidad de cada categoría de datos.
2. Determinar durante cuánto tiempo es necesario conservarla para esa finalidad.
3. Verificar las obligaciones legales, fiscales o contractuales que establezcan periodos de conservación.
4. Documentar el periodo seleccionado y su justificación.
5. Asignar responsables para revisar y aplicar la política.
6. Establecer procedimientos de eliminación o anonimización al finalizar el periodo.
7. Considerar respaldos, réplicas, exportaciones y sistemas externos.
8. Revisar periódicamente si los periodos continúan siendo necesarios.

Por ejemplo, los datos de contacto pueden dejar de ser necesarios para la atención cotidiana cuando termina una relación con el cliente, pero determinados registros fiscales podrían requerir una conservación adicional. Por ello, los periodos deben establecerse por categoría de información y finalidad, sin aplicar una regla idéntica a todos los datos.

## 8. Gobierno de datos

La matriz de gobierno de datos establece las responsabilidades, los permisos, las medidas de protección y los criterios de conservación de cada campo.

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
|---|---|---|---|---|---|---|
| Nombre | Identificación y atención al cliente. | Atención al cliente | Atención al cliente; Analítica si está justificado. | Acceso restringido y ocultamiento en reportes cuando corresponda. | Según la finalidad y las obligaciones aplicables. | Eliminar o anonimizar cuando corresponda. |
| Correo | Comunicación con el cliente. | Atención al cliente | Personal autorizado para comunicaciones. | Acceso restringido y protección en reportes. | Mientras sea necesario y durante cualquier periodo adicional justificado. | Eliminar o anonimizar cuando corresponda. |
| Teléfono | Contacto y seguimiento. | Atención al cliente | Personal que necesite contactar al cliente. | Acceso restringido y visualización parcial cuando sea suficiente. | Según la necesidad de contacto y las obligaciones aplicables. | Eliminar o anonimizar cuando corresponda. |
| RFC | Identificación fiscal y facturación. | Facturación | Personal autorizado de facturación; DBA para tareas técnicas justificadas. | Acceso restringido y cifrado cuando corresponda. | Según las obligaciones fiscales aplicables. | Eliminar o bloquear conforme a los requisitos legales. |
| Edad | Análisis estadístico. | Analítica | Analítica con acceso limitado. | Preferencia por rangos y datos agregados. | Mientras exista una finalidad analítica justificada. | Eliminar o anonimizar cuando corresponda. |
| Ciudad | Análisis geográfico. | Analítica | Analítica y personal autorizado que lo necesite. | Acceso controlado y agregación en reportes. | Según la finalidad correspondiente. | Eliminar o anonimizar cuando corresponda. |
| Código postal | Análisis geográfico o validación de domicilio. | Atención al cliente | Atención al cliente; Analítica si es necesario. | Acceso restringido y agrupación geográfica cuando sea suficiente. | Según la finalidad correspondiente. | Eliminar o anonimizar cuando corresponda. |

La responsabilidad del gobierno de datos debe compartirse entre las áreas que definen las finalidades, los responsables de privacidad, el área jurídica y los equipos técnicos. La matriz debe revisarse cuando cambien las actividades, los sistemas o las obligaciones aplicables.

## 9. Evaluación integral

Los principales riesgos identificados durante las actividades se resumen en la siguiente tabla.

| Problema o riesgo | Principio afectado | Control propuesto |
|---|---|---|
| Acceso generalizado a la tabla clientes. | Confidencialidad y mínimo privilegio. | Roles y permisos específicos en PostgreSQL. |
| Acceso de Analítica a datos que no necesita. | Minimización. | Vistas con campos limitados y datos agregados. |
| Conservación de información durante 12 años sin justificación documentada. | Limitación del plazo de conservación. | Política de retención basada en finalidades y obligaciones legales. |
| Ausencia de una política documentada de retención. | Responsabilidad proactiva. | Definir periodos, responsables, excepciones y procedimientos. |
| Copias completas de producción para desarrollo. | Minimización y seguridad. | Entornos de prueba con datos sintéticos o conjuntos reducidos. |
| Uso de datos reales en pruebas. | Privacidad por diseño. | Sustitución de datos reales por datos sintéticos o debidamente anonimizados. |
| Uso de correos para marketing sin una finalidad documentada. | Limitación de la finalidad y transparencia. | Documentar el tratamiento y verificar la base legal aplicable. |
| Falta de documentación sobre las finalidades de cada dato. | Responsabilidad proactiva. | Inventario de datos y registro de finalidades. |
| Acceso innecesario a identificadores fiscales y datos de contacto. | Minimización y confidencialidad. | Restricción de permisos y ocultamiento de campos. |
| Ausencia de auditoría suficiente. | Seguridad y responsabilidad proactiva. | Registro y revisión de accesos y operaciones relevantes. |
| Falta de procedimientos para eliminar o anonimizar información. | Limitación del plazo de conservación. | Procedimiento de eliminación que contemple los distintos repositorios. |
| Falta de un procedimiento técnico para solicitudes ARCO. | Protección de los derechos de los titulares. | Flujo documentado para localizar, corregir, cancelar o limitar el tratamiento de datos cuando corresponda. |

La evaluación muestra que los riesgos no dependen únicamente de vulnerabilidades técnicas. También surgen de decisiones administrativas deficientes, finalidades poco claras y ausencia de procedimientos. Por ello, la solución requiere combinar controles tecnológicos con políticas, responsabilidades y mecanismos de supervisión.

## 10. Conclusiones
Las actividades permitieron comprender que la administración de bases de datos no consiste únicamente en garantizar que la información esté disponible y funcione correctamente, sino también en asegurar que los datos personales se recopilen, utilicen, almacenen y eliminen de manera justificada y segura.

Uno de los principales aprendizajes es que una base de datos puede contar con contraseñas, cifrado y controles de acceso, pero seguir presentando problemas de privacidad si conserva información innecesaria, permite usos no justificados o carece de periodos de retención definidos. Por esta razón, la seguridad técnica y la privacidad deben abordarse de manera conjunta.

También se identificó la importancia del principio de mínimo privilegio, la separación de los datos según su finalidad y el uso de vistas limitadas para evitar que todas las áreas tengan acceso a la información completa de los clientes. De igual forma, las copias de desarrollo, los respaldos, los registros de auditoría y las exportaciones deben formar parte de la estrategia de protección, ya que los datos personales pueden permanecer en diferentes ubicaciones.

Finalmente, el gobierno de datos requiere una colaboración entre los responsables del tratamiento, el área de privacidad, el área jurídica, los propietarios de los datos y el DBA. Cada uno debe asumir responsabilidades específicas para que los controles técnicos respondan a necesidades reales y a obligaciones documentadas.

En conclusión, una administración responsable de bases de datos debe proteger tanto la información como la privacidad de las personas a quienes pertenece. Esto se logra mediante la combinación de controles técnicos, políticas claras, acceso limitado, retención justificada, trazabilidad y procedimientos que permitan ejercer los derechos de los titulares.


# Preguntas de reflexión
### **1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?**

No. Una base de datos puede contar con cifrado, contraseñas seguras, respaldos y controles de acceso, pero incumplir principios de privacidad si recopila datos innecesarios, los utiliza para finalidades no justificadas o los conserva indefinidamente. La seguridad protege la información frente a amenazas, mientras que la privacidad también regula por qué, para qué y durante cuánto tiempo se utilizan los datos personales.

### **2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?**
Porque limita el acceso de cada usuario a la información que realmente necesita para cumplir sus funciones. Esto reduce la exposición innecesaria de datos personales, las posibilidades de uso indebido y el impacto de una cuenta comprometida. Por ejemplo, el área de Analítica puede generar estadísticas mediante vistas limitadas sin consultar nombres, teléfonos o RFC cuando estos datos no sean necesarios.

### **3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?**

Porque la finalidad del tratamiento corresponde a las decisiones del responsable del tratamiento y debe definirse considerando las necesidades del negocio, las obligaciones legales y los derechos de los titulares. El DBA es responsable de implementar y administrar controles técnicos, pero no debe decidir unilateralmente para qué se recopila o utiliza la información. Su función es garantizar que la estructura y los permisos de la base de datos respondan a las finalidades autorizadas.

### **4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?**
Porque las bases de datos de producción pueden contener información personal, fiscal, económica y de contacto que no es necesaria para desarrollar o probar una aplicación. Entregar copias completas aumenta la cantidad de personas y entornos con acceso a esos datos. Es preferible utilizar datos sintéticos o conjuntos reducidos, y permitir excepciones únicamente cuando exista una necesidad justificada y controles adecuados.

### **5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?**
Porque puede conservar los mismos datos personales que la base de datos original y quedar expuesta a través de permisos excesivos, equipos menos protegidos, exportaciones o accesos no autorizados. Aunque se utilice exclusivamente para pruebas, sigue conteniendo información que requiere protección. Por ello, deben aplicarse medidas de minimización, control de acceso, seguridad y eliminación también en los entornos de desarrollo.
### **6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?**
Porque la protección de los datos no termina cuando se recopilan o almacenan. La organización debe determinar cuánto tiempo necesita conservarlos y qué debe hacer cuando dejan de ser necesarios. Una política de retención evita la acumulación indefinida de información, reduce riesgos de exposición y establece procedimientos para eliminar o anonimizar datos, considerando las obligaciones legales de conservación que puedan existir.
### **7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?**
La privacidad por diseño consiste en considerar la protección de los datos desde las primeras decisiones de desarrollo. En el diseño de bases de datos se refleja en la selección de campos necesarios, la separación de información por finalidad, el uso de roles y vistas, la protección de datos sensibles y la definición de mecanismos de retención y eliminación. De esta forma, la privacidad se incorpora a la arquitectura y no se deja como una medida correctiva posterior.
### **8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?**
Implementaría los siguientes controles:
- Roles y permisos: limitar el acceso según las funciones de cada usuario.
- Vistas restringidas: mostrar únicamente los campos necesarios para cada actividad.
- Cifrado: proteger los datos en tránsito y, cuando corresponda, en almacenamiento.
- Autenticación segura: utilizar mecanismos de autenticación adecuados para los usuarios autorizados.
- Auditoría: registrar y revisar accesos y operaciones relevantes.
- Datos sintéticos: evitar el uso de información real en pruebas cuando no sea necesaria.
- Retención automatizada: aplicar procedimientos controlados de eliminación cuando se cumplan los criterios establecidos.
- Respaldos protegidos: restringir el acceso y establecer periodos de conservación para las copias de seguridad.
- Enmascaramiento: ocultar datos identificativos cuando no sea necesario visualizarlos completos.
Estos controles deben complementarse con políticas documentadas y revisiones periódicas para comprobar su efectividad.

### **9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?**
El DBA debería conocer la estructura de la base de datos, las tablas y relaciones existentes, los identificadores utilizados para localizar registros, los permisos de acceso y los sistemas donde se almacenan copias de información. También debería conocer los procedimientos de respaldo, las réplicas, las exportaciones, los registros de auditoría y las dependencias con sistemas externos.

Con esa información puede identificar los registros afectados y ejecutar las acciones técnicas que le correspondan, siguiendo las instrucciones autorizadas. Sin embargo, la procedencia jurídica de la solicitud, la verificación de identidad, la determinación de su procedencia y las excepciones legales deben ser gestionadas por las áreas responsables.

### **10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?**

El DBA debe administrar la base de datos, configurar roles y permisos, proteger los respaldos y mantener la disponibilidad y trazabilidad de la información; el responsable de privacidad debe coordinar las políticas de protección de datos, supervisar su cumplimiento y gestionar las solicitudes de los titulares; el área jurídica debe interpretar las obligaciones legales aplicables, determinar los requisitos de conservación y analizar las condiciones legales del tratamiento de datos; y el propietario de los datos debe definir las necesidades funcionales, justificar las finalidades de uso, identificar la información que requiere su área y aprobar los accesos correspondientes. Estas responsabilidades deben coordinarse de acuerdo con la estructura de la organización y el marco legal aplicable.