# Informe final

## 1. Despliegue y situación inicial

El servidor PostgreSQL 16 se desplegó en un contenedor mediante Docker
Compose, utilizando Docker Desktop en Windows. La configuración permitió
mantener el servicio de base de datos separado del entorno de
administración, al que se accedió mediante pgAdmin 4. Para el
laboratorio se trabajó principalmente con la base `academia`, donde se
encontraba la tabla `public.clientes`; también se utilizó `comercial`
para probar conexiones y operaciones con distintos roles.

La configuración inicial de registro era insuficiente para investigar un
incidente. De acuerdo con la revisión de parámetros realizada al inicio
del laboratorio, los valores relevantes eran:

-   `log_connections = off`: no registraba los intentos y autorizaciones
    de conexión.
-   `log_disconnections = off`: no registraba el cierre de las sesiones.
-   `logging_collector = off`: el servidor no recopilaba los mensajes en
    archivos de log administrados por el propio PostgreSQL.
-   `log_statement = none`: no registraba las sentencias SQL ordinarias.
-   `log_min_error_statement = error`: registraba la sentencia asociada
    a errores de nivel ERROR o superior.
-   `log_line_prefix = '%m [%p]'`: incluía fecha y hora, y el
    identificador del proceso, pero no mostraba directamente el usuario,
    la base de datos, la aplicación ni el cliente.
-   `log_timezone = 'Etc/UTC'`: las marcas de tiempo se expresaban en
    UTC.

Con esta configuración inicial no era posible reconstruir de forma
confiable quién se conectó, desde qué aplicación o dirección, qué
sentencias ejecutó ni en qué orden ocurrieron los eventos. El registro
de errores podía mostrar una sentencia cuando fallaba, pero no
constituía un historial completo de las operaciones exitosas. Por eso no
bastaba para responder a Dirección sobre un cambio de RFC: faltaban
tanto la identidad contextual de la sesión como el registro de las
modificaciones realizadas.

## 2. Configuración aplicada

Se habilitó el registro de conexiones, desconexiones y sentencias, y se
amplió el prefijo de cada línea para aportar contexto. Los parámetros
relevantes quedaron de la siguiente manera:

  -------------------------------------------------------------------------------------------------
  Parámetro                   Valor aplicado                                Motivo
  --------------------------- --------------------------------------------- -----------------------
  `logging_collector`         `on`                                          Recopilar los mensajes
                                                                            del servidor en
                                                                            archivos de log.

  `log_connections`           `on`                                          Registrar la recepción,
                                                                            autenticación y
                                                                            autorización de
                                                                            conexiones.

  `log_disconnections`        `on`                                          Registrar el cierre de
                                                                            las sesiones y su
                                                                            duración.

  `log_line_prefix`           `'%m [%p] user=%u db=%d app=%a client=%h '`   Identificar hora,
                                                                            proceso, usuario, base,
                                                                            aplicación y host
                                                                            cliente en cada línea.

  `log_statement`             Primero `ddl`; después `mod`                  Registrar inicialmente
                                                                            sentencias de
                                                                            definición y luego
                                                                            sentencias de
                                                                            modificación de datos.

  `log_min_error_statement`   `error`                                       Conservar la sentencia
                                                                            que produjo errores de
                                                                            nivel ERROR o superior.

  `log_timezone`              `Etc/UTC`                                     Mantener una referencia
                                                                            temporal uniforme en
                                                                            los registros.
  -------------------------------------------------------------------------------------------------

### Recarga y reinicio

No todos los parámetros requieren el mismo procedimiento:

-   `logging_collector` requiere reiniciar el servidor PostgreSQL para
    que el cambio tenga efecto. En el laboratorio se habilitó como parte
    de la preparación del registro en archivos y se reinició el
    servicio.
-   `log_connections`, `log_disconnections`, `log_line_prefix` y
    `log_statement` admiten recarga de configuración; no requieren
    reiniciar el servidor.
-   El cambio de `log_statement` de `ddl` a `mod` quedó reflejado en la
    bitácora: después de ejecutar
    `ALTER SYSTEM SET log_statement = 'mod'`, el servidor recibió
    `SIGHUP`, recargó los archivos de configuración y registró que el
    parámetro cambió a `mod`.

`ALTER SYSTEM` guarda los cambios persistentes en la configuración
administrada por PostgreSQL (`postgresql.auto.conf`). La recarga hace
que los parámetros compatibles entren en vigor sin detener el servicio.
En cambio, modificar un parámetro que exige reinicio y limitarse a
recargar no es suficiente.

