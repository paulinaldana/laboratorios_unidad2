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



2. **¿Qué restricción (CHECK, UNIQUE) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?**

3. **Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?**

## Conclusión