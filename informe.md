## 7. Actividad 1 — Clasificación de los datos

| **Campo** | **¿Identifica directamente?** | **¿Puede contribuir a identificar?** | **¿Requiere protección?** | **Justificación** |
|---|---|---|---|---|
| `id` | No por sí solo | Sí | Sí | Es un identificador interno que puede vincularse con otros registros y revelar la identidad de una persona. |
| `nombre` | Sí | Sí | Sí | Permite identificar a una persona, especialmente si incluye nombre y apellidos. |
| `correo` | Sí, si es personal | Sí | Sí | Puede identificar directamente a una persona cuando está asociado con su nombre o cuenta personal. |
| `telefono` | Sí, si es personal | Sí | Sí | Puede vincularse con una persona mediante directorios, cuentas u otras bases de datos. |
| `rfc` | Sí | Sí | Sí | Es un identificador fiscal que permite asociar información con una persona física. |
| `edad` | No por sí sola | Sí | Sí | Puede ayudar a identificar a alguien al combinarse con otros datos, como ciudad y código postal. |
| `ciudad` | No por sí sola | Sí | Sí | Reduce el conjunto de personas posibles y puede facilitar la identificación al combinarse con otros atributos. |
| `codigo_postal` | No por sí solo | Sí | Sí | Delimita una zona geográfica y puede contribuir a identificar a alguien junto con su edad u otros datos. |
| `fecha_alta` | No por sí sola | Sí | Sí | Puede relacionarse con registros de otras fuentes y ayudar a distinguir a una persona de las demás. |

## Preguntas

**1. ¿Qué campos identifican directamente a una persona?**

Los campos `nombre`, `correo`, `telefono` y `rfc` pueden identificar directamente a una persona, dependiendo de su contenido y contexto. El RFC es especialmente útil para identificar fiscalmente a una persona física.

**2. ¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo?**

Los campos `id`, `edad`, `ciudad`, `codigo_postal` y `fecha_alta` generalmente no identifican por sí solos a una persona, pero pueden contribuir a su identificación al relacionarse con otros datos o bases de datos externas.

**3. ¿Qué combinación de campos podría incrementar el riesgo de reidentificación?**

La combinación de `edad`, `ciudad`, `codigo_postal` y `fecha_alta` podría incrementar el riesgo de reidentificación, porque reduce el número de personas que coinciden con esas características. Si además se combina con el `nombre`, el `correo` o el `rfc`, la identificación puede resultar mucho más sencilla.

**4. ¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?**

No. Los datos personales que requieren protección no son necesariamente datos personales sensibles en términos jurídicos. Por ejemplo, el nombre, el teléfono y el correo son datos personales, pero no se consideran automáticamente sensibles. Los datos personales sensibles son aquellos que pertenecen a categorías especiales, como información sobre la salud, la genética o aspectos íntimos cuya utilización indebida puede generar discriminación o un riesgo grave para la persona. Sin embargo, los datos personales ordinarios también deben protegerse para evitar accesos no autorizados, divulgaciones o usos indebidos.

## 8. Actividad 2 — Enmascaramiento (masking)

### **Preguntas**

**¿Qué información continúa existiendo en la tabla original?** 

Toda la información continua existiendo dentro de la tabla original y es visible si tienes acceso desde el rol en el que se encuentre. Sin embargo, si sólo se tiene acceso a la vista no es posible visualizar la información completa, porque la vista no la proporciona, ni acceder a la tabla original.

**¿Qué información puede visualizar el usuario soporte?**

De manera integral puede visualizar el id y nombre. También tiene acceso de manera parcial al correo, telefono y rfc. Es decir, obtiene una parte de ellos de cada cliente pero no tiene acceso al dato completo.

**¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?**

No es suficiente ocultar los datos únicamente en la aplicación porque alguien podría acceder a ellos directamente desde la base de datos, mediante consultas SQL o con permisos inadecuados. Por eso, es necesario implementar controles de seguridad también en la base de datos, como permisos, roles y restricciones de acceso, para evitar que personas no autorizadas consulten información confidencial.

**¿Qué ocurriría si soporte tuviera acceso directo a clientes?**

