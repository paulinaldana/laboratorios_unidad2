## 7.3 Generar una representación no reversible

**Objetivo**

Comprender cómo generar una representación no reversible de una contraseña mediante las funciones crypt() y gen_salt() de PostgreSQL, identificando su funcionamiento y las diferencias entre el cifrado reversible y el hash de contraseñas.

**Comando o procedimiento**
- ***Primero***, se ejecutó el siguiente comando para generar una representación de la contraseña mediante el algoritmo Blowfish:
`SELECT crypt(
    'Password123',
    gen_salt('bf')
);`

- ***Posteriormente***, se ejecutó nuevamente el mismo comando para comparar ambos resultados y observar si la representación generada era idéntica.

**Resultado obtenido**

En ambas ejecuciones se obtuvieron cadenas de caracteres diferentes, aunque se utilizó la misma contraseña de entrada (Password123).
Esto ocurre porque la función gen_salt('bf') genera una sal aleatoria en cada ejecución, lo que produce representaciones distintas para una misma contraseña.

**Análisis**

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

**Conclusión**

La actividad permitió comprender la importancia de proteger las contraseñas mediante funciones de hash en lugar de almacenarlas como texto plano. Se observó que gen_salt() genera una sal aleatoria y que crypt() utiliza dicha sal para producir un hash mediante bcrypt. Aunque una misma contraseña puede generar resultados diferentes, estos pueden utilizarse para verificar su autenticidad sin necesidad de recuperar la contraseña original.