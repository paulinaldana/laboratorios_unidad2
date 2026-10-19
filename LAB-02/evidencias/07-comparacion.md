## 12. Actividad 6 — Conexión mediante psql, comprensión de sslmode y comparación de mecanismos de protección

### **Objetivo**

Comprender cómo establecer una conexión con PostgreSQL mediante psql utilizando TLS, identificar las diferencias entre los modos de conexión disponibles y reconocer la importancia de verificar la identidad del servidor. Asimismo, comparar los mecanismos de protección de datos según su propósito, considerando las contraseñas, la información sensible almacenada, los datos transmitidos, los respaldos y las claves criptográficas.

### **Comando o procedimiento**

**1. Establecimiento de una conexión mediante psql**

Se identificó la configuración necesaria para conectarse al servidor PostgreSQL mediante la terminal, especificando el servidor, el puerto, la base de datos y el usuario correspondiente.

**2. Verificación de la conexión**

Una vez establecida la conexión, se ejecutó un consulta para comprobar si la sesión utiliza TLS e identificar la versión del protocolo y el algoritmo de cifrado negociado.

**3. Identificación de los modos de conexión SSL**

Se analizaron los modos de conexión disponibles en PostgreSQL y sus diferencias en cuanto al cifrado y la validación del certificado del servidor.

**4. Comparación de mecanismos de protección**

Se identificaron distintos tipos de información y se relacionaron con los mecanismos de seguridad apropiados, considerando qué protege cada uno y en qué momento se requiere su aplicación.

**Resultado obtenido**
Se identificó que psql permite establecer conexiones con PostgreSQL mediante diferentes modos de seguridad. El parámetro sslmode determina si se utiliza TLS y qué nivel de validación del certificado se solicita.

El modo require permite exigir el cifrado de la comunicación, mientras que verify-full proporciona una validación más completa de la identidad del servidor, siempre que se configure correctamente la autoridad certificadora y el nombre del host.

La comparación de los mecanismos de protección permitió distinguir entre la seguridad de los datos almacenados, la protección durante su transmisión y la administración segura de las claves criptográficas.

### **Análisis**

### Comparar protección en reposo y protección en tránsito

# Comparación de mecanismos de protección de datos

| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash de contraseñas mediante bcrypt, Argon2id u otro algoritmo adecuado | Evita almacenar la contraseña original y permite verificarla sin recuperarla directamente. |
| RFC almacenado en una tabla | Cifrado de datos en reposo, como el cifrado simétrico | Protege la confidencialidad del RFC y permite recuperarlo mediante la clave autorizada. |
| Consulta enviada desde un cliente al servidor | TLS correctamente configurado y validado | Protege la confidencialidad e integridad de los datos transmitidos y ayuda a autenticar al servidor. |
| Respaldo de una base de datos | Cifrado del respaldo y almacenamiento seguro | Reduce el riesgo de exposición de la información si el archivo de respaldo es robado o divulgado. |
| Clave criptográfica | Gestor de secretos o sistema especializado de gestión de claves | Evita que las claves queden expuestas en el código fuente, los repositorios o los archivos de configuración. |

### **Conclusión**
La actividad permitió comprender que la seguridad de PostgreSQL requiere diferentes mecanismos según el tipo de información y el riesgo que se pretende reducir. Mediante psql y los modos sslmode se puede establecer una conexión cifrada y seleccionar el nivel de validación de la identidad del servidor. Asimismo, se identificó que la protección integral requiere combinar hashes para contraseñas, cifrado para información recuperable, TLS para las comunicaciones, cifrado para respaldos y una gestión segura de las claves criptográficas.