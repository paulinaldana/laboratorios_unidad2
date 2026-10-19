### **Introducción**
La seguridad de las bases de datos es fundamental para proteger la información personal y confidencial de los usuarios. En esta práctica se analizaron los riesgos relacionados con el almacenamiento de contraseñas en texto claro, la exposición de datos sensibles, la transmisión de información sin una validación adecuada y el manejo inseguro de claves criptográficas. También se revisaron mecanismos de protección en PostgreSQL para reducir estos riesgos.

### **Protección de credenciales**
Se identificó que almacenar contraseñas en texto claro permite que cualquier persona con acceso de lectura a la tabla pueda conocerlas directamente. Para evitarlo, se utilizó la función crypt() junto con gen_salt() de la extensión pgcrypto, generando hashes mediante bcrypt.

El texto claro muestra la contraseña original, mientras que el hash genera una representación no reversible que permite verificarla sin recuperarla directamente. Por otra parte, el cifrado transforma la información mediante una clave y permite recuperar el dato original cuando se dispone de la clave correcta.

### **Protección de datos sensibles**
Se utilizó el RFC como ejemplo de información que requiere protección adicional. Mediante las funciones pgp_sym_encrypt() y pgp_sym_decrypt() de PostgreSQL, se cifró el RFC de un cliente y posteriormente se recuperó utilizando la clave correspondiente.

Esta práctica permitió comprobar que el cifrado protege la confidencialidad de los datos almacenados. También se identificó la importancia de mantener la clave protegida, ya que su exposición podría permitir descifrar la información.

### **TLS**
TLS permite proteger la información que se transmite entre el cliente y el servidor PostgreSQL, reduciendo el riesgo de que terceros puedan leer o modificar los datos durante la comunicación.

Se revisaron los parámetros ssl, ssl_min_protocol_version, port y listen_addresses, así como la dirección y el puerto del cliente. También se consultó la vista pg_stat_ssl para identificar si la sesión utilizaba TLS, qué versión del protocolo se había negociado y qué algoritmo de cifrado se utilizaba.

Además, se analizaron los modos de conexión disable, prefer, require, verify-ca y verify-full, identificando que este último permite validar tanto el certificado como el nombre del servidor cuando la configuración es correcta.

### **Gestión de claves**
Las claves criptográficas no deben almacenarse junto con los scripts porque podrían quedar expuestas al compartir archivos, publicar código en GitLab o conservar versiones anteriores del proyecto.

Se identificó la importancia de utilizar gestores de secretos, limitar el acceso a las claves y establecer procedimientos de rotación, respaldo, revocación y eliminación segura. Estas medidas ayudan a evitar que una filtración comprometa la información cifrada.

### **Resultados**
Durante la práctica se obtuvieron los siguientes resultados principales:
- Se identificaron los riesgos de almacenar contraseñas en texto claro.
- Se generaron hashes de contraseñas utilizando bcrypt mediante pgcrypto.
- Se creó una tabla para almacenar credenciales protegidas y se verificaron contraseñas correctas e incorrectas.
- Se cifró y recuperó un RFC utilizando cifrado simétrico.
- Se revisaron los parámetros de configuración SSL y las consultas para comprobar el uso de TLS.
- Se analizaron los niveles de validación de los modos de conexión de PostgreSQL.
- Se identificaron los riesgos de incluir claves criptográficas en archivos SQL.
- Se establecieron medidas para revisar secretos antes de publicar archivos en GitLab y se formuló una política básica de protección de claves.

### **Problemas encontrados**
Durante la práctica se identificaron algunas dificultades conceptuales relacionadas con la diferencia entre hash y cifrado, así como con la importancia de proteger las claves utilizadas para recuperar información cifrada.

También se reconoció que habilitar SSL en PostgreSQL no garantiza por sí solo que una conexión esté protegida correctamente, ya que es necesario comprobar el estado de la sesión y considerar la validación del certificado del servidor.

Los resultados concretos de las consultas y los errores técnicos deben documentarse según lo observado durante la ejecución. No se deben registrar errores que no se hayan presentado realmente.

### **Conclusiones**
La práctica permitió comprender que proteger una base de datos requiere más que configurar usuarios y permisos. Es necesario utilizar hashes especializados para las contraseñas, cifrar la información sensible que deba recuperarse posteriormente, proteger las comunicaciones mediante TLS y administrar las claves de forma segura.

En un entorno productivo aplicaría controles de acceso, algoritmos de hash adecuados, cifrado de información y respaldos, validación de certificados TLS, almacenamiento seguro de claves y revisiones periódicas de los archivos antes de publicarlos en repositorios. Estas medidas ayudarían a reducir los riesgos de exposición, pérdida o uso no autorizado de la información.

## Preguntas de reflexión
**1. ¿Por qué una contraseña no debe almacenarse como texto claro?**

Porque cualquier persona que obtenga acceso a la tabla podría conocer la contraseña directamente y utilizarla sin autorización. Por eso, debe almacenarse mediante un hash seguro.

**2. ¿Por qué un hash no es equivalente a un cifrado?**

Porque un hash es una representación no reversible diseñada para verificar información, mientras que el cifrado permite recuperar el dato original utilizando la clave correcta.

**3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?**

Porque el cifrado protege la confidencialidad del dato, pero el control de acceso determina quién puede consultar o modificar la información. Ambos mecanismos se complementan.

**4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**

Porque TLS protege la comunicación entre el cliente y el servidor, mientras que la autorización determina qué operaciones puede realizar cada usuario dentro de la base de datos.

**5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**

Podría perder la capacidad de recuperar los datos cifrados. Si no existe un respaldo seguro de la clave o un mecanismo de recuperación, la información podría volverse irrecuperable.

**6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**

Una persona no autorizada podría obtener la clave y utilizarla para descifrar información. La organización debería considerar la clave comprometida, sustituirla y evaluar el alcance de la exposición.

**7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**

Porque los permisos pueden cambiar, las cuentas pueden verse comprometidas y las claves pueden permanecer en el historial de versiones. Es preferible utilizar un gestor de secretos con acceso controlado.

**8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**

La protección de datos almacenados busca evitar que la información guardada sea consultada sin autorización. La protección durante la transmisión busca impedir que terceros intercepten o alteren los datos que viajan entre sistemas.

**9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**

Porque un algoritmo seguro no puede proteger adecuadamente la información si la clave se expone, se pierde o se administra incorrectamente.

**10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**

Implementaría cifrado de respaldos, almacenamiento con acceso restringido y copias de seguridad separadas del sistema principal. También realizaría pruebas periódicas de restauración para comprobar que la información pueda recuperarse.