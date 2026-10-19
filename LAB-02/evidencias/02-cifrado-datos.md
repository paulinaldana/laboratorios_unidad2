## 8. Actividad 2 — Cifrado de información sensible

### **Objetivo**

Comprender cómo proteger información sensible mediante cifrado simétrico en PostgreSQL, utilizando el campo RFC como ejemplo. Asimismo, identificar las diferencias entre el hash de contraseñas y el cifrado reversible, y reconocer los riesgos relacionados con el manejo de claves de cifrado.

### **Comando o procedimiento**

**1. Creación de una tabla para almacenar información cifrada**

Se creó la tabla clientes_protegidos, que contiene un identificador, el nombre del cliente y un campo de tipo BYTEA para almacenar el RFC cifrado.

`CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);`

**2. Inserción del registro con cifrado simétrico**

Se insertó un registro de prueba utilizando la función pgp_sym_encrypt(), que cifra el RFC mediante una clave proporcionada.

`INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);`

**3. Consulta de los datos almacenados**

Se consultó la tabla para observar cómo se almacena el RFC después del proceso de cifrado.

`SELECT *
FROM clientes_protegidos;`

**4. Recuperación del dato original**

Finalmente, se utilizó pgp_sym_decrypt() con la misma clave para descifrar el RFC y recuperar su valor original.

`SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'CLAVE-DE-PRUEBA'
    ) AS rfc
FROM clientes_protegidos;`

### **Resultado obtenido**

Al consultar la tabla `clientes_protegidos`, el RFC dejó de mostrarse directamente como texto legible, ya que se almacenó en formato binario cifrado dentro del campo `rfc_cifrado`.

Al ejecutar la consulta de descifrado con la clave correcta, se recuperó el RFC original: `LOPA900101ABC`.

Por lo tanto, se comprobó que PostgreSQL permite proteger información sensible mediante cifrado simétrico y recuperarla posteriormente cuando se dispone de la clave correspondiente.

### **Análisis**

**Preguntas**

**¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?**

La función `crypt()` se utiliza para generar y verificar hashes de contraseñas, que son representaciones no reversibles. En cambio, `pgp_sym_encrypt()` cifra información utilizando una clave secreta, lo que permite recuperar el dato original mediante la función de descifrado correspondiente.

**¿Cuál de los dos mecanismos permite recuperar el dato original?**

El cifrado simétrico mediante `pgp_sym_encrypt()` permite recuperar el dato original con `pgp_sym_decrypt()` y la clave correcta. En cambio, un hash generado con ``crypt()`` no está diseñado para revertirse y recuperar la contraseña original.

**¿Qué ocurre si se utiliza una clave incorrecta?**

El proceso de descifrado normalmente falla y PostgreSQL genera un error, ya que no puede descifrar correctamente la información con la clave proporcionada. No se obtiene de manera válida el RFC original.

**¿Qué problema de seguridad representa colocar la clave directamente en una consulta?**

Incluir la clave directamente en una consulta puede exponerla en registros de consultas, archivos de configuración, historiales de ejecución o herramientas de monitoreo, dependiendo del entorno. Si una persona no autorizada obtiene la clave y los datos cifrados, podría recuperar la información sensible. Por ello, en aplicaciones reales las claves deben administrarse mediante mecanismos seguros, limitar su acceso y evitar almacenarlas directamente en el código fuente.

### **Conclusión**

La actividad permitió comprender que el cifrado simétrico constituye una alternativa para proteger información sensible, como el RFC de un cliente, cuando es necesario recuperarla posteriormente. Mediante las funciones ``pgp_sym_encrypt()`` y ``pgp_sym_decrypt()`` fue posible cifrar y recuperar el dato original utilizando la misma clave. Asimismo, se identificó que la seguridad del mecanismo depende tanto de la protección de los datos cifrados como del manejo adecuado de las claves.