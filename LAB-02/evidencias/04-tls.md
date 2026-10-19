## 10. Actividad 4 — Protección de datos durante la comunicación // 11. Actividad 5 — Verificar el estado de TLS en PostgreSQL

### **Objetivo**

Comprender la importancia de proteger la información durante la comunicación entre el cliente y el servidor PostgreSQL mediante TLS (Transport Layer Security). Asimismo, verificar la configuración SSL del servidor, identificar los parámetros de conexión y comprobar si la sesión actual utiliza TLS, con el propósito de reconocer los riesgos de transmitir información sin protección.

### **Comando o procedimiento**

**1. Identificación del riesgo durante la comunicación**

Se analizó el siguiente comando para identificar que los datos consultados en la base de datos deben protegerse no solo durante su almacenamiento, sino también durante su transmisión entre el cliente y el servidor.

**2. Verificación de la configuración SSL de PostgreSQL**

Se ejecutaron las siguientes consultas para conocer el estado de SSL, la versión mínima del protocolo permitida, el puerto utilizado por el servidor y las direcciones en las que escucha conexiones.

**3. Identificación de la conexión actual**

Se consultaron la dirección IP y el puerto del cliente para identificar los datos de conexión de la sesión actual.

**4. Verificación del uso de TLS en la sesión**

Finalmente, se consultó la vista pg_stat_ssl para determinar si la conexión actual utiliza cifrado y conocer la versión del protocolo y el algoritmo de cifrado de la sesión.

### **Resultado obtenido**

Las consultas permitieron identificar los parámetros de configuración SSL del servidor PostgreSQL y obtener información sobre la conexión actual.

La consulta a pg_stat_ssl permite determinar si la sesión utiliza TLS mediante la columna ssl. Cuando el valor es true, la conexión está cifrada mediante SSL/TLS; cuando es false, la sesión no utiliza este mecanismo de protección. Las columnas version y cipher permiten identificar, respectivamente, la versión negociada del protocolo y el algoritmo de cifrado utilizado.

Los valores concretos dependen de la configuración del servidor y del cliente utilizado, por lo que deben registrarse a partir de los resultados obtenidos durante la ejecución.

### **Análisis**

**Preguntas**

**1. ¿La conexión actual utiliza TLS?**

Se determina mediante la columna ssl de la vista pg_stat_ssl. Si devuelve true, la sesión actual utiliza TLS; si devuelve false, la comunicación no está cifrada mediante este protocolo. La configuración SHOW ssl indica si SSL está habilitado en el servidor, pero no demuestra por sí sola que la sesión actual esté protegida.

**2. ¿Qué versión de TLS se está utilizando?**

La versión se identifica mediante la columna version de pg_stat_ssl. El resultado puede indicar, por ejemplo, TLSv1.2 o TLSv1.3, según la negociación entre el cliente y el servidor. Si la sesión no utiliza TLS, este campo no proporcionará una versión de protocolo negociada.

**3. ¿Qué algoritmo de cifrado aparece?**

El algoritmo se identifica mediante la columna cipher, que muestra el conjunto de cifrado negociado para la conexión. Su nombre exacto depende de los protocolos y algoritmos compatibles con el cliente y el servidor.

**4. ¿Qué diferencia existe entre una conexión protegida con TLS y una conexión sin TLS?**

Una conexión protegida con TLS cifra la comunicación entre el cliente y el servidor, ayudando a impedir que terceros que observen el tráfico de red puedan leer directamente los datos transmitidos. Además, permite verificar la integridad de la comunicación y, cuando se configura correctamente la validación de certificados, autenticar al servidor.

En cambio, una conexión sin TLS puede exponer la información transmitida a personas capaces de interceptar el tráfico de red. Esto representa un riesgo cuando se envían datos personales, credenciales o información confidencial.

### **Conclusión**

Las actividades permitieron comprender que la seguridad de una base de datos no depende únicamente de proteger la información almacenada, sino también de asegurar su transmisión entre el cliente y el servidor. Mediante las consultas de configuración y la vista pg_stat_ssl, es posible identificar si una sesión utiliza TLS y conocer los parámetros de cifrado negociados. Se concluye que habilitar TLS, configurar adecuadamente los certificados y verificar su autenticidad son medidas importantes para reducir el riesgo de exposición de información durante la comunicación.