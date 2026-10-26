# LAB-04 — Hardening y configuración segura de PostgreSQL

## Objetivo

Aplicar y documentar medidas de hardening en PostgreSQL 16 para reducir la superficie de ataque, fortalecer la autenticación, controlar los privilegios de los usuarios y proteger las conexiones y los archivos de la base de datos. Asimismo, verificar la configuración de seguridad y establecer una línea base que permita mantener un entorno controlado.

## Entorno

- **Sistema gestor:** PostgreSQL 16.
- **Herramienta de administración:** pgAdmin 4.
- **Puerto predeterminado:** 5432.
- **Archivos de configuración relevantes:** `postgresql.conf` y `pg_hba.conf`.
- **Áreas revisadas:** red, autenticación, autorización, configuración, sistema operativo, cifrado y mantenimiento.

La configuración se revisó mediante consultas SQL ejecutadas desde pgAdmin. Algunas medidas, como la configuración del firewall, los permisos del sistema operativo y la edición de determinados archivos, requieren acceso al servidor y no pueden aplicarse únicamente desde el Query Tool.

## Superficie de ataque inicial

La superficie de ataque de PostgreSQL está compuesta por los puntos mediante los cuales un usuario o sistema puede intentar acceder al servidor o modificar la información almacenada. Entre los principales elementos se encuentran las interfaces de escucha, el puerto de conexión, las reglas de acceso de `pg_hba.conf`, las cuentas de usuario, los privilegios asignados y los servicios de red.

Una configuración que permita conexiones desde redes innecesarias, utilice reglas de acceso demasiado permisivas o conceda privilegios administrativos a cuentas de aplicación puede incrementar el riesgo de accesos no autorizados.

Para identificar la superficie de ataque se revisaron parámetros como `listen_addresses`, `port`, `ssl` y `password_encryption`, así como los roles existentes, las conexiones activas y las reglas de autenticación.

## Hallazgos

Durante la revisión de seguridad se identificaron los siguientes aspectos que deben verificarse y documentarse con los resultados reales del entorno:

- **Red:** comprobar si PostgreSQL escucha únicamente en interfaces locales o también en interfaces privadas o públicas.
- **Autenticación:** verificar el método utilizado por las reglas de `pg_hba.conf` y la configuración de las contraseñas.
- **Autorización:** identificar cuentas administrativas, privilegios elevados y permisos innecesarios.
- **Conexiones:** revisar las sesiones activas y determinar si existen conexiones que no sean necesarias.
- **Cifrado:** comprobar si TLS está habilitado y si los clientes verifican correctamente los certificados.
- **Extensiones:** identificar los componentes instalados y determinar cuáles son necesarios.
- **Sistema operativo:** comprobar los propietarios y permisos de los archivos de datos, configuración y respaldos.
- **Mantenimiento:** revisar la política de actualizaciones, registros y respaldos.

Los hallazgos definitivos deben completarse con las salidas obtenidas durante la práctica. No se debe afirmar que una configuración es vulnerable o que un control fue corregido sin haberlo comprobado.

## Cambios realizados

Las siguientes medidas constituyen la propuesta de hardening para el laboratorio. Deben marcarse como aplicadas únicamente cuando se hayan ejecutado y verificado.

1. Revisar y restringir `listen_addresses` a las interfaces necesarias.
2. Revisar `pg_hba.conf` para permitir conexiones únicamente desde orígenes autorizados.
3. Establecer `scram-sha-256` como método de almacenamiento predeterminado para nuevas contraseñas y comprobar la compatibilidad de los clientes.
4. Separar las cuentas administrativas de las cuentas utilizadas por las aplicaciones.
5. Aplicar el principio de mínimo privilegio mediante roles y permisos específicos.
6. Revisar el uso del puerto 5432 y restringir el acceso mediante el firewall.
7. Verificar la configuración de TLS y la validación de certificados.
8. Revisar las extensiones instaladas y conservar únicamente las necesarias.
9. Comprobar los permisos del sistema operativo sobre los archivos de PostgreSQL.
10. Habilitar y revisar los registros de conexiones y desconexiones cuando corresponda.
11. Establecer un procedimiento de actualización, revisión periódica y respaldo.

Los cambios de red, autenticación y permisos deben realizarse de manera controlada para evitar interrupciones en los servicios que dependen de la base de datos.

## Justificación de los cambios

Las medidas propuestas buscan reducir la exposición del servidor y limitar las consecuencias de un acceso no autorizado.

