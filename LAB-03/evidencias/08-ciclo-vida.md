# 14. Actividad 8 — Derecho de cancelación y ciclo de vida

## 1. Objetivo
Analizar el proceso de cancelación de los datos personales de un cliente, identificando las tablas relacionadas, los respaldos, las réplicas, los registros de auditoría, las copias analíticas, las exportaciones y los sistemas externos que podrían conservar su información, sin ejecutar eliminaciones en la base de datos principal.

## 2. Procedimiento
1. Se identificaron los posibles lugares donde podría almacenarse información relacionada con un cliente.
2. Se elaboró un mapa de los componentes que podrían conservar copias de sus datos.
3. Se consideraron las tablas relacionadas, los respaldos, las réplicas, los reportes, las exportaciones y los sistemas externos.
4. Se analizó la necesidad de revisar cada componente antes de ejecutar una eliminación definitiva.
5. No se ejecutó ningún comando DELETE sobre la tabla principal, ya que la actividad se centra en el análisis del ciclo de vida de los datos.

## 3. Resultado
Se obtuvo un mapa de los posibles lugares donde puede permanecer almacenada la información de un cliente después de autorizarse su cancelación. Se identificó que la tabla principal es solamente uno de los componentes que deben revisarse para determinar el alcance de la eliminación.

No se realizaron modificaciones ni eliminaciones en la base de datos.

## 4. Análisis
**¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?**

Eliminar un registro de la tabla principal no garantiza que toda la información de una persona haya desaparecido de la organización, porque sus datos pueden encontrarse duplicados en otros sistemas o archivos.

Por ejemplo, los respaldos pueden conservar versiones anteriores de la base de datos, las réplicas pueden mantener copias de los registros y los reportes o archivos exportados pueden contener información que ya no aparece en la tabla original. Asimismo, los sistemas externos pueden conservar datos enviados previamente.

Por ello, es necesario establecer un procedimiento que permita localizar las copias existentes, determinar cuáles deben eliminarse o anonimizarse y verificar que se cumpla con las obligaciones de conservación y eliminación aplicables. Los registros de auditoría y ciertos respaldos pueden estar sujetos a requisitos especiales de conservación, por lo que no necesariamente deben eliminarse de inmediato.

## 5. Conclusión
El derecho de cancelación requiere considerar el ciclo de vida completo de los datos personales, no solamente como eliminarlos de una tabla. Para realizar correctamente esta solicitud la organización debe identificar dónde conserva la información, revisar si hay relaciones o copias y aplicar las medidas correspondientes. Esto permite evitar que los datos permanezcan accesibles en otros lugares después del proceso de cancelación.