# 7. Actividad 1 — Inventario y finalidad de los datos

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
|---|---|---|---|---|---|
| id | Indirecto | Identificador único para relacionar registros | Sí | Amplio (equipo técnico y analistas) | Mientras exista el registro |
| nombre | Sí  | Identificar al cliente, comunicarse y facturar | Sí | Restringido (ventas, atención y facturación) | 10 años (documentos de venta y facturación) |
| correo | Sí | Notificaciones y envío de facturas | Sí | Restringido (ventas y atención) | Vigencia de la relación; eliminar al darse de baja |
| telefono | Sí | Contacto para entregas, cobranza o aclaraciones | Depende (sí con entregas o cobranza; si no, opcional) | Restringido (logística y cobranza) | Vigencia de la relación; eliminar si se revoca |
| rfc | Sí  | Emitir facturas (CFDI) y cumplir obligaciones fiscales | Sí (para clientes que piden factura) | Muy restringido (facturación y finanzas) | 10 años |
| edad | Sí  | Estadística y segmentación | No (basta un rango) | Restringido; analistas con datos agregados | Anonimizar o agregar tras el análisis |
| ciudad | Indirecto | Logística de envío y análisis por región | Depende del servicio (sí si hay envíos) | Medio (analistas) | Vigencia de la relación; luego agregar |
| codigo_postal | Indirecto | Datos del CFDI (domicilio fiscal) y zonificación | Sí (para facturar) | Medio (facturación y logística) | 10 años si consta en la factura; si no, agregar tras la relación |
| fecha_alta | Indirecto (asociado a una persona) | Auditoría, antigüedad y control de retención | Sí | Amplio (técnico y auditoría) | La misma que el registro |

## Justificaciones

### id
El uso de un código de identificación actúa como una referencia indirecta que, aunque no revela la identidad de alguien de forma aislada, resulta fundamental para organizar, conectar y actualizar la información de distintas bases de datos sin comprometer la privacidad. Al ser un recurso técnico de bajo riesgo que facilita el manejo seguro de registros bajo el principio de seudonimización, se le concede una disponibilidad de consulta bastante flexible y permanece vigente únicamente durante el ciclo de vida del expediente principal al que está vinculado.

### nombre
El nombre o razón social es un dato personal directo indispensable para cumplir con la facturación CFDI 4.0 exigida por el SAT. Su acceso está estrictamente restringido al personal de ventas y facturación para proteger la privacidad, mientras que los analistas operan con identificadores indirectos. Finalmente, esta información se resguarda de forma segura durante 10 años bajo la normativa del Código de Comercio antes de ser eliminada.

### correo
El correo electrónico funciona como un dato personal esencial para enviar confirmaciones, facturas y avisos durante la relación comercial. Su acceso es restringido para evitar riesgos como el spam, y se elimina de forma definitiva si el cliente se da de baja.

### telefono
El teléfono es un dato de contacto útil para coordinar entregas o resolver urgencias, aunque su obligatoriedad depende de las necesidades operativas de la empresa. El acceso a este número está restringido a áreas específicas y se elimina de forma definitiva una vez que el cliente revoca su consentimiento.

### rfc
El RFC es un dato sensible indispensable para emitir facturas y cumplir con obligaciones fiscales dentro del área de finanzas. Por normatividad comercial y fiscal, este registro se almacena bajo un acceso muy restringido durante un plazo obligatorio de 10 años.

### edad
La fecha de nacimiento sirve para segmentación estadística y, por minimización, debe manejarse en rangos de edad a menos que exista una restricción legal. Su acceso está restringido a analistas y debe ser anonimizada o conservada únicamente por rangos una vez cumplido su análisis.

### ciudad
La ciudad o región es un dato que facilita la logística de envío y el análisis de ventas corporativo según la modalidad del servicio. Su nivel de acceso es medio por su bajo riesgo y debe conservarse de forma agregada una vez que finaliza la relación con el cliente.

### codigo_postal
El código postal es un dato indispensable para la emisión de facturas CFDI 4.0 y la zonificación logística de los envíos. Su acceso es medio y regulado, debiendo conservarse por un plazo obligatorio de 10 años si está vinculado a la facturación comercial.

### fecha_alta
La fecha de alta no identifica a nadie por sí sola, pero asociada al registro de un cliente sí es información sobre él. Es necesaria porque permite auditar, calcular la antigüedad y aplicar las políticas de retención; por ser un dato técnico de bajo riesgo, el acceso es amplio, y se conserva solo mientras exista el registro, porque sin él pierde sentido.