Podría hacer mal uso de la información. Aumentaría el riesgo de filtraciones, uso indebido de datos y accesos no autorizados, en caso de también contar con ellos. Por ello deben de aplicarse permisos de acceso según las responsabilidades de cada usuario y permiti que soporte consulte únicamente la información necesaria para su trabajo.

### Explicación del mecanismo utilizado

Para implementar el enmascaramiento en PostgreSQL se creó una vista donde se le permitia al personal de soporte consultar la información de los clientes sin mostrar completamente sus datos personales, solamente podían visualizar el id y nombre del cliente, pero los datos de: correo, teléfono y rfc aparecían parcialmente, ya que se mostraban enmascarados.

El mecanismo de enmascaramiento utiliza funciones de cadenas de texto para transformar los valores originales al momento de realizar una consulta. Haciendo uso de funciones como `left()`, `right()`, por mencionar algunas, se transforman los valores para ocultar parte de su contenido, permitiendo prácticas cómo: verificar que el cliente sí pertenezca a ese registro sin que el personal de soporte tenga acceso a la información completa de éste.

Este mecanismo protege la visualización de los datos mediante una vista de acceso restringido. Sin embargo, los valores originales permanecen almacenados en la tabla `clientes`; por lo tanto, el enmascaramiento no elimina ni modifica la información original, sino que presenta una versión parcialmente oculta al usuario autorizado para consultar la vista.

## 11. Actividad 4 — Separación de funciones
### Preguntas
**¿Qué ocurriría si analista pudiera consultar también pii.mapa_cliente?**

Podría visualizar el id cliente al que pertenece el token. Es decir, podría identificar a qué cliente pertenece la información que analiza y se presentaría un riesgo al contar con dicha vulnerabilidad. 

**¿Qué principio de seguridad se está aplicando al separar ambos accesos?**

Se aplica el principio de mínimo privilegio, que consiste en otorgar a cada usuario únicamente los permisos necesarios para realizar sus funciones. Al separar el acceso a los datos analizados del acceso al mapa que los relaciona, se reduce el riesgo de que el analista pueda identificar a los clientes. También se aplica la separación de funciones, al mantener diferenciados los accesos a la información y a la identificación de los clientes.

**¿Por qué la seudonimización no equivale a anonimización?**

Porque en la seudonimización se considera que es revertible, ya que es posible recuperar la identidad si se cuenta con información adicional, como el mapa que relaciona los tokens con los clientes. Por otro lado la anonimización busca impedir que se pueda identificar a la persona, aún al combinar datos con otra información disponible. La seudonimización reduce los riesgos para la privacidad, pero no elimina por completo la posibilidad de que los clientes sean identificados.

**¿Qué información permite volver a relacionar el token con una persona?**

Si se cuenta con el acceso a la tabla de correspondencia `pii.mapa_cliente`, donde se vincula cada token con el cliente, se combina ese id con la tabla `public.clientes` y se recupera la identidad del cliente para acceder a sus datos personales, en este caso nombre, correo, telefono, rfc, edad, ciudad, codigo postal y fecha de alta.

## 12. Actividad 5 — Anonimización (anonymization)

### 13. Actividad 6 — Análisis del riesgo de reidentificación

**¿Qué identificadores directos fueron eliminados?**

Aquellos que permiten reconocer a un cliente, como el nombre, correo, telefono, rfc y fecha de alta. 

**¿Qué cuasi-identificadores permanecen?**

La edad generalizada en rangos, la región obtenida apartir de los dos primeros dígitos del código postal. Aunque estos atributos no identifican directamente a una persona, pueden facilitar su identificación si se combinan con otros datos.

**¿Qué combinaciones de atributos podrían reducir el anonimato?**

Combinar el rango de edad y la región puede reducir el anonimato, especialmente si existen pocos clientes con esas características. El riesgo se puede aumentar al agregar otros atributos que en este ejemplo no se han agregado, tales como género, ocupación o fecha de nacimiento.

**¿Qué sucede cuando un grupo contiene pocos registros?**

