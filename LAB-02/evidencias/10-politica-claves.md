## 7. Actividad 10 — Crear una política mínima de protección de claves

### **Objetivo**
Establecer reglas básicas para la gestión segura de claves criptográficas, desde su generación hasta su eliminación, con el propósito de evitar su exposición y proteger la información que depende de ellas.

### **Comando o procedimiento**

Documentar una política con reglas de generación, almacenamiento, acceso, rotación, respaldo, revocación, exposición accidental y eliminación de claves criptográficas.

### **Resultado obtenido**

**Política de protección de claves criptográficas**

1. **Generación:** Las claves deben generarse mediante herramientas criptográficas confiables y utilizar algoritmos seguros y adecuados para su propósito.

2. **Almacenamiento:** Las claves deben guardarse en un gestor de secretos o sistema seguro, separado del código fuente y de los scripts del proyecto.

3. **Acceso:** El acceso a las claves debe limitarse únicamente a las personas y aplicaciones que realmente las necesiten.

4. **Rotación:** Las claves deben renovarse periódicamente según la política de la organización y cuando exista sospecha de que han sido comprometidas.

5. **Respaldo:** Las claves necesarias para recuperar información deben contar con respaldos protegidos y con acceso restringido, de acuerdo con un procedimiento de recuperación seguro.

6. **Revocación:** Las claves comprometidas o que ya no deban utilizarse deben revocarse o deshabilitarse para evitar accesos no autorizados.

7. **Exposición accidental:** Si una clave se publica por error en un repositorio o archivo compartido, debe considerarse comprometida, sustituirse y evaluarse el posible acceso a la información protegida.

8. **Eliminación:** Las claves que ya no sean necesarias deben eliminarse de forma segura, incluyendo sus copias, cuando corresponda y sin comprometer las necesidades legítimas de recuperación de datos.

### **Análisis**
La política establece medidas para proteger las claves durante todo su ciclo de vida. No basta con almacenarlas de forma segura: también es necesario controlar quién puede utilizarlas, contar con mecanismos de recuperación y actuar rápidamente ante una posible filtración.

Asimismo, eliminar una clave sin comprobar si todavía se necesita para descifrar información respaldada puede provocar una pérdida irreversible de datos. Por ello, su eliminación debe formar parte de un procedimiento controlado.

### **Conclusión**
Las actividades permitieron comprender la importancia de revisar los archivos antes de publicarlos y establecer reglas para administrar las claves criptográficas de manera segura. La aplicación de estas medidas ayuda a reducir el riesgo de filtraciones, accesos no autorizados y pérdida de información protegida.