### Justificación de `ddl` y `mod`

`ddl` permite registrar sentencias de definición de objetos, como
`CREATE`, `ALTER` y `DROP`. Fue útil para observar la creación de
estructuras, los cambios de permisos y las modificaciones de tablas.

Después se utilizó `mod`, que registra sentencias que modifican datos,
como `INSERT`, `UPDATE`, `DELETE` y otras operaciones de modificación.
Este nivel no registra las consultas `SELECT` ordinarias. Por ello, el
registro aplicado permite observar modificaciones, pero no reconstruir
todas las lecturas de información sensible.

## 3. Eventos observados

La bitácora final contiene ejemplos de distintos tipos de eventos. Los
siguientes casos muestran qué información aporta cada uno:

1.  **Conexión y autenticación exitosa.** Se observa una conexión de
    `u_16540549_paulina_aldana` a `academia` desde `172.18.0.3`,
    utilizando pgAdmin. El registro distingue la recepción de la
    conexión, la autenticación y la autorización. Esto permite asociar
    una sesión con un usuario de base de datos, una base y un origen de
    red.

2.  **Desconexión.** PostgreSQL registra el cierre de sesiones e incluye
    su duración. Esto ayuda a delimitar cuánto tiempo permaneció abierta
    una conexión, aunque no demuestra por sí solo qué hizo el usuario
    durante toda la sesión.

3.  **Sentencias DDL.** La bitácora registra operaciones como
    `ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20)` y cambios de
    permisos mediante `GRANT` y `REVOKE`. Estas entradas permiten
    identificar cambios en la estructura y en los privilegios.

4.  **Sentencias DML.** Se registró el intento de `app_ventas` de
    actualizar el RFC del cliente 3 a `GAMA780912XYZ` en la base
    `comercial`. Inmediatamente después aparece el error
    `relation "clientes" does not exist`. Por tanto, la bitácora
    demuestra que se intentó ejecutar la sentencia, pero también
    demuestra que esa operación falló; no debe presentarse como un
    cambio realizado.

5.  **Error de permisos o dependencias.** Se intentó ejecutar
    `DROP ROLE soporte_ana`, pero PostgreSQL rechazó la operación porque
    el rol todavía tenía privilegios sobre objetos. El registro conserva
    la sentencia y el motivo del rechazo.

6.  **Autenticación fallida.** El usuario `app_ventas` intentó
    conectarse a `comercial` desde `127.0.0.1`, pero la autenticación
    falló por contraseña incorrecta. También aparecen intentos locales
    con los roles `postgres` y `estudiante`, rechazados porque esos
    roles no existían en el clúster.

7.  **Auditoría de operaciones sobre filas.** La tabla de auditoría
    registró el INSERT y el DELETE del cliente temporal Pedro Ruiz, así
    como cinco eventos UPDATE correspondientes al cambio de `segmento` a
    `regular` en los clientes con ID 1 a 5.

Los ejemplos anteriores muestran por qué es necesario leer conjuntamente
las sentencias y los mensajes de error: una línea `statement` no
equivale automáticamente a una operación exitosa.

## 4. Auditoría del dato

### Diseño de la tabla

En la base `academia` se creó el esquema `auditoria` y la tabla
`auditoria.cambios_clientes`. Su diseño incluye los siguientes campos:

-   `id_evento`: identificador consecutivo del evento (`BIGSERIAL` y
    clave primaria).
-   `momento`: fecha y hora del evento (`TIMESTAMPTZ`).
-   `usuario_sesion`: usuario que inició la sesión, con valor
    predeterminado `session_user`.
-   `usuario_efectivo`: identidad de ejecución capturada mediante
    `current_user`.
-   `aplicacion`: nombre de la aplicación, obtenido de
    `application_name`.
-   `ip_cliente`: dirección del cliente, obtenida mediante
    `inet_client_addr()`.
-   `operacion`: tipo de operación, por ejemplo INSERT, UPDATE o DELETE.
-   `id_cliente`: identificador de la fila afectada.
-   `valores_antes`: representación JSONB de la fila anterior.
-   `valores_despues`: representación JSONB de la fila posterior.

Los campos JSONB permiten conservar los valores de la fila antes y
después de una modificación, en lugar de registrar únicamente que se
ejecutó una sentencia. Para un INSERT no existe una fila anterior; para
un DELETE no existe una fila posterior. En un UPDATE se pueden comparar
ambas representaciones para identificar qué cambió.

