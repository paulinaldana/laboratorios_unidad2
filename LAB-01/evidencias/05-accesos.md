# 11. Actividad 5 — Accesos exitosos y fallidos

## Preguntas

### **1. La bitácora registra el usuario app_ventas en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**

No. El registro no demuestra que la aplicación de ventas haya realizado el intento.

Lo que demuestra es que un cliente que se conectó desde la dirección IP 127.0.0.1 intentó autenticarse utilizando el nombre de usuario app_ventas, pero proporcionó una contraseña incorrecta.

El campo app=[unknown] también indica que PostgreSQL no identificó una aplicación en ese intento.

Por lo tanto, no podemos atribuirlo directamente a la aplicación de ventas ni a una persona específica.

### **2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?**

Cuando el usuario indicado no existe, PostgreSQL puede registrar información adicional en la bitácora. Esta información permite al administrador conocer la causa específica del fallo de autenticación.

En cambio, el cliente recibe un mensaje genérico de autenticación fallida. Esto es una medida de seguridad que evita revelar directamente qué usuarios existen en el servidor y dificulta los intentos de enumeración de cuentas.

### **3. ¿Por qué app=[unknown] en el intento fallido, pero app=app-ventas-web en la desconexión?**

Porque son situaciones diferentes:
- Intento fallido: la autenticación no se completó, por lo que PostgreSQL no llegó a establecer una sesión normal en la que pudiera identificar la aplicación.
- Desconexión: la autenticación fue exitosa y PostgreSQL pudo identificar el nombre de aplicación proporcionado mediante application_name=app-ventas-web.
Esto permite distinguir entre una conexión que no llegó a establecerse y una sesión que sí estuvo activa.

Una precisión: el nombre de aplicación no es una identidad verificada. Un cliente puede declarar cualquier valor en application_name, por lo que no demuestra por sí solo que se trate de una aplicación legítima.

### **4. ¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.**

Un patrón sospechoso sería encontrar:
- Numerosos intentos fallidos de autenticación en un periodo corto.
- Repetidos intentos contra el mismo usuario.
- Intentos contra diferentes usuarios desde una misma dirección IP.
- Múltiples errores de contraseña desde direcciones IP desconocidas o inesperadas.
Para contar los intentos fallidos agrupados por usuario, se puede ejecutar:
```
SELECT
    (regexp_match(linea, 'user=([^ ]+)'))[1] AS usuario,
    COUNT(*) AS intentos_fallidos
FROM dba.bitacora
WHERE linea LIKE '%FATAL:  password authentication failed for user%'
GROUP BY usuario
ORDER BY intentos_fallidos DESC;
```

¿Qué hace esta consulta?
1. regexp_match() extrae el nombre del usuario registrado en cada línea.
2. COUNT(*) cuenta cuántos intentos fallidos corresponden a cada usuario.
3. GROUP BY usuario agrupa los resultados.
4. ORDER BY ... DESC muestra primero los usuarios con más intentos fallidos.

## Conclusión

La actividad demuestra que PostgreSQL permite identificar intentos de autenticación exitosos y fallidos, registrar el usuario solicitado, la dirección IP de origen y los motivos del rechazo. Esta información resulta útil para detectar comportamientos sospechosos, como múltiples intentos de acceso con contraseñas incorrectas. Sin embargo, los registros no permiten identificar directamente a la persona que realizó el intento ni confirmar que una conexión provenga de una aplicación legítima. Por ello, la bitácora debe complementarse con controles de autenticación, protección de credenciales y mecanismos de monitoreo.