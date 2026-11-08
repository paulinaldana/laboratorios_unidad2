# 18. Actividad 12 — El incidente auditado

## Preguntas 

### 1. Compara tu hipótesis de la Actividad 11 con este resultado.

El resultado confirma la hipótesis: la función pudo insertar el registro de auditoría aunque app_ventas no tuviera permisos para acceder directamente al esquema auditoria.

Esto fue posible gracias a SECURITY DEFINER, que hace que la función se ejecute con los privilegios de su propietario.

También podemos observar una diferencia importante entre los dos campos:
- usuario_sesion = app_ventas: identifica al usuario que inició la sesión.
- usuario_efectivo = postgres: identifica al usuario cuyos privilegios se utilizaron para ejecutar la función.

Por eso es importante conservar ambos campos. Si solamente guardáramos current_user, perderíamos información sobre la cuenta que originó la operación.

### 2. Escribe la sentencia UPDATE que restauraría el valor anterior.

El valor anterior del RFC era GAMA780912XYZ. Para restaurarlo:

```
UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;
```

Esta operación generará un nuevo registro en la tabla de auditoría, porque el disparador también registra las modificaciones realizadas para restaurar datos.

Esto es positivo: no elimina la evidencia del incidente original, sino que deja constancia de la corrección.

### 3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?

Ambas aportan información diferente, pero ip_cliente suele ofrecer un indicio más útil para investigar el origen de una conexión.

- aplicacion indica qué programa declara estar realizando la conexión. Permite distinguir, por ejemplo, entre una aplicación web y pgAdmin.
- ip_cliente identifica la dirección IP desde la que PostgreSQL recibió la conexión. Ayuda a localizar su origen en la red.
La columna que el cliente puede falsificar con mayor facilidad es aplicacion, porque su valor se proporciona mediante application_name y puede modificarse desde el cliente.

La dirección IP es más difícil de falsificar en una conexión TCP normal, porque PostgreSQL obtiene la dirección del extremo de la conexión. Sin embargo, puede verse alterada por NAT, proxies, túneles o infraestructura intermedia; tampoco identifica por sí sola a una persona o dispositivo de manera inequívoca.

## Conclusión

`aplicacion` sirve como referencia, pero no demuestra la identidad del programa. ip_cliente aporta evidencia sobre el origen de la conexión, pero tampoco identifica a una persona. Para una investigación confiable conviene analizar ambas junto con el usuario de sesión, la hora y los registros de infraestructura.