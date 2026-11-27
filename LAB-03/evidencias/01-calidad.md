# 7. Actividad 1 — Calidad de datos desde la operación

## Registro de hallazgos

|#	|Hallazgo	|Registros	|Regla de calidad	|¿Quién decide la corrección?	|Acción propuesta
| --------- | --------- | --------- | --------- | --------- | --------- |
C1	|Posible cliente duplicado	|1 y 7	|Unicidad del correo	|Área comercial o responsable de clientes	|Verificar si corresponden a la misma persona antes de fusionar o eliminar registros.
C2	|RFC incompleto o ausente	|7 y 8	|Validez y completitud del RFC	|Responsable de datos o área administrativa, con el cliente como fuente de confirmación	|Solicitar documentación o confirmación del RFC correcto antes de modificarlo.
C3	|Correo con formato no válido	|8	|Validez del correo electrónico	|Área comercial o responsable de clientes	|Solicitar un correo válido al cliente y actualizarlo después de verificarlo.
C4	|Edad fuera de rango	|8	|Validez y consistencia de los datos	|Área responsable del registro de clientes	|Confirmar la edad correcta con el cliente y corregir el registro.

**Hallazgo adicional:** el teléfono de Jorge (667) también parece incompleto y su código postal (8000) tiene una longitud menor a la esperada para un código postal mexicano. Sin embargo, las consultas proporcionadas no verifican esos dos campos, por lo que deben agregarse validaciones específicas para detectarlos formalmente.

Una precisión: el RFC de Ana (LOAA850315AB) aparece como inválido según la expresión regular porque tiene solamente dos caracteres al final, en lugar de tres. No significa que debas inventar el carácter faltante.

## Preguntas 

1. **¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?**

Porque el RFC es un dato de identificación fiscal y el DBA no tiene autoridad para determinar cuál es su valor correcto.

Aunque detecte que el formato es incorrecto, no puede asumir qué carácter falta ni modificarlo basándose en una suposición. Hacerlo podría generar información falsa y afectar otros procesos administrativos o fiscales.

La corrección debe ser autorizada por el responsable de los datos y respaldada por información proporcionada o verificada por el cliente. El DBA debe encargarse de ejecutar técnicamente la modificación autorizada y garantizar que quede registrada.

2. **¿Qué restricción (CHECK, UNIQUE) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?**

- C1 — Posible duplicado: una restricción UNIQUE sobre el correo normalizado impediría registrar correos repetidos sin distinguir mayúsculas y minúsculas. Se puede implementar mediante un índice único sobre lower(correo).
- C2 — RFC incompleto o ausente: una restricción CHECK puede validar el formato mediante una expresión regular. Para impedir valores ausentes también sería necesario NOT NULL.
- C3 — Correo inválido: una restricción CHECK puede validar que el correo tenga una estructura básica.
- C4 — Edad fuera de rango: una restricción CHECK puede establecer que la edad esté entre 18 y 120 años.
La aprobación debe corresponder al responsable del negocio o propietario de los datos, en coordinación con el área que utiliza la información. El DBA puede recomendar y aplicar las restricciones, pero no debería imponerlas unilateralmente.

Además, hay que tener cuidado: antes de agregar UNIQUE o CHECK, se deben revisar y corregir los registros existentes que incumplen las reglas. De lo contrario, la creación de las restricciones podría fallar.

3. **Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?**

El mecanismo es el sistema de auditoría mediante triggers (disparadores).

En el laboratorio se creó un trigger que ejecuta la función auditoria.registrar_cambio_cliente() después de operaciones INSERT, UPDATE y DELETE sobre la tabla clientes.

Cuando el DBA modifica un dato, el trigger registra información como:
- Fecha y hora del cambio.
- Usuario de sesión (session_user).
- Usuario efectivo (current_user).
- Aplicación e IP del cliente.
- Tipo de operación.
- Identificador del cliente afectado.
- Valores anteriores (valores_antes).
- Valores posteriores (valores_despues).
La función utiliza SECURITY DEFINER para insertar los registros con los privilegios de su propietario, aunque el usuario que realiza la operación tenga permisos limitados sobre la tabla de auditoría.

Limitación importante: como se observó en la Actividad 14, un administrador con privilegios suficientes puede deshabilitar el trigger antes de modificar un dato. Por tanto, la auditoría mediante triggers proporciona evidencia de los cambios registrados, pero no garantiza por sí sola que todos los cambios queden documentados.

## Conclusión

Esta actividad permitió identificar que los problemas de calidad de datos pueden originarse desde el momento en que la información es capturada. Mediante las consultas SQL fue posible detectar posibles registros duplicados, RFC incompletos, correos inválidos y valores fuera de rango. También se comprendió que detectar estos errores no significa que el DBA deba corregirlos por cuenta propia, ya que las modificaciones deben estar respaldadas por información verificada y autorizadas por los responsables de los datos. Finalmente, el uso de restricciones como CHECK, UNIQUE y mecanismos de auditoría mediante triggers permite prevenir inconsistencias y mantener evidencia de los cambios realizados. Así, la calidad de los datos requiere tanto controles técnicos como una adecuada definición de responsabilidades dentro de la organización.