Aumenta el riesgo de reidentificación, ya que es más fácil distinguir a una persona dentro de un grupo pequeño. Para ello se utiliza el método de `k-anonimato`, con la función `HAVING COUNT(*) >= 5`, donde se excluyen aquellos grupos que tienen menos de cinco registros.

**¿Qué atributos deberían generalizarse?**

Aquellos que permitan identificar indirectamente a los clientes, como la edad y el código postal. Es posible aplicar técnicas cómo el uso de regiones más amplias o rangos de edad menos específicos para reducir el riesgo de identificación.

**¿Qué información debería suprimirse?**

Los identificadores directos como nombres, teléfonos, correos, rfc, así como los grupos estadísticos con menos de cinco registros. En caso de contar con atributos sensibles o demasiado específicos también deberían verse excluidos cuando su publicación represente un riesgo de reidentificación.

**¿Es correcto afirmar que el conjunto de datos es “100 % anónimo”? ¿Por qué?**

No, porque se eliminaron identificadores directos, generalizaron algunos atributos y se suprimieron grupos pequeños, pero todavía existe la posibilidad de reidentificación mediante la combinación con otras fuentes de información. Aplicar esos métodos y el umbral de cinco registros reduce ciertos riesgos, pero no garantiza el anonimato absoluto.

### Reto

**Cambio realizado**

Se modificó la consulta SQL para generalizar los rangos de edad, ampliar la agrupación geográfica utilizando únicamente el primer dígito del código postal y mantener un umbral mínimo de cinco registros por grupo mediante la cláusula HAVING COUNT(*) >= 5.

**Motivo**

Con ello es posible reducir el nivel de detalle de los datos y evitar que la 
dirección de la empresa tenga acceso a grupos de clientes demasiado 
específicos. De esta forma podemos conservar la información estadística útil 
para el análisis general de la misma, sin mostrar registros individuales o que 
sean sencillos de reidentificar.

**Resultado obtenido**

En relación con lo comentado en el apartado de cambio realizado, no se 
presentan datos en el resultado de la consulta ya que se cuenta con la buena 
práctica de buscar disminuir grupos pequeños con registros menores a cinco, 
esto ocasiona que no se visualicen resultados en la coincidencia de las 
sentencias escritas. Sin embargo, si contáramos con mayor cantidad de 
clientes registrados lo que se debería visualizar es una tabla con menor detalle 
que la consulta que resultaría de contar con los rangos anteriores. 

**Riesgo que se pretende reducir**

Se busca disminuir el riesgo de reidentificación de los clientes mediante la combinación de atributos como la edad y la ubicación geográfica. Al 
generalizar se reduce la precisión de los atributos, así como el buscar evitar 
mostrar grupos pequeños, lo que podría facilitar la identificación de una 
persona.

## 14. Actividad 7 — Retención de datos

### Documentar:

**Registros que serían afectados**

En esta práctica: ninguno.

**Justificación del periodo**

Según el Código Fiscal de la Federación en el articulo 30 se obliga a conservar la contabilidad y su documentación comprobatoria por 5 años, entonces mntener ese periodo se considera razonable si los datos permiten respaldar facturas o ventas.

Por otro lado, también se cumple el principio de minimización si se limita ese plazo de conservación, ya que la normativa mexicana de protección de datos personales indica que no se debe conservar información más tiempo del necesario para su finalidad. 

Además de que ejercer esta práctica nos permite minimizar el riesgo de filtración, debido a que menos datos almacenados significa menor cantidad de datos expuestos a una filtración.

**Aprobación que debería existir antes de eliminar información**

Antes de cualquier `DELETE` debe existir una aprobación del responsable de los datos, el dueño del área de negocio. Además de un visto bueno del departamento legal, quienes confirmarían que no hay retenciones legales, lítigios ni auditorías en curso.

Una autorización del responsable de TI o del DBA. Así como una solicitud o ticket de esta acción con fecha, alcance (conteo de registros afectados) y quién aprueba.

**Respaldo que debería existir**

Un respaldo completo verificado de toda la base de datos antes de que se ejecute mencionado cambio. Así como una prueba de que se puede restaurar.

