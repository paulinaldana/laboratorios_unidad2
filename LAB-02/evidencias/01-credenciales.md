## 7. Actividad 1 — Protección de credenciales

### **Objetivo**
Identificar los riesgos de almacenar contraseñas en texto claro y comprender cómo PostgreSQL permite proteger las credenciales mediante funciones de hash. Asimismo, verificar la autenticidad de una contraseña sin necesidad de recuperar su valor original y reconocer la importancia de aplicar buenas prácticas de seguridad en el manejo de información sensible.

### **Comando o procedimiento**
**1. Preparación de la base de datos.**

Se verificó la existencia y estructura de la tabla clientes utilizada en LAB-01. Posteriormente, se comprobó que la extensión pgcrypto estuviera disponible para utilizar las funciones de protección de contraseñas.

`CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT extname
FROM pg_extension
WHERE extname = 'pgcrypto';`

**2. Identificación del problema**

Se creó la tabla usuarios_insegura para demostrar los riesgos de almacenar contraseñas en texto claro y se insertó un usuario de prueba.

`CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);
INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123');
SELECT *
FROM usuarios_insegura;`

**3. Generación de una representación no reversible**

Se utilizó crypt() junto con gen_salt('bf') para generar un hash de la contraseña. El procedimiento se ejecutó dos veces para comparar los resultados y observar el efecto de utilizar una sal aleatoria.

`SELECT crypt(
    'Password123',
    gen_salt('bf')
);`

**4. Creación de una tabla para credenciales protegidas**

Se creó la tabla usuarios_segura con un campo destinado a almacenar el hash de la contraseña. Después, se insertó el usuario de prueba y se consultaron los registros para comprobar cómo se almacena la credencial.

**5. Verificación de contraseñas**

Se comparó el hash almacenado con el resultado de aplicar crypt() a una contraseña correcta y, posteriormente, a una incorrecta.

### **Resultado obtenido**
- La tabla clientes permitió verificar la estructura de los datos utilizados en la práctica.
- La extensión pgcrypto permitió utilizar funciones criptográficas desde PostgreSQL.
- En la tabla usuarios_insegura, la contraseña se mostró directamente como texto claro, lo que evidenció el riesgo de almacenar credenciales sin protección.
- Al ejecutar dos veces crypt('Password123', gen_salt('bf')), se obtuvieron hashes diferentes debido a que se generaron sales aleatorias distintas.
- En la tabla usuarios_segura, la contraseña original fue sustituida por una representación hash.
- Al verificar las credenciales, se esperó obtener los siguientes resultados:

### **Análisis**
El ejercicio permitió identificar que almacenar contraseñas en texto claro representa un riesgo de seguridad, ya que cualquier persona que obtenga acceso de lectura a la tabla podría conocer directamente las credenciales de los usuarios.

La función gen_salt() genera una sal aleatoria que se utiliza durante el proceso de hash, mientras que crypt() genera la representación de la contraseña utilizando el algoritmo indicado. En este caso, 'bf' corresponde al esquema bcrypt.
Los resultados diferentes para una misma contraseña no significan que exista un error. Se deben a que cada ejecución utiliza una sal distinta, lo que evita que una contraseña produzca siempre la misma representación.

Por otra parte, la verificación no requiere recuperar la contraseña original. PostgreSQL utiliza el hash almacenado para comprobar si la contraseña ingresada coincide con la credencial registrada. Si coincide, devuelve true; de lo contrario, devuelve false.

Es importante distinguir entre hash y cifrado: el cifrado reversible permite recuperar la información original mediante una clave, mientras que el hash de contraseñas está diseñado para verificar coincidencias sin recuperar directamente el valor original.

Finalmente, aunque el ejercicio demuestra un mecanismo de protección, una implementación real debe utilizar algoritmos y parámetros adecuados a las recomendaciones de seguridad vigentes y, preferentemente, las funciones especializadas del framework de la aplicación. No se deben almacenar contraseñas en texto claro ni desarrollar algoritmos propios de protección.

**Pregunta:**
¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?

**Respuesta:**
Si una persona obtiene accso de lectura a esta tabla, podría ver las contraseñas de los usuarios en texto plano, sin necesidad de decifrarlas. Esto compromete la seguridad de las cuentas, ya que podría utilizar esas contraseñas para acceder a la aplicación o a otros servicios si los usuarios las reutilizan.

**Preguntas**

**1. ¿Son iguales?**
No son iguales, las cadenas generadas son diferentes porque cada ejecución utiliza una sal aleatoria distinta.

**2. Si no son iguales, ¿por qué?**
Porque se utilizó un mecanismo que cada vez que se ejecuta utiliza una sal aleatoria distinta.

**3. ¿Qué función cumple gen_salt()?**
Genera una sal aleatoria que se utiliza como parte del proceso de protección de la contraseña. El parámetro `'bf'` indica el uso del algoritmo Blowfish, compatible con bcrypt.

**4. ¿Qué función cumple crypt()?**
Calcula una representación derivada de la contraseña utilizando el algoritmo y la sal proporcionados. En este caso, genera un hash de contraseña mediante bcrypt.

**5. ¿Esto es cifrado reversible?**
No. Se trata de un proceso de hash, no de cifrado reversible. No es posible recuperar directamente la contraseña original a partir del hash. Para comprobar una contraseña, se vuelve a calcular su representación utilizando el hash almacenado y se comparan los resultados.

**Preguntas**

**¿Qué resultado obtuviste con la contraseña correcta?**

El resultado fue true, porque la contraseña ingresada coincide con la utilizada para generar el hash almacenado.

**¿Qué resultado obtuviste con la contraseña incorrecta?**

El resultado fue false, porque la contraseña ingresada genera una representación diferente y no coincide con el hash almacenado.

**¿Por qué no es necesario recuperar la contraseña original?**

Porque PostgreSQL puede verificar la contraseña ingresada utilizando el hash almacenado como referencia. La función crypt() utiliza la sal y los parámetros incluidos en ese hash para realizar la comparación, sin necesidad de recuperar la contraseña original.

**¿Por qué un hash no debe confundirse con cifrado?**

Porque el cifrado está diseñado para permitir recuperar la información original mediante una clave, mientras que un hash de contraseña es una representación unidireccional. Su propósito es permitir la verificación sin revelar directamente la contraseña original.

### **Conclusión**

La actividad permitió comprender la importancia de proteger las credenciales mediante mecanismos de hash en lugar de almacenarlas como texto claro. Mediante las funciones gen_salt() y crypt() de PostgreSQL fue posible generar representaciones no reversibles y verificar contraseñas correctas e incorrectas sin recuperar su valor original. Se concluye que la protección de credenciales es una medida fundamental para reducir los riesgos derivados de accesos no autorizados y filtraciones de bases de datos.
