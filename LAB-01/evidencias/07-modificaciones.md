# 13. Actividad 7 — Modificaciones de datos: ddl frente a mod

## Preguntas

### 1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?

El nivel que habría registrado la lectura del RFC es:

```
ALTER SYSTEM SET log_statement = 'all';
SELECT pg_reload_conf();
```

Con log_statement = 'all', PostgreSQL registra todas las sentencias SQL, tanto las que modifican datos como las que solamente consultan información.

Por ejemplo:
- UPDATE: registra la modificación.
- INSERT: registra la inserción.
- DELETE: registra la eliminación.
- SELECT: registra las consultas y, por tanto, también la lectura del RFC.

El costo en un servidor con miles de consultas por minuto sería considerable:
- Mayor volumen de registros: cada consulta generaría entradas en la bitácora.
- Consumo de almacenamiento: los archivos crecerían rápidamente.
- Impacto en el rendimiento: registrar y escribir tantas sentencias puede añadir carga al servidor.
- Mayor exposición de información sensible: las consultas y sus parámetros podrían revelar datos personales, como RFC, teléfonos o información financiera.
- Mayor dificultad de análisis: encontrar un evento importante entre miles de registros sería más complicado.

Por eso, ```all``` no necesariamente es la mejor configuración permanente. Para un sistema de producción suele ser más razonable seleccionar qué eventos registrar y complementar la bitácora con mecanismos especializados de auditoría.

### 2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza? (Lo resolverás en la Parte B.)

La bitácora actual registra la sentencia ejecutada:
UPDATE clientes
SET telefono = '6679990000'
WHERE id = 3;


Pero no registra automáticamente el valor que tenía el teléfono antes de la modificación.

Para revertir el cambio con certeza necesitaríamos, como mínimo:
1. Valor anterior: el teléfono que tenía el registro antes del UPDATE.
2. Valor nuevo: el teléfono después de la modificación.
3. Identificador del registro: en este caso, id = 3.
4. Fecha y hora: para conocer cuándo ocurrió el cambio.
5. Identidad de la sesión: usuario, aplicación y dirección de origen.
6. Información transaccional: saber si la operación se confirmó (COMMIT) o se revirtió (ROLLBACK), y relacionarla con la transacción correspondiente.

Una alternativa sería implementar una auditoría mediante triggers, que guarde los valores anteriores y nuevos en una tabla independiente cada vez que se modifique un registro.

Por ejemplo, una tabla de auditoría podría tener esta estructura:

|Campo	|Información|
| --- | --- |
id_auditoria	|Identificador del evento
id_cliente	|Registro modificado
telefono_anterior|	Valor antes del cambio
telefono_nuevo|	Valor después del cambio
fecha_modificacion|	Momento del cambio
usuario_bd|	Usuario de PostgreSQL

## Conclusión

La bitácora actual permite rastrear operaciones, pero no reconstruir con certeza el estado anterior de los datos. Para lograrlo, se necesita registrar explícitamente los valores antes y después de cada modificación, además de conservar la información transaccional.