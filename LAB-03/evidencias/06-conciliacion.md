# 13. Actividad 7 — Registro de cambios y conciliación

## Tabla de conciliación

| Momento (bitácora) | Usuario | Sentencia | Folio que lo autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|
| 2026-11-27 05:56:09.531 | u_16540549_paulina_aldana | `CREATE SCHEMA gobierno` | No aplica | No aplica | Operación de preparación para crear el registro de solicitudes. |
| No disponible | No disponible | `ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20)` | CAM-2026-014 | Pendiente de comprobar | La columna existe, pero no se obtuvo la sentencia correspondiente en la bitácora. |
| No disponible | No disponible | `ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes` | No identificado | No comprobable | La consulta no encontró registros relacionados con el trigger. |
| No disponible | No disponible | `GRANT UPDATE ON clientes TO app_ventas` | No identificado | No comprobable | No aparece en los resultados obtenidos. |

## Preguntas 

1. **¿Qué cambios de la bitácora no tienen folio? Clasifícalos: ¿son de preparación del laboratorio o representan hallazgos?**

En los resultados obtenidos solamente aparece la sentencia CREATE SCHEMA gobierno, ejecutada por el usuario u_16540549_paulina_aldana.

Esta operación corresponde a la preparación del laboratorio, ya que permite crear el espacio donde se almacenarán las solicitudes de cambio. No requiere el folio CAM-2026-014, porque no corresponde a la modificación de la tabla clientes descrita en esa solicitud.

No es posible identificar otros cambios sin folio porque la consulta solamente devolvió esa operación.

2. **La desactivación del disparador del LAB-01 (Actividad 14), ¿qué tan grave es como hallazgo? ¿Por qué? ¿Qué distingue la línea 163 de la 169?**

La desactivación de un trigger de auditoría representa un hallazgo grave porque interrumpe el registro automático de las modificaciones realizadas sobre los datos. Esto permite que ciertas operaciones se ejecuten sin dejar evidencia en la tabla de auditoría, afectando la integridad y confiabilidad del mecanismo de seguimiento.

La diferencia entre las líneas 163 y 169 del ejemplo del laboratorio es el usuario que ejecuta la operación:
- Línea 163: app_ventas intenta desactivar el trigger.
- Línea 169: postgres ejecuta la desactivación.

Esto permite distinguir un intento de una operación realizada por un usuario con mayores privilegios. Sin embargo, en tus resultados actuales no aparecen esas líneas ni registros equivalentes, por lo que no podemos afirmar que hayas observado esa desactivación en tu propio servidor.

3. **¿Qué limitación tiene esta conciliación si log_statement estuvo en none durante algún periodo?**

Cuando log_statement está configurado en none, PostgreSQL no registra las sentencias SQL mediante ese mecanismo. Por lo tanto, pueden existir cambios que se hayan ejecutado correctamente, pero que no aparezcan en la bitácora.

Esto provoca que la conciliación sea incompleta, porque no es posible comparar todas las modificaciones realizadas con las solicitudes aprobadas. La ausencia de una sentencia en el registro no demuestra que el cambio no haya ocurrido.

4. **¿Quién debería realizar la conciliación: el DBA que hizo los cambios u otra persona?**

La conciliación debería realizarla una persona independiente del DBA que ejecutó los cambios, preferentemente un responsable de auditoría o seguridad.

Esto permite mantener la separación de funciones y reducir el riesgo de que quien realizó una modificación sea también quien determine si estuvo autorizada. El DBA debe proporcionar la evidencia técnica, pero otra persona debe verificar que cada operación coincida con una solicitud aprobada.

## Conclusión

La actividad permitió establecer un mecanismo para documentar y relacionar las solicitudes de cambio con las modificaciones realizadas en la base de datos. Se registró la solicitud CAM-2026-014 y se comprobó que la columna canal_alta existe en la tabla clientes. Sin embargo, la bitácora consultada solamente mostró la creación del esquema gobierno, por lo que no fue posible demostrar directamente quién ejecutó la modificación ni verificar su correspondencia temporal con la ventana autorizada. También se identificó que la desactivación de un trigger de auditoría constituye un riesgo importante para la integridad de las evidencias. Finalmente, se reconoció la necesidad de realizar conciliaciones independientes y mantener registros completos para asegurar la trazabilidad de los cambios.