### Papel de `SECURITY DEFINER`, `session_user` y `current_user`

La función del trigger se definió con `SECURITY DEFINER`. Esto significa
que se ejecuta con los privilegios del propietario de la función, no con
los privilegios ordinarios del usuario que provocó el evento. En este
laboratorio, esa característica permite que la función inserte registros
en el esquema de auditoría aunque el rol de la aplicación no tenga
permiso directo para escribir en esa tabla.

Esta decisión debe acompañarse de controles estrictos: el propietario de
la función debe ser una cuenta controlada, el esquema no debe permitir
que usuarios no confiables sustituyan objetos utilizados por la función
y el código debe evitar SQL dinámico inseguro. `SECURITY DEFINER` no
convierte el mecanismo en invulnerable; amplía los privilegios con los
que se ejecuta el código.

La diferencia entre las identidades es importante:

-   `session_user` representa el usuario que inició la sesión
    autenticada. Es útil para conservar la identidad de conexión
    original.
-   `current_user` representa el usuario efectivo en el contexto de
    ejecución. Dentro de una función `SECURITY DEFINER`, cambia al
    propietario de la función.

Por ello, si `usuario_efectivo` se llena con `current_user` dentro de la
función con privilegios de definidor, puede guardar el propietario de la
función y no el rol que ejecutó originalmente la sentencia. En ese
diseño, `session_user` es el dato más directo para identificar la cuenta
que abrió la conexión. No debe interpretarse ninguno de estos campos
como prueba de la identidad física de una persona.

### Resultado del incidente auditado

La auditoría registró siete eventos en el archivo CSV entregado:

-   Un INSERT del cliente temporal Pedro Ruiz, con ID 6.
-   Un DELETE posterior del mismo cliente.
-   Cinco UPDATE sobre los clientes con ID 1, 2, 3, 4 y 5, en los que el
    campo `segmento` quedó como `regular`.

La bitácora también muestra que, en la base `academia`, la cuenta
`u_16540549_paulina_aldana` deshabilitó el trigger
`trg_auditoria_clientes`, actualizó el RFC del cliente 3 a
`GAMA780912GHI` y después volvió a habilitar el trigger. Ese UPDATE no
aparece entre los eventos de la tabla de auditoría, precisamente porque
el trigger estaba deshabilitado.

En consecuencia, el registro de auditoría permite reconstruir las
operaciones que pasaron por el trigger, pero no contiene el valor
anterior del RFC para ese cambio. La bitácora conserva la sentencia y el
nuevo valor, pero tampoco registra el valor previo de la fila. No hay
evidencia suficiente en estos dos archivos para afirmar cuál era el RFC
antes de esa modificación.

También se observaron intentos de actualización del RFC a
`GAMA780912XYZ` y `GAMA780912ZZZ` por parte de `app_ventas` en
`comercial`. Esos intentos fallaron porque la tabla `clientes` no
existía en esa base. No deben confundirse con el cambio realizado en
`academia`.

## 5. Limitaciones

La configuración aplicada mejora la trazabilidad, pero no ofrece una
visión completa de toda actividad ni constituye por sí sola una garantía
de integridad.

-   **Lecturas no registradas.** Con `log_statement = mod` no se
    registran las consultas SELECT ordinarias. Por eso, no se puede
    reconstruir con la bitácora qué registros consultó un usuario ni
    demostrar todas las lecturas de información sensible. El laboratorio
    mostró además que una consulta puede fallar por estar conectada a
    una base distinta de aquella donde existe la tabla.
-   **Volumen de registros.** Registrar conexiones, desconexiones y
    sentencias de modificación genera archivos más grandes. En un
    entorno real se necesitan políticas de rotación, retención,
    almacenamiento, monitoreo y respaldo. Registrar todas las sentencias
    con `log_statement = all` aumentaría todavía más el volumen y podría
    exponer datos sensibles.
-   **Administrador con control total.** Una cuenta con privilegios
    suficientes puede modificar parámetros, cambiar permisos,
    deshabilitar triggers o alterar objetos. La auditoría dentro de la
    misma base no puede garantizar que un administrador con control
    total no manipule o evada el mecanismo.
