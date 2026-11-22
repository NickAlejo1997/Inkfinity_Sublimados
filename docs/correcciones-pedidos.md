# Corrección de administración, recibo y celular

## Motivos

- `administracion.jsp` tenía cinco checkboxes con atributos HTML dentro de expresiones EL, por ejemplo `${p.activo ? name="activo" type="checkbox" 'checked' : ''}`. Jasper no puede traducir esa expresión y responde HTTP 500. Se usa JSTL para emitir únicamente el atributo `checked` cuando corresponde.
- `resultado.jsp` tenía un `<c:out value="${cotizacion.adicional}"/` sin el `>` final. El DAO insertaba el pedido antes de renderizar esa JSP. Al fallar la traducción del recibo, el `catch (Exception)` del controlador volvía al formulario mostrando un mensaje que culpaba a MySQL. La etiqueta está corregida y el renderizado del recibo está fuera del bloque que gestiona errores de cálculo/guardado.
- El registro de cuentas ya almacenaba `cliente.celular`, pero el login no consultaba esa columna ni los DTO de cuenta y sesión la transportaban. El formulario y la tabla `pedido` tampoco tenían celular para invitados. Ahora el dato recorre login/registro → sesión → formulario → validación → pedido → recibo y administración.

## Actualizar la base existente sin perder pedidos

El archivo `db/inkfinity_sublimados.sql` sigue siendo el único script completo para instalaciones nuevas. **No vuelvas a importarlo sobre tu base existente.**

En la consola SQL de IntelliJ o en phpMyAdmin, selecciona `inkfinity_sublimados` y comprueba si `pedido` ya tiene la columna:

```sql
SHOW COLUMNS FROM pedido LIKE 'celular';
```

Si no devuelve ninguna fila, ejecuta una sola vez:

```sql
ALTER TABLE pedido ADD COLUMN celular CHAR(9) NULL AFTER cliente;
```

Esto conserva las filas existentes. Los pedidos nuevos guardan su celular; administración usa el celular de la cuenta como respaldo para pedidos antiguos de clientes registrados. Los pedidos antiguos de invitados no tenían ese dato, por lo que no se puede recuperarlo. `cliente_id = NULL` corresponde a pedidos de invitados.

## Ejecutar desde IntelliJ

1. Detén la ejecución de Jetty y aplica la actualización SQL anterior a la misma base que usa la aplicación.
2. En la ventana Maven ejecuta `package` y vuelve a iniciar tu configuración `jetty:run`. El `pom.xml` configura el puerto `8088`; si tu configuración lo sobrescribe, usa ese puerto.
3. Abre `http://localhost:8088/Inkfinity-Sublimados/administracion` o `http://localhost:8088/Inkfinity-Sublimados/pedido`. Estas rutas pasan por sus controladores y cargan los datos para las JSP.
4. Vuelve a iniciar sesión para que la nueva sesión incluya el celular de tu cuenta.

## Comportamiento esperado

- Invitado: nombre y celular son obligatorios. El celular debe tener nueve dígitos y comenzar con `9`. Si hay un error de validación, se conservan los campos ingresados.
- Cliente con sesión: nombre y celular se cargan desde la cuenta y se muestran de solo lectura. El servidor usa los datos de la sesión incluso si se manipula el formulario.
- El recibo muestra el celular y los pedidos de invitados también muestran ese dato en administración.
- Los pedidos que ya se habían guardado antes del error siguen en la base. No es necesario reenviarlos.

## Verificación realizada

El 15/10/2026 se generó `target/Inkfinity-Sublimados.war` con `mvn -o -DskipTests package` (`BUILD SUCCESS`). Se verificó por HTTP con Jetty 11.0.15 en el puerto 18080 y una instancia aislada de MariaDB 10.4.32 de XAMPP en el puerto 13316. No se utilizó la base habitual del usuario.

Pasaron 84 comprobaciones, incluidas respuestas HTTP, contenido de las páginas y consultas SQL: recibos de polos y tazas con adicionales, persistencia del celular, registro y login con carga automática, rechazo de cinco formatos inválidos sin insertar pedidos, conservación de los campos ante errores, datos de sesión ante formularios manipulados, historial del cliente, panel autenticado y activación/desactivación de los cinco tipos de checkbox corregidos.

También se simuló una tabla anterior sin `pedido.celular` y se aplicó el `ALTER TABLE` de esta guía: se conservaron folio, cliente y total del pedido existente. Falta aplicar esa actualización y reiniciar la ejecución habitual de IntelliJ en el equipo del usuario.
