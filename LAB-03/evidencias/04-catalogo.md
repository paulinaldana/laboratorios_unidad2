# 10. Actividad 4 — Catálogo mínimo de datos

## Catálogo

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
|---|---|---|---|---|---|---|---|---|---|---|
| CAT-01 | Clientes | PostgreSQL 16 | postgres / academia / public.clientes | Gerencia Comercial | DBA | Confidencial | Sí | Gestión y consulta de información de clientes | Según política de conservación de clientes | diccionario-clientes.csv |
| CAT-02 | Auditoría de clientes | PostgreSQL 16 | postgres / academia / auditoria.cambios_clientes | Seguridad / Auditoría | DBA | Confidencial | Sí | Registrar cambios realizados sobre los datos de clientes | Según política de auditoría y obligaciones legales | Por elaborar |
| CAT-03 | Registro de cambios | PostgreSQL 16 | postgres / academia / gobierno.solicitudes_cambio | Gerencia Comercial / Seguridad | DBA | Confidencial | Puede contenerlos | Registrar y dar seguimiento a solicitudes de modificación de datos | Según política de solicitudes y auditoría | Por elaborar |
| CAT-04 | Clientes (tienda) | MongoDB 7 | <servidor-mongo> / comercial / clientes | Gerencia Comercial | Administrador MongoDB | Confidencial | Sí | Gestión de información de clientes de la tienda | Según política de conservación de clientes | Por elaborar |
| CAT-05 | Perfilado | MongoDB 7 | <servidor-mongo> / comercial / system.profile | DBA / Seguridad | Administrador MongoDB | Confidencial | Puede contenerlos | Registrar operaciones y consultas para analizar el comportamiento y rendimiento del motor | Según política de registros técnicos | Por elaborar |

## Preguntas 

1. **¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?**

Porque la finalidad de un conjunto de datos no determina por sí sola su clasificación. CAT-02 registra los cambios realizados sobre los clientes y puede almacenar información anterior y nueva, incluyendo nombres, RFC, teléfonos y otros datos personales.

Por su parte, CAT-05 registra operaciones ejecutadas en MongoDB. Las consultas pueden incluir identificadores, nombres, correos electrónicos u otros valores relacionados con clientes. Aunque su propósito sea analizar el comportamiento del sistema, puede almacenar información personal de manera indirecta.

Por ello, ambos conjuntos deben protegerse de acuerdo con el tipo de información que contienen y no solamente según su finalidad técnica.

2. **¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?**

Se presenta un problema de consistencia e integridad de la información. Si ambos conjuntos almacenan información del mismo cliente, pero tienen propietarios distintos, puede existir incertidumbre sobre quién tiene la autoridad para validar y aprobar la corrección.

Por ejemplo, PostgreSQL podría almacenar un RFC y MongoDB otro. Si no existe una responsabilidad claramente definida, cada área podría considerar que su registro es el correcto.

Para evitarlo, la organización debe establecer:
- Un responsable autorizado para determinar cuál es el dato correcto.
- Un procedimiento de conciliación entre ambos motores.
- Un mecanismo para registrar y auditar las correcciones.
- Reglas para mantener sincronizada la información.

Importante: tener dos propietarios distintos no necesariamente es incorrecto. El problema aparece cuando no se definen las responsabilidades y la autoridad para resolver discrepancias.

3. **¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?**

La información que suele cambiar con mayor frecuencia es:
- La cantidad estimada de registros y el tamaño de las tablas.
- La ubicación de los datos cuando se modifican servidores, bases o esquemas.
- Los custodios cuando cambia el personal responsable de la administración.
- La finalidad cuando cambia el uso de los datos.
- La clasificación cuando se incorporan nuevos campos o información sensible.
- Los diccionarios cuando se agregan, eliminan o modifican columnas.

La actualización debe distribuirse según la responsabilidad de cada dato:

- DBA y administradores de bases de datos: información técnica, ubicación, tamaño, estructura y diccionarios.
- Propietarios de los datos: finalidad, clasificación, autorización de uso y conservación.
- Responsables de seguridad o auditoría: políticas de acceso, controles y requisitos de auditoría.

El catálogo debe mantenerse como un documento vivo y actualizarse cuando ocurran cambios relevantes, no solamente cuando se realice una actividad académica.

## Conclusión

Esta actividad permitió comprender la importancia de mantener un catálogo que integre los activos de información de diferentes motores de bases de datos. La consulta a los metadatos de PostgreSQL permite identificar características técnicas de las tablas, mientras que el catálogo complementa esta información con responsabilidades organizacionales, clasificación, finalidad y conservación. También se identificó que los datos de auditoría y perfilado pueden contener información personal, por lo que requieren controles de protección. Finalmente, mantener actualizado el catálogo permite mejorar la trazabilidad, la consistencia y la administración de los datos dentro de una organización.