- Restringir las interfaces de escucha y el tráfico del firewall reduce las posibilidades de conexión desde redes innecesarias.
- Configurar adecuadamente `pg_hba.conf` permite controlar qué usuarios y equipos pueden intentar conectarse.
- Utilizar autenticación segura protege las credenciales frente a métodos de almacenamiento o validación menos robustos.
- Aplicar el principio de mínimo privilegio limita las operaciones que puede realizar cada cuenta.
- Utilizar TLS con certificados verificados protege la comunicación entre los clientes y el servidor.
- Restringir los permisos de archivos impide que usuarios no autorizados accedan directamente a la información o a la configuración.
- Revisar extensiones, registros y actualizaciones ayuda a detectar problemas y mantener el servidor protegido.
- Mantener respaldos protegidos y comprobar su restauración contribuye a la continuidad operativa.

Cambiar únicamente el puerto no representa una medida suficiente de hardening, ya que no sustituye los controles de acceso, la autenticación segura ni la configuración adecuada de los privilegios.

## Verificación

La verificación se realiza mediante consultas SQL y revisiones de configuración.

### Versión y parámetros de seguridad

```sql
SELECT version();

SELECT name, setting, source, pending_restart
FROM pg_settings
WHERE name IN (
    'listen_addresses',
    'port',
    'password_encryption',
    'ssl',
    'max_connections',
    'log_connections',
    'log_disconnections'
)
ORDER BY name;
```

### Reglas de autenticación

```sql
SELECT
    line_number,
    type,
    database,
    user_name,
    address,
    auth_method,
    error
FROM pg_hba_file_rules
ORDER BY line_number;
```

### Revisión de roles y privilegios elevados

```sql
SELECT
    rolname,
    rolsuper,
    rolcreatedb,
    rolcreaterole,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;
```

### Conexiones y uso de TLS

```sql
SELECT
    a.usename,
    a.datname,
    a.client_addr,
    s.ssl,
    s.version AS tls_version
FROM pg_stat_activity AS a
LEFT JOIN pg_stat_ssl AS s
    ON a.pid = s.pid
ORDER BY a.usename, a.datname;
```

### Extensiones instaladas

```sql
SELECT extname, extversion
FROM pg_extension
ORDER BY extname;
```

Las consultas permiten documentar el estado de PostgreSQL, pero no verifican por sí solas todos los controles. La exposición a Internet debe comprobarse mediante la configuración de red y el firewall; los permisos de los archivos deben revisarse en el sistema operativo; y la protección de TLS requiere verificar tanto el servidor como los clientes.

## Checklist de hardening

- [ ] Se identificaron las interfaces de escucha necesarias.
- [ ] Se verificó el puerto y se restringió el acceso mediante el firewall.
- [ ] Se revisaron las reglas de `pg_hba.conf`.
- [ ] Se verificó el método de autenticación.
- [ ] Se revisaron las cuentas administrativas y sus privilegios.
- [ ] Las cuentas de aplicación utilizan privilegios mínimos.
- [ ] Se revisaron las conexiones activas.
- [ ] Se verificó la configuración TLS y la validación de certificados.
- [ ] Se identificaron las extensiones instaladas.
- [ ] Se comprobaron los propietarios y permisos de los archivos.
- [ ] Se revisaron los registros de actividad.
- [ ] Se estableció un procedimiento de actualización.
- [ ] Se documentaron los cambios y sus resultados.
- [ ] Se verificó la existencia y restauración de respaldos.

Las casillas deben marcarse únicamente después de comprobar cada control. Si una medida no se pudo verificar o no se aplicó, debe documentarse como pendiente.

## Conclusiones

El hardening de PostgreSQL requiere combinar controles de red, autenticación, autorización, cifrado y protección del sistema operativo. Ninguna medida aislada garantiza la seguridad del servidor; por ello, es necesario establecer varias capas de protección y verificar que funcionen correctamente.

La revisión de la configuración permite identificar posibles puntos de exposición, mientras que la aplicación del principio de mínimo privilegio limita el acceso a los recursos de la base de datos. Asimismo, el monitoreo, las actualizaciones y los respaldos contribuyen a detectar incidentes y mantener la continuidad del servicio.

Finalmente, la línea base de seguridad debe mantenerse documentada y revisarse periódicamente. Los cambios en la infraestructura, las aplicaciones o los usuarios pueden modificar los riesgos, por lo que la seguridad debe considerarse un proceso continuo y no una configuración que se realiza una sola vez.
