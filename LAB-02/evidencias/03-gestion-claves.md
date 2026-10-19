## 9. Actividad 3 — El problema de la gestión de claves

### **Objetivo**
Identificar los riesgos de seguridad relacionados con la exposición de claves de cifrado dentro del código fuente y comprender la importancia de administrar adecuadamente las claves utilizadas para proteger información sensible en una base de datos.
### **Comando o procedimiento**
**1. Identificación de la mala práctica**

Se analizó una consulta SQL que permite descifrar el RFC almacenado en la tabla ``clientes_protegidos``. En ella, la clave se encuentra escrita directamente dentro del código.

`SELECT pgp_sym_decrypt(
    rfc_cifrado,
    'CLAVE-DE-PRUEBA'
)
FROM clientes_protegidos;`

**2. Creación del archivo demostrativo**

Se propuso crear el archivo temporal `sql/ejemplo-mala-practica.sql` e incluir la consulta anterior únicamente con fines demostrativos, utilizando una clave ficticia y sin emplear credenciales reales.

**3. Análisis del riesgo**

Se examinó qué podría suceder si el archivo se publicara en un repositorio Git y la clave utilizada fuera realmente una clave de cifrado de la organización.

### **Resultado obtenido**

Se identificó que incluir una clave directamente en una consulta SQL representa un riesgo de seguridad, ya que esta puede quedar expuesta al compartir el archivo o publicarlo en un repositorio.

Si se tratara de una clave real, una persona no autorizada podría obtenerla y utilizarla para descifrar los datos protegidos, siempre que también tuviera acceso a los registros cifrados.

### **Análisis**

**¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?**

Existiría un problema mayúsculo. La clave podría quedar expuesta a personas no autorizadas, especialmente si el repositorio es público o si usuarios sin autorización tienen acceso al proyecto. 

Con la clave y los datos cifrados, un atacante podría descifrar información sensible, como los RFC de los clientes.
Además, eliminar posteriormente el archivo no garantiza que la clave deje de estar expuesta, ya que podría permanecer en el historial de versiones, en copias del repositorio o en respaldos. 

Si esto ocurriera con una clave real, sería necesario revocarla o sustituirla, evaluar el alcance de la exposición y revisar los accesos a la información protegida. Es importante limitar su acceso y evitar incluirlas directamente en scripts, repositorios o documentación.

### **Conclusión**
La actividad permitió reconocer que proteger la información mediante cifrado no es suficiente si las claves se administran de forma inadecuada. La exposición de una clave puede comprometer la confidencialidad de los datos, incluso cuando estos se encuentran cifrados. Por ello, es fundamental mantener las claves separadas del código fuente, restringir su acceso y establecer procedimientos para responder ante posibles filtraciones.