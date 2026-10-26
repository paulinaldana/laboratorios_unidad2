# Informe de seguridad de PostgreSQL 16

### **1. ¿Cuál era la principal superficie de ataque?**

La principal superficie de ataque estaba relacionada con las conexiones al servidor PostgreSQL, especialmente si aceptaba conexiones desde interfaces o redes innecesarias. También forman parte de esta superficie las cuentas de usuario, los métodos de autenticación, los privilegios asignados y los archivos de configuración.

### **2. ¿Qué configuración representaba el mayor riesgo?**

Una configuración que permitiera conexiones desde redes no confiables, combinada con reglas demasiado permisivas en pg_hba.conf y cuentas con privilegios excesivos, representaría un riesgo importante. Esta combinación podría facilitar accesos no autorizados y comprometer la información almacenada.

### **3. ¿Qué cambio produjo la mayor reducción de exposición?**

Restringir las conexiones a las interfaces y redes estrictamente necesarias, bloqueando el acceso directo desde Internet mediante el firewall, puede producir una reducción importante de la exposición. Este cambio debe complementarse con reglas adecuadas en pg_hba.conf y autenticación segura.

### **4. ¿Qué diferencia existe entre firewall y pg_hba.conf?**

El firewall controla el tráfico de red que puede llegar al servidor, según las direcciones IP, los puertos y las reglas configuradas. En cambio, pg_hba.conf determina qué conexiones a PostgreSQL se permiten según el tipo de conexión, la base de datos, el usuario, la dirección de origen y el método de autenticación. Ambos controles se complementan para limitar los accesos.

### **5. ¿Qué diferencia existe entre autenticación y autorización?**

La autenticación verifica la identidad de quien intenta conectarse, por ejemplo, mediante una contraseña. La autorización determina qué acciones puede realizar esa identidad una vez autenticada, como consultar tablas, modificar registros o administrar la base de datos.

### **6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**

Porque el privilegio SUPERUSER permite realizar prácticamente cualquier operación dentro de PostgreSQL y omitir muchas restricciones de seguridad. Si una aplicación presenta una vulnerabilidad o sus credenciales son robadas, un atacante podría obtener un control mucho mayor sobre el servidor. Por ello, la cuenta debe tener únicamente los permisos necesarios para cumplir sus funciones.

### **7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**

Cambiar el puerto predeterminado 5432 puede reducir algunos intentos automatizados que buscan servicios en puertos conocidos, pero no impide que un atacante descubra el nuevo puerto. La seguridad depende principalmente de restringir las conexiones, utilizar autenticación robusta, aplicar privilegios mínimos y mantener actualizado el servidor.

### **8. ¿Por qué listen_addresses='*' puede ser innecesario?**

Porque configura PostgreSQL para escuchar en todas las interfaces de red disponibles. Si la base de datos solo necesita recibir conexiones locales o desde una red privada, escuchar en interfaces adicionales aumenta innecesariamente su exposición. Es preferible especificar únicamente las interfaces que realmente necesita el servicio.

### **9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**

El sistema operativo protege los archivos de datos, las configuraciones, los registros y los respaldos mediante permisos y propietarios adecuados. También controla las cuentas que pueden ejecutar procesos, acceder a archivos o administrar el servidor. Una configuración segura de PostgreSQL no es suficiente si usuarios no autorizados pueden acceder directamente a sus archivos.

### **10. ¿Qué controles deberían revisarse periódicamente?**

Se deben revisar las interfaces de escucha, las reglas de pg_hba.conf, las reglas del firewall, los métodos de autenticación, las cuentas y sus privilegios, las conexiones activas, el uso de TLS, las extensiones instaladas, los permisos del sistema operativo, los registros de actividad, las actualizaciones y los respaldos. También es necesario comprobar que los cambios aplicados sigan siendo efectivos y que los accesos continúen respondiendo a las necesidades reales de la organización.

## Reflexión individual
Si recibiera la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción, primero revisaría la exposición de red y las reglas de acceso existentes antes de realizar cambios que pudieran interrumpir el servicio. Comenzaría identificando las interfaces de escucha, el puerto, las redes autorizadas, las reglas del firewall y el contenido de pg_hba.conf. También verificaría qué aplicaciones y usuarios dependen del servidor, para conocer las conexiones necesarias y evitar afectar la disponibilidad.

Priorizaría esta revisión porque un servidor accesible desde redes no confiables puede recibir intentos de conexión no autorizados, mientras que una modificación incorrecta de la configuración podría impedir que las aplicaciones legítimas funcionen. Si detectara exposición innecesaria, prepararía un cambio controlado para limitar el acceso a las redes requeridas, coordinándolo con el equipo responsable y manteniendo un procedimiento de reversión.

Después revisaría los privilegios de las cuentas, prestando especial atención a los usuarios con permisos de SUPERUSER y a las cuentas utilizadas por las aplicaciones. Aplicaría el principio de mínimo privilegio y comprobaría que cada cuenta tuviera únicamente los permisos necesarios. Asimismo, verificaría los métodos de autenticación y el uso de TLS para proteger las credenciales y la información transmitida.

Finalmente, revisaría los permisos de los archivos del sistema operativo, las extensiones, los registros, las actualizaciones y los respaldos, además de comprobar que estos últimos pudieran restaurarse correctamente. Documentaría la configuración inicial, los cambios realizados y sus resultados.

Considero que este orden es adecuado porque permite identificar y reducir primero los riesgos de exposición sin comprometer innecesariamente la continuidad del servicio. La prioridad no sería cambiar parámetros de forma indiscriminada, sino comprender la arquitectura, corregir los riesgos más importantes y aplicar cada medida de seguridad de manera controlada, verificable y compatible con las necesidades de producción.