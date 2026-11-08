# 14. Actividad 8 — Errores y operaciones rechazadas

## Preguntas 

### 1. ¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos?

No. El intento de eliminación fue rechazado porque soporte_ana no tenía permisos para ejecutar DELETE sobre la tabla clientes. Por lo tanto, el registro no fue eliminado ni modificado.

Sin embargo, debe auditarse porque un intento rechazado también puede ser relevante para la seguridad:
- Permite detectar intentos de realizar operaciones no autorizadas.
- Ayuda a identificar posibles abusos de privilegios o errores en el uso de las cuentas.
- Permite reconocer patrones sospechosos, como intentos repetidos de borrar o modificar información.
- Proporciona evidencia para investigar incidentes de seguridad.

Que una operación no haya tenido éxito no significa que el intento deba ignorarse.

### 2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?

La diferencia está en el momento en que ocurre el problema:
- Autenticación: PostgreSQL intenta comprobar quién quiere conectarse. Si la contraseña es incorrecta o el usuario no existe, rechaza el acceso. Es lo que observamos en la Actividad 5.
- Autorización: el usuario ya consiguió conectarse, pero intenta realizar una operación para la que no tiene permisos. Es lo que ocurrió con soporte_ana al intentar ejecutar DELETE.
En pocas palabras: la autenticación comprueba quién eres; la autorización determina qué puedes hacer.

### 3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?

Indica que no podemos eliminar directamente un rol mientras conserve privilegios u otras dependencias dentro de la base de datos.

Antes de ejecutar ```DROP ROLE```, el administrador debe identificar y retirar los permisos que se le concedieron. En este caso, tendría que revocar los privilegios de soporte_ana sobre la tabla clientes.

También debe comprobar si el rol tiene otros privilegios, objetos propios o dependencias en otras bases de datos.

El orden correcto sería:
1. Identificar los permisos y objetos asociados al usuario.
2. Revocar sus privilegios.
3. Transferir o eliminar los objetos que sean de su propiedad, si existen.
4. Comprobar que ya no tenga dependencias.
5. Ejecutar ```DROP ROLE```.

## Conclusión

Esta actividad demuestra que una bitácora no solamente debe registrar las operaciones exitosas. También debe conservar los intentos rechazados, porque permiten conocer qué acciones se intentaron realizar, quién las ejecutó y por qué fueron bloqueadas.