-   **Identidad de la persona.** El log identifica roles, aplicaciones y
    direcciones de conexión, no necesariamente a la persona que estaba
    frente al equipo. Una cuenta compartida o comprometida debilita la
    atribución.
-   **Sentencia no equivale a éxito.** La bitácora puede registrar una
    sentencia que después falla. Es necesario revisar los errores
    asociados y, cuando exista, contrastar con la auditoría del dato.
-   **Cobertura limitada al objeto auditado.** El trigger se instaló
    para `clientes` en `academia`. No audita automáticamente tablas de
    otras bases de datos ni otras tablas que no tengan un mecanismo
    equivalente.

## 6. Riesgos de la bitácora

### Exposición de secretos

El registro de sentencias puede almacenar valores literales incluidos en
comandos SQL. Durante el laboratorio apareció una sentencia de creación
de rol con una contraseña en el texto SQL. Aunque la evidencia exportada
la presenta redactada, el caso demuestra el riesgo: una contraseña o
dato sensible puede quedar escrito en claro en la bitácora.

Los archivos de log deben tratarse como información sensible. Se deben
restringir los permisos de lectura, evitar incluir secretos en
sentencias, limitar el acceso a administradores autorizados y establecer
procedimientos para responder ante una exposición.

### Pérdida o alteración

Si los archivos permanecen únicamente dentro del contenedor o en el
mismo entorno administrado por quien opera la base, pueden perderse al
eliminar o recrear el contenedor, al fallar el almacenamiento o al
aplicar una política de rotación inadecuada. También pueden ser
eliminados o alterados por alguien con control suficiente sobre el
servidor o el sistema operativo.

Por eso, para un entorno real conviene enviar los registros a un sistema
externo de centralización, con acceso separado, retención definida,
respaldo y controles de integridad. La exportación externa reduce la
posibilidad de que un administrador de la base pueda modificar todas las
copias de evidencia.

### Acceso de terceros

Un usuario que obtenga acceso a la bitácora puede conocer nombres de
roles, bases, aplicaciones, direcciones IP, operaciones realizadas y,
potencialmente, valores sensibles incluidos en sentencias. No debe
concederse acceso general a los archivos de log ni a la tabla de
auditoría. Se requiere el principio de mínimo privilegio y una revisión
periódica de permisos.

## 7. Cronología y conclusión

La cronología reconstruida muestra, entre otros eventos, la habilitación
de parámetros de registro, conexiones exitosas y fallidas, cambios de
permisos, intentos fallidos de modificación en `comercial`, creación de
la tabla de auditoría, operaciones INSERT y DELETE sobre un registro
temporal, deshabilitación temporal del trigger, cambio del RFC del
cliente 3 y actualización masiva del campo `segmento`.

La evidencia permite afirmar que la cuenta `u_16540549_paulina_aldana`,
desde pgAdmin y el cliente `172.18.0.3`, ejecutó en `academia` la
secuencia de deshabilitar el trigger, actualizar el RFC del cliente 3 a
`GAMA780912GHI` y volver a habilitarlo. No permite demostrar qué persona
física utilizó esa cuenta ni cuál era el RFC anterior, porque el trigger
estaba deshabilitado y el log de sentencias no guarda automáticamente la
imagen anterior de la fila.

## Conclusión

Con la configuración aplicada puede demostrarse qué
cuenta de base de datos ejecutó determinadas sentencias, desde qué
aplicación y dirección de cliente, y qué cambios llegaron a registrarse
mediante el trigger. Cuando el trigger funciona, la tabla de auditoría
permite conservar los valores anteriores y posteriores de las filas. Sin
embargo, la configuración no garantiza por sí sola una trazabilidad
completa: las lecturas ordinarias no se registran con
`log_statement = mod`, los intentos fallidos deben distinguirse de las
operaciones exitosas y un administrador con privilegios suficientes
puede desactivar o alterar los mecanismos internos.

Por tanto, la respuesta a Dirección es parcial: se puede identificar la
cuenta que ejecutó el cambio del RFC y el nuevo valor, pero no se puede
demostrar con la evidencia disponible el valor anterior ni atribuir la
acción a una persona física. Para fortalecer la prueba se requiere
separar la administración de la base y la custodia de los logs,
centralizar los registros fuera del servidor, controlar las cuentas
privilegiadas y mantener auditoría de cambios y accesos desde antes de
que ocurra un incidente.
------------------------------------------------------------------------

# 29. Preguntas de reflexión

