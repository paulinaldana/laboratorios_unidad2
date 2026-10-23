# 11. Actividad 5 — Analizar una finalidad secundaria

La empresa propone utilizar los datos de clientes para una nueva finalidad:

> “Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra.”

Analiza la situación.

## Preguntas

### **1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?**

No. Se aplica el principio de finalidad: los datos se recolectaron para fines concretos, los que el aviso de privacidad informó. Las promociones personalizadas son mercadotecnia, que cuenta como finalidad adicional que requiere una opción real de rechazo, separada de las necesarias para la relación comercial. 

### **2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**

- ¿El aviso de privacidad actual menciona la mercadotecnia o las promociones? 
- ¿Tenemos el consentimiento de cada cliente para esto?
- ¿Cómo lo vamos a recabar de quienes no lo dieron?
- ¿Qué datos necesitamos de verdad para segmentar?
- ¿Podemos lograr lo mismo con menos?
- ¿Cómo va a poder el cliente decir que no, o darse de baja después para cuidar los derechos ARCO?
- ¿Quién va a tener acceso a los datos y por cuánto tiempo se conservarán para esto?
- ¿Vamos a compartir los datos con terceros (agencias, plataformas de correo)?

### **3. ¿Qué datos serían realmente necesarios**

El id, la edad en rango, ciudad, historial de compra y un dato que permita contactarlo (correo o teléfono), solo para quienes aceptaron.

### **4. ¿Necesitaría el área de marketing acceso directo a clientes?**

No. Marketing solo requiere los datos preparados para la campaña. Darle la tabla completa le entregaría RFC, teléfono y demás datos que no usa, lo cual contradice la minimización y el mínimo privilegio. Para el envío en sí, el contacto lo puede manejar un proceso o herramienta de envío con permisos propios, de modo que el equipo de marketing no tenga que ver los correos uno por uno.

### **5. ¿Qué controles técnicos podrían limitar la información entregada?**

Un rol marketing con NOLOGIN y permiso solo sobre su vista. Dónde sólo visualice id, ciudad, rango de edad y categoría de compra, sin datos directos y que la vista incluya solo a los clientes que aceptaron.

## Conclusión
Los datos merecen un trato delicado, especialmente para temas de mercadotecnia. No porque el resto de tratamientos carezca de importancia, sino porque definitivamente los de mercadotecnia podrían tener consecuencias más directas por así decirlo. Primero porque las personas están mas consiente de ellos. Un posible uso donde se compartan con terceros podría provocar una acción inmediata por parte de los clientes.

En otro caso al recibir información con las promociones sería más evidente para ellos de primera mano el uso indebido de sus datos.