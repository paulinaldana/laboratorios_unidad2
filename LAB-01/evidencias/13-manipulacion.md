# 20. Actividad 14 — Intentar manipular la auditoría

## Preguntas

### 1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?

La evidencia se encuentra al comparar la bitácora del servidor con la tabla de auditoría.

En este caso, la bitácora registra tres operaciones realizadas por el administrador:
- Desactivación del disparador de auditoría.
- Modificación del RFC del cliente con id = 3.
- Reactivación del disparador.

Sin embargo, el conteo de registros en auditoria.cambios_clientes continúa siendo 3, lo que indica que la modificación no generó un evento de auditoría.

Por lo tanto, la bitácora permite detectar que se desactivó el mecanismo de auditoría y que se ejecutó una modificación durante ese intervalo, aunque la tabla de auditoría no conserve el detalle del cambio.

### 2. ¿Qué control administrativo (no técnico) reduciría este riesgo?

Implementar una política de separación de responsabilidades que establezca que ninguna persona debe tener control exclusivo sobre la operación de la base de datos y la supervisión de sus registros de auditoría.

Por ejemplo, las modificaciones a los mecanismos de auditoría deberían requerir autorización previa de un responsable independiente y quedar sujetas a una revisión posterior.

También conviene establecer revisiones periódicas de las bitácoras y responsabilidades documentadas para cada integrante del equipo.

### 3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.

Esta actividad demuestra la importancia del principio de separación de funciones, que consiste en distribuir las responsabilidades y los permisos entre diferentes personas para evitar que una sola tenga control absoluto sobre un proceso.

En este caso, el administrador puede modificar los datos y desactivar el disparador que registra los cambios. Si también tiene control exclusivo sobre las bitácoras, podría alterar o eliminar la evidencia de sus propias acciones.

Por eso, las responsabilidades deberían distribuirse entre:
- Administrador de bases de datos: gestiona la estructura, los usuarios y la operación de la base de datos.
- Responsable de auditoría: supervisa los registros y verifica que las modificaciones estén documentadas.
- Responsable de seguridad: establece políticas de acceso, autorización y protección de evidencias.

## Conclusión

Ningún mecanismo de auditoría dentro de una base de datos es completamente confiable si la misma persona puede modificar los datos, desactivar los controles y controlar las evidencias. La separación de funciones reduce ese riesgo al establecer supervisión independiente y responsabilidades claramente definidas.