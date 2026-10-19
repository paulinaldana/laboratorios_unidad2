## 7. Actividad 1 — Protección de credenciales

### **Objetivo**
Identificar los riesgos de almacenar contraseñas en texto plano dentro de una base de datos.

### **Comando o procedimiento**
Previamente:
- Se verificó que la estructura `clientes` existiera.
- Verificar que la extensión `pgcrypto` esté disponible.
- Comprobar lo anterior.

Se creó la tabla `usuarios_insegura` con las columnas id, usuario y password. Después, se insertó un usuario de prueba con el nombre juan y la contraseña Password123. Finalmente, se ejecutó la consulta `SELECT * FROM usuarios_insegura`; para visualizar los registros almacenados.

### **Resultado obtenido**
La consulta muestra los datos del usuario registrado, incluida su contraseña en texto plano (Password123), sin ningún mecanismo de protección.

### **Análisis**
Almacenar contraseñas en texto plano representa un riesgo de seguridad, ya que cualquier persona con permisos de lectura sobre la tabla podría conocerlas y utilizarlas para acceder a las cuentas afectadas. Para evitarlo, las contraseñas deben almacenarse mediante funciones de hash seguras, en lugar de guardar directamente el valor original.

**Pregunta:**
¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?

**Respuesta:**
Si una persona obtiene accso de lectura a esta tabla, podría ver las contraseñas de los usuarios en texto plano, sin necesidad de decifrarlas. Esto compromete la seguridad de las cuentas, ya que podría utilizar esas contraseñas para acceder a la aplicación o a otros servicios si los usuarios las reutilizan.

### **Conclusión**
Las contraseñas **nunca** deben almacenarse en texto plano. Se deben guardar mediante funciones de hash diseñadas para contraseñas, que dificultan recuperar la contraseña original incluso si alguien obtiene acceso a la tabla.