Una copia de los registros a eliminar, se sugiere tenerlo en una tabla de archivo o un export cifrado con acceso restringido.

**Evidencia que debería conservarse**

- Consulta ejecutada y su resultado (coneto antes y después).
- Ticket o solicitud de aprobación con nombres, fechas y firma.
- Política de retención vigente en la que se basó la acción.
- Log de la ejecución (quién, cuándo y cuántos registros).
- Acta de eliminación, no datos personales, sólo conteos y IDs.
- Respaldo y prueba de restauración.

**Procedimiento que permitiría recuperar información eliminada accidentalmente**

1. Detener cualquier proceso adicinal y avisar al responsable
2. Identificar el alcance: qué registros y desde cuándo, con el log.
3. Restaurar desde la tabla de archivo.
4. Si no, restaurar el respaldo. En un entorno aparte y extraer solo lo necesario.
5. Validar integridad y documentar el incidente.

## Conclusiones

**¿Qué técnica utilizarías para un área de soporte?**

Enmascaramiento, dado que deben identificar al cliente y atender su caso, pero no ver todos sus datos. El enmascaramiento al implementar una vista que sólo expone las columnas necesarias cubre dicha actividad.

**¿Qué técnica utilizarías para un área de analítica?**

La seudonimización, dado que necesitan seguir el comportamiento por cliente, es decir, sus compras, recurrencia, entre otros, todo sin saber quién es. Si se remplaza el identificador por un seudónimo consistente se puede cruzar los datos entre tablas sin exponer la identidad.

**¿Qué técnica utilizarías para publicar estadísticas?**

Anonimización, ya que al publicar estadísticas no debe ser posible identificar a nadie. Si se usa agregación, generalización, supresión de grupos muy pequeños y técnicas cómo k-anonimato permitiría cumplir con esa responsabilidad.

**¿Por qué ninguna de estas técnicas sustituye al control de acceso?**

Porque sólo se está protegiendo el contenido, no quién entra. El control de acceso decide quién puede consultar qué. Estas técnicas solo transforman lo que se ve. Si un usuario tiene permisos sobre la tabla original el enmascaramiento de una vista no sirve para nada.

## 20. Preguntas de reflexión
Responder individualmente:

**¿Cuál es la diferencia entre enmascaramiento y seudonimización?**

El enmascaramiento oculta parte del dato para que no se visualice completo. Busca proteger la visualización y normalmente no se puede revertir desde lo que se ve. La seudonimización reemplaza el identificador por un seudónimo que mantiene la consistencia entre tablas y que sí se puede revertir con información adicional guardada aparte que es el mapa. Busca que se pueda analizar sin identificar directamente. Es decir, cada una cumple una función y tienen un mecanismo distinto, así como un nivel de seguridad o riesgo diferente.

**¿Por qué la seudonimización no significa anonimización?**

Porque la identidad aún es recuperable, existe un mapa o una clave que vincula el seudónimo a la persona, además que el resto de los atributos puede permitir reidentificar. La anonimización exige que la reidentificación no sea razonablemente posible, incluso para quien comparta o cruce los datos.

**¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo?**

Porque eso sólo elimina identificadores directos. Aún quedan otros campos como codigo postal, ciudad, edad, incluso el correo que son datos que permiten señalar a una persona única o cruzarse con fuentes externas.

**¿Qué función tienen los cuasi-identificadores?**

Son atributos que por sí solos no identifican, pero al combinarloa sí pueden hacerlo. Son la vía principal de los ataques de reidentificación por vinculación. Identificarlos permite aplicar generalización, supresión o k-anonimato antes de compartir los datos.

**¿Por qué es importante separar el mapa de seudonimización?**

Porque si está junto con los datos seudonimizados cualquiera con acceso al conjunto puede revertir el proceso y la seudonimización perdería de todo su sentido. Guardarlo por separado, en otro esquema, otra base o un sistema con acceso restringido, obliga al atacante a comprometer dos sistemas en lugar de uno.

**¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?**



**¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?**

**¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?**

**¿Por qué la retención forma parte de la protección de datos?**

**¿Qué riesgo existe si una organización conserva información indefinidamente?**
