# 18. Actividad 12 — Privacidad por diseño

Analiza el siguiente escenario:

Una nueva aplicación requiere registrar clientes.

El desarrollador propone:

> CREATE TABLE clientes (

    id BIGSERIAL,
    nombre TEXT,
    correo TEXT,
    telefono TEXT,
    rfc TEXT,
    edad INTEGER,
    direccion TEXT,
    ciudad TEXT,
    codigo_postal TEXT,
    fecha_nacimiento DATE,
    ocupacion TEXT,
    salario NUMERIC,
    estado_civil TEXT,
    ...
> );

La justificación es:

>“Es mejor guardar todos los datos por si posteriormente necesitamos alguno.”

## Preguntas
**¿Qué problemas identificas?**

Existe una recolección excesiva de datos y una falta de privacidad por diseño, así como una falta de finalidad definida, haciendolo susceptible a riesgos de seguridad, que por consiguiente podría resultar en costos adicionales, dificultad para gestionar la información.  

**¿Qué principio de privacidad se está ignorando?**

El de minimización de datos, porque carece de que los datos personales recopilados sean adecuados y limitados a lo necesario para cumplir con una finalidad específica.

Así como los principios de limitación de la finalidad y privacidad por diseño y por defecto, porque se pretende recopilar información desde el inicio sin justificar su necesidad.

**¿Qué preguntas realizarías antes de aprobar el diseño?**

- ¿Cuál es la finalidad principal de la aplicación?
- ¿Qué datos son indispensables para registrar y atender a un cliente?
- ¿Para qué se utilizará cada campo?
- ¿Existe una obligación legal o contractual que justifique recopilar determinados datos?
- ¿Quiénes necesitan acceder a cada campo?
- ¿Durante cuánto tiempo se conservará la información?
- ¿Se pueden alcanzar los mismos objetivos utilizando menos datos?
- ¿Es posible utilizar datos agregados o anonimizados para los análisis?
- ¿Cómo se protegerán los datos?

**¿Qué datos eliminarías?**

- salario
- estado civil
- ocupación
- fecha de nacimiento
- edad
- dirección

**¿Qué datos requerirían una justificación adicional?**

- ***rfc;*** se debe determinar si es indispensable para facturación u otra obligación fiscal.
- ***telefono;*** se debe confirmar si se necesita para contactar al cliente o prestar el servicio.
- ***direccion;*** primero verificar si es necesaria para entregas, contratos u otros procesos.
- ***codigo_postal;*** determinar si es necesario para entregas, facturación o análisis geográfico.
- ***fecha_nacimiento;*** justificar si es necesaria para verificar la edad o cumplir requisitos específicos.

**¿Cómo aplicarías privacidad por defecto?**

Aplicaría privacidad por defecto mediante las siguientes medidas:
1. Recopilar únicamente los datos indispensables, evitando campos opcionales sin una finalidad definida.
2. Configurar permisos restringidos, permitiendo que cada usuario acceda solamente a la información necesaria para sus funciones.
3. Proteger los datos almacenados, utilizando controles de acceso, cifrado cuando corresponda y mecanismos de autenticación adecuados.
4. Establecer periodos de retención, eliminando o anonimizando los datos cuando dejen de ser necesarios, salvo que exista una obligación justificada de conservarlos.
5. Limitar el uso secundario, evitando utilizar los datos para finalidades distintas de las informadas y autorizadas cuando corresponda.
6. Evitar la exposición innecesaria, ocultando datos personales en reportes y utilizando información agregada o anonimizada para analítica cuando sea posible.
7. Diseñar formularios con campos opcionales, cuando la información no sea indispensable para prestar el servicio.

## Conclusión

Si se aplica la privacidad por diseño es posible incorporar la protección de los datos personales desde las primeras etapas del desarrollo de una aplicación, evitando la recopilación excesiva de información sin una finalidad justificada. Es importante que cada dato solicitado sea necesario para el servicio, que su acceso esté restringido según las funciones de cada usuario y que se establezcan medidas de seguridad y tiempo de retención adecuados. Una aplicación responsable no debe almacenar todos los datos que podrían ser útiles en el futuro, sino únicamente aquellos que son necesarios para cumplir sus objetivos.