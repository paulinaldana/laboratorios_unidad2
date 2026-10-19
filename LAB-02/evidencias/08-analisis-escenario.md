## 15. Actividad 8 — Analizar un escenario de seguridad

### **Objetivo**
Analizar los riesgos de seguridad asociados con el almacenamiento, la transmisión y la administración de información sensible en una base de datos, así como identificar los mecanismos de protección adecuados para reducirlos y comprender las limitaciones de los controles de acceso.

### **Comando o procedimiento**
Se analizó el escenario planteado, identificando los datos sensibles de la empresa y las malas prácticas presentes en su manejo. Posteriormente, se relacionaron los riesgos identificados con los mecanismos de protección apropiados, considerando la seguridad de las contraseñas, el cifrado de la información, la validación de las conexiones, la gestión de claves criptográficas y la protección de los respaldos.

### **Resultado obtenido**
**Pregunta 1**

**¿Cuáles son los principales riesgos?**

Los principales riesgos son la exposición de contraseñas y datos personales, el robo de información durante la comunicación, la filtración de claves criptográficas y el acceso no autorizado a los respaldos de la base de datos.

**Pregunta 2**

**¿Qué mecanismo utilizarías para cada elemento?**

**1. Nombre:** Control de acceso - Limita quién puede consultar la información.

**2. Correo electrónico:** Control de acceso y cifrado cuando sea necesario - Protege los datos de contacto.

**3. Contraseña:** Hash mediante bcrypt o Argon2id - Evita almacenar la contraseña original.

**4. RFC:** Cifrado simétrico -	Protege el RFC y permite recuperarlo con la clave correcta.

**5. Información financiera:** Cifrado y TLS	 - Protege la información almacenada y transmitida.

**6. Claves criptográficas:** Gestor de secretos -	Evita que las claves queden expuestas en archivos SQL.

**7. Conexiones con PostgreSQL:** TLS con ``sslmode=verify-full`` -	Protege la comunicación y verifica la identidad del servidor.

**8. Respaldos:** Cifrado y almacenamiento seguro -	Evita que personas no autorizadas consulten su contenido.

**Pregunta 3**

**¿Cuál de los problemas consideras más crítico y por qué?**

Considero que almacenar las contraseñas en texto claro es uno de los problemas más críticos, porque cualquier persona que acceda a la tabla puede conocerlas directamente y utilizarlas indebidamente.

**Pregunta 4**

**¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?**

No. Los usuarios y permisos ayudan a controlar el acceso, pero no protegen por sí solos las contraseñas almacenadas en texto claro, las claves expuestas ni los datos transmitidos sin seguridad. Por eso, es necesario complementarlos con cifrado, hashes de contraseñas y una gestión adecuada de las claves.

### **Análisis**

El escenario demuestra que la seguridad de una base de datos no depende exclusivamente de los usuarios y permisos configurados. Aunque estos controles son necesarios, deben formar parte de una estrategia de protección que abarque la información almacenada, la comunicación entre sistemas, la administración de claves y las copias de respaldo.

También es importante reconocer que no todos los datos requieren el mismo tratamiento. Las contraseñas deben protegerse mediante hashes especializados, mientras que el RFC y la información financiera pueden requerir cifrado reversible cuando sea necesario recuperar sus valores originales. Las claves criptográficas, por su parte, necesitan una protección independiente para evitar que una filtración comprometa los datos que protegen.

### **Conclusión**
La actividad permitió identificar que las principales vulnerabilidades del escenario se relacionan con el almacenamiento inseguro de credenciales y datos personales, la validación insuficiente de las conexiones, la exposición de claves criptográficas y la falta de protección de los respaldos. Se concluye que una estrategia de seguridad adecuada requiere combinar controles de acceso con mecanismos específicos de protección para cada tipo de información. De esta manera, es posible reducir el riesgo de filtraciones y limitar sus consecuencias incluso cuando una medida de seguridad falla.