## 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque la auditoría no reconstruye automáticamente el pasado. Si antes
del incidente no se registraban conexiones, sentencias o imágenes de las
filas, esa información no queda disponible retroactivamente.
Configurarla después permite observar eventos futuros, pero no recuperar
de forma confiable quién hizo una operación anterior ni qué valores
tenía el dato antes del cambio. En este laboratorio, el valor anterior
del RFC no pudo recuperarse porque el trigger estaba deshabilitado
durante la modificación.

## 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Porque PostgreSQL es quien conoce y registra los eventos que ocurren
dentro del motor: conexiones, autenticaciones, sentencias, errores y
desconexiones. El mecanismo de despliegue crea y configura el entorno,
pero no sustituye al servidor como fuente de esos eventos. Además, si la
bitácora depende exclusivamente del proceso de despliegue, puede no
capturar lo que ocurre después de que el servicio queda funcionando. La
configuración administrada por PostgreSQL permite aplicar parámetros,
recargarlos y mantener los registros durante la operación del servidor.

Esto no significa que los logs deban quedarse únicamente dentro del
servidor: para proteger la evidencia, una copia debe enviarse a un
sistema externo que el administrador de la base no controle por
completo.

## 3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?

Porque `log_statement` determina qué sentencias se registran, pero el
prefijo aporta el contexto necesario para interpretarlas. Una sentencia
aislada puede no permitir saber qué usuario la ejecutó, en qué base,
desde qué aplicación o desde qué cliente. En el laboratorio, el prefijo
`%m [%p] user=%u db=%d app=%a client=%h` permitió asociar las sentencias
con la hora, el proceso, el usuario, la base, la aplicación y el host
cliente.

En otras palabras, registrar una sentencia sin contexto puede producir
evidencia difícil de atribuir; tener un buen prefijo sin registrar las
sentencias tampoco permite conocer qué operación se intentó ejecutar.
Ambos elementos se complementan.

## 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

Registrar la sentencia significa conservar el SQL que se intentó
ejecutar, por ejemplo `UPDATE clientes SET rfc = ...`. Esto permite
conocer la instrucción, pero no necesariamente demuestra que se ejecutó
correctamente ni cuál era el contenido previo de la fila.

Registrar el cambio en el dato significa conservar la fila anterior y la
posterior, junto con información de la operación. La tabla de auditoría
utiliza `valores_antes` y `valores_despues` en formato JSONB para ese
propósito. Así se puede comparar qué cambió realmente cuando el trigger
se ejecuta.

La diferencia quedó demostrada en el laboratorio: la bitácora registró
el UPDATE del RFC, pero el trigger estaba deshabilitado y no guardó el
valor anterior ni un evento de auditoría para esa operación.

## 5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?

`pg_stat_activity` ofrece una vista del estado actual de las sesiones y
procesos: qué usuarios están conectados, a qué bases, desde qué
direcciones, qué aplicación utilizan, cuánto tiempo llevan activos y,
según el estado y los permisos, qué consulta están ejecutando o cuál fue
la última consulta reportada. Es útil para supervisar actividad en
tiempo real y detectar sesiones activas o bloqueos.

La bitácora, en cambio, conserva eventos históricos que ya ocurrieron,
siempre que estuvieran habilitados y los archivos sigan disponibles.
Puede mostrar conexiones que ya terminaron, errores y sentencias
registradas en momentos anteriores.

Por eso no son sustitutos: `pg_stat_activity` es una fotografía dinámica
del estado del servidor; la bitácora es un historial de eventos
registrados. Una consulta a `pg_stat_activity` no permite reconstruir
por sí sola todas las sesiones pasadas, y la bitácora no necesariamente
muestra el estado actual de una sesión.

## 6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?

El propio mecanismo de auditoría interno no es suficiente si el
administrador puede controlarlo y desactivarlo. Se necesita una
separación de funciones: los registros deben enviarse en tiempo real a
un sistema externo administrado por otro equipo o rol, con permisos
independientes, retención protegida y controles de integridad. También
pueden utilizarse alertas ante cambios en parámetros de auditoría,
deshabilitación de triggers, modificaciones de roles y accesos
privilegiados.

En un entorno real, las acciones administrativas deben quedar sujetas a
controles adicionales, como cuentas individuales, autenticación fuerte,
revisión de cambios, aprobación para operaciones críticas y monitoreo
independiente. La idea central es que quien administra la base no debe
tener control exclusivo sobre la evidencia que permite auditarlo.