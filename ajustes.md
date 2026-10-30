# Bitácora de ajustes (migración a PHP 8.3)

Registro por fecha de los cambios hechos para correr el SIEH en PHP 8.3 (Ubuntu 24.04 con nginx y PostgreSQL 17, y XAMPP en Windows para desarrollo), manteniendo la compatibilidad con PHP 7. Las primeras entradas son de la puesta en marcha de `etoi262`.

La guía de instalación del servidor y de los operativos está en el [README](README.md).

---

## 2026-10-22

### 1. Configuración local de la app

**Archivo:** `etoi262/configuracion_local.php` (ignorado por git: `configuracion_local*` en `.gitignore`)

Ejemplo genérico; cada uno pone los valores de su entorno:

```php
<?php
//UTF-8:SÍ
global $parametros_db,$ICON_APP,$detenido,$debug_via_notepadPP;

$detenido=false;

$debug_via_notepadPP=true;   // opcional: muestra las excepciones en pantalla

$parametros_db->user='tedede_php';
$parametros_db->pass='tu_clave';
$parametros_db->base_de_datos='etoi262_produc_db';
$parametros_db->host='localhost';
$parametros_db->port='5432';   // el puerto de TU Postgres
?>
```

> `port`: `5432` es el puerto estándar de Postgres. Si en el servidor hay más de un cluster, cada uno usa otro puerto (5432, 5433, ...). Para ver cuál es cuál: `pg_lsclusters`.

### 2. Base de datos en PostgreSQL 17

**Locale `es_ES.UTF-8`:** `crear_etoi262.sql` lo pide para `LC_COLLATE`/`LC_CTYPE`, y Ubuntu no lo trae generado. Hay que generarlo **antes** de crear la base y reiniciar Postgres:

```bash
sudo locale-gen es_ES.UTF-8
sudo systemctl restart postgresql
```

### 3. nginx

**Archivo:** `/etc/nginx/sites-available/default` (copia del original: `default.bak_antes_sieh1`)

nginx servía solo `/var/www/html`. Se agregó, antes de `location /`:

```nginx
location ^~ /sieh1/ {
    root /var/www;
    index index.php index.html;
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }
    location ~ \.manifest$ {
        default_type text/cache-manifest;
    }
}
```

- El `.manifest` replica el `AddType text/cache-manifest` de los `.htaccess`, que nginx no lee.
- No se replicó la regla de `.htaccess` que manda `^tabulado$` a `localhost:3003` como proxy.
- Hizo falta `systemctl restart nginx`; con `reload` el cambio no se aplicó.

### 4. Código: compatibilidad con PHP 8.3

El código venía de PHP 7. Los tres cambios siguen funcionando en PHP 7.

#### `tedede/pdo_con_excepciones.php`
**Error:** `Fatal error: Declaration of PDO_con_excepciones_sin_cache::query() must be compatible with PDO::query(...)`

- `query()` pasa a tener la firma compatible: `query($statement=null, $fetch_mode=null, ...$fetch_mode_args)`.
- Se agregó `#[\ReturnTypeWillChange]` a `query()`, `prepare()` y `quote()`. Evita los avisos de PHP 8.1+ por el tipo de retorno; PHP 7 lo toma como comentario.

#### `tedede/lo_imprescindible.php`
**Error:** `Notice: date_default_timezone_set(): Timezone ID 'America/Buenos_Aires' is invalid`

- Cambiado a `America/Argentina/Buenos_Aires`. El alias viejo no está en el tzdata de Ubuntu 24.04, y con él PHP usaba UTC, así que las fechas salían 3 horas corridas.

#### `encuestas/proceso_imprimir_hoja_de_ruta_sup_campo.php`
**Error:** `Fatal error: Uncaught Error: Class "Proceso_imprimir_hoja_de_ruta" not found`

- Se agregó `require_once "Proceso_imprimir_hoja_de_ruta.php";`, como ya lo tienen las otras tres hijas (`_enc`, `_recu`, `_sup_telefonico`).
- **Causa:** `incluir_todo()` (`tedede/todos_los_php.php`) carga los archivos en el orden de `readdir`, que en ext4 es arbitrario. Este archivo dependía de que la padre se cargara antes.

### 5. `search_path` de la base

**Error** (al entrar a `?hacer=menu`): `function para_ordenar_numeros(character varying) does not exist`

- La función existe, pero en el esquema `comun`. El `pg_dump` no incluye los `ALTER DATABASE ... SET`, así que la base restaurada quedó con el `search_path` por defecto (`"$user", public`).
- Se configuró el mismo `search_path` que usan los scripts SQL de etoi:
  ```sql
  alter database etoi262_produc_db set search_path = encu, dbo, comun, public;
  ```

### 6. Permisos de escritura para PHP (`www-data`)

PHP-FPM corre como `www-data`, y las carpetas son de `usuario` con permisos `755`.

- `logs/`: `chgrp www-data` + `chmod 2775`. **Error:** `file_put_contents(../logs/login <usuario>.log): Permission denied` (`tedede/proceso_login.php:56`).
- `etoi262/`: `chgrp www-data` + `chmod 2775`. La app escribe ahí los archivos generados `estructura_etoi262.js` y `Tabla_plana_*.estructura.json`, que están en `.gitignore` y no vienen en el repo.

### 7. Archivos generados que faltan

**Error:** `GET /sieh1/etoi262/estructura_etoi262.js` devuelve 404.

- Se generan desde la app: **Mantenimiento → "Actualizar Instalación (jsones varios, post cambio metadatos)"**, que requiere el grupo `programador` (`etoi262.php`, `para_proceso_actualizar_instalacion`).
- Ese proceso también reinstala los triggers de `tem` y las restricciones de `respuestas` en la base.
- Sin `Tabla_plana_TEM_.estructura.json`, el menú fallaba con `SQLSTATE[42601]: syntax error at end of input`: la tabla plana quedaba sin campos (warnings en `tedede/tablas_o_vistas.php:24-25`).
- Se ejecuta entrando con un usuario de rol `programador` a `?hacer=actualizar_instalacion`. Si termina bien (`resultado_instalacion=true`), quedan en `etoi262/`:
  - `estructura_etoi262.js` (~800 KB)
  - `Tabla_plana_A1_`, `I1_`, `S1_`, `S1_P`, `SUP_` y `TEM_.estructura.json`
- Hay que volver a correrlo si cambian los metadatos o si se restaura otra vez la base.

> Ojo: los procesos de tipo `Proceso_Generico` se ejecutan con solo abrir la URL (`?hacer=...`), sin confirmación. "Instalar" está en Mantenimiento: no abrirlo por error.

- Para ver los errores: `sudo tail -f /var/log/nginx/error.log`

---

## 2026-10-23

### 8. PHP 8.3: Deprecated corregidos

Los tres cambios son compatibles con PHP 7.

#### `tedede/proceso_login.php` (línea 50)
**Error:** `Deprecated: file_put_contents(): Passing null to parameter #3 ($flags) of type int is deprecated`

En la función `registrar()`, `$modo=NULL` al abrir el log. En PHP 8.3, pasar `null` donde se espera `int` es deprecated y —con `display_errors = On`— aparece antes del JSON, corrompiéndolo.
- Cambiado `$modo=NULL` → `$modo=0` (equivalente; `0` = sin flags).

#### `tedede/esquemas.php` — `class Objeto_de_la_base`
**Error:** `Deprecated: Creation of dynamic property Tablas_planas::$contexto is deprecated` (ídem `Triggers_tem` y `Estructura_etoi262`)

En PHP 8.2+ crear propiedades dinámicas (no declaradas) es deprecated. La propiedad `$contexto` la asigna `Contexto::nuevo_objeto()` (`contextos.php:25`) a cualquier objeto que no sea `Contexto`. Todas las clases afectadas (`Tablas_planas`, `Triggers_tem`, `Estructura_etoi262`) extienden `Objeto_de_la_base`.
- Declarado `public $contexto;` en `Objeto_de_la_base`. Todas las subclases la heredan.

#### `tedede/comunes.php` — función `MomentoRelativoHTML()` (líneas 219, 221)
**Error:** (potencial) `DateTimeZone::__construct(): Unknown or bad timezone (America/Buenos_Aires)`

`America/Buenos_Aires` ya no existe en el tzdata de Ubuntu 24.04 (se quitó como alias).
- Cambiado a `America/Argentina/Buenos_Aires`.

---

## 2026-10-26 — PHP 8.3 en XAMPP (Windows)

Registro de los errores y deprecated de PHP 8.3 que aparecieron al probar las aplicaciones (`etoi264`, `eah2024`) con **XAMPP (Apache 2.4 + PHP 8.3.36 en `C:\xampp\php83`)** y de cómo se resolvieron.

Los errores se detectaron mirando `C:\xampp\apache\logs\error.log` mientras se recorrían las opciones del menú. Para verificar sintaxis: `C:\xampp\php83\php.exe -l archivo.php`.

> **Importante para el servidor:** si en el servidor aparece un error ya corregido acá (por ejemplo el fatal de `PDO::query()`), casi seguro tiene una copia vieja de `tedede/`. Copiar la carpeta completa y reiniciar PHP-FPM / Apache para limpiar OPcache.

### 9. Fatal: `PDO_con_excepciones_sin_cache::query()` incompatible con `PDO::query()`

**Error:** `Declaration of PDO_con_excepciones_sin_cache::query() must be compatible with PDO::query(string $query, ?int $fetchMode = null, mixed ...$fetchModeArgs): PDOStatement|false`

**Solución:** en `tedede/pdo_con_excepciones.php` se cambió la firma de `query()` y se agregó `#[\ReturnTypeWillChange]` a `query()`, `prepare()` y `quote()`:

```php
#[\ReturnTypeWillChange]
function query($statement=null, $fetch_mode=null, ...$fetch_mode_args){ return $this->no_implementado(); }
```

También `#[\ReturnTypeWillChange]` en `Sqls::getIterator()` (implementa `IteratorAggregate`).

### 10. Warning: `Undefined variable $HTTP_USER_AGENT` (`tedede/registrar.php`)

La variable se define en `lo_imprescindible.php` y no existe dentro de `registrar.php`. Se lee ahora de `$_SERVER["HTTP_USER_AGENT"]`, y `$_REQUEST["LOCAL_ADDR"]` lleva `@` por si no viene. Con esto el log `logs/pre_login_incompatibilidades.txt` vuelve a registrar el navegador.

### 11. Deprecated: `Creation of dynamic property X::$y is deprecated`

PHP 8.2 deprecó crear propiedades no declaradas. Hay cientos de casos en las clases base del framework. Solución: `#[\AllowDynamicProperties]` en las **clases raíz** (las subclases lo heredan):

| Clase | Archivo |
|---|---|
| `Nodo_de_salida`, `Armador_de_salida` | `tedede/armador_de_salida.php` |
| `Campo` | `tedede/campos.php` |
| `Contexto` | `tedede/contextos.php` |
| `Filtro` | `tedede/filtros.php` |
| `Tablas_o_Vistas` | `tedede/tablas_o_vistas.php` |
| `Grilla` | `tedede/grilla.php` |
| `mersenne_twister\twister` | `tercera/mersenne_twister.php` |

Esto solo silencia el deprecated; no declara las propiedades. Si aparece el mismo mensaje con otra clase, agregar el atributo a su clase raíz.

### 12. Warning: `Private methods cannot be final`

En `tedede/aplicaciones.php` se quitó `final` de `obtener_proceso()` y `obtener_procesos()`. Son `private`, así que nunca se sobrescriben y el comportamiento no cambia.

### 13. Deprecated: `Passing null to parameter` de funciones de string

Desde PHP 8.1 pasar `null` a `htmlspecialchars()`, `explode()`, `trim()`, `strlen()`, etc. es deprecated. Se corrigió donde apareció, con `??''`:

- `tedede/armador_de_salida.php`, `escapar_caracteres_antes_de_enviar_texto()`: `htmlspecialchars($mensaje??'',ENT_NOQUOTES)`. Antes generaba ~90 avisos por pantalla.
- `encuestas/proceso_compilar_consistencia.php` (línea 190): `explode(' ', ...->con_variables_contexto??'')`. La columna `con_variables_contexto` viene en `NULL` en consistencias sin variables de contexto.
- `encuestas/proceso_correr_consistencias.php` (línea 89): mismo caso y misma solución (`con_variables_contexto??''`). Generaba ~470 avisos por corrida de `correr_consistencias`. El `if($variable)` siguiente ya descartaba los valores vacíos, por lo que el comportamiento no cambia. En la línea 222 del mismo archivo apareció después el mismo aviso con `explode(' ', $que_encuentra->lista_en_s1)` (`lista_en_s1` es nulo cuando la consulta no encuentra nada en S1); se corrigió igual con `??''`. Como `explode` de un texto vacío devuelve `array('')`, el resultado es el mismo que tenía con PHP 7.

Hay otros `htmlspecialchars()`, `strtotime()` y similares en el código que pueden recibir `null` según los datos; se corrigen del mismo modo cuando aparezcan en el log.

### 14. Campos `pla_*` de `pla_ext_hog` (`encuestas/tabla_pla_ext_hog.php`)

Los campos `pla_qipcf*`, `pla_dipcf*`, `pla_qitf*` y `pla_ditf*` se habían condicionado a `eah` con `anio_operativo < 2024` (desde eah2024 se eliminan). Ese `if` quedó **comentado**: por ahora todas las aplicaciones definen los campos. Si una grilla o consulta nombra columnas que ya no existen en la base, dará error de columna. Se vuelve a evaluar después de la migración.

### 15. PHPMailer 5.1 → 6.9.3

PHPMailer 5.1 usaba `each()` y `magic_quotes_runtime`, que **no existen en PHP 8** (el envío de mails habría dado fatal error).

- Se agregó `tercera/PHPMailer_v6.9.3/` (versión oficial, carpetas `src` y `language`) y se eliminó `tercera/PHPMailer_v5.1/`.
- `tedede/mail.php` usa ahora el espacio de nombres `PHPMailer\PHPMailer\PHPMailer` y `require_once` de `src/Exception.php`, `src/PHPMailer.php` y `src/SMTP.php`. El resto de `enviarMail()` no cambia.
- PHPMailer 6 intenta STARTTLS si el servidor SMTP lo ofrece. Si falla por el certificado del servidor, agregar `$mail->SMTPAutoTLS = false;` en `mail.php`.
- Requiere las extensiones `mbstring` y `openssl`.

#### Configuración del SMTP fuera del código

El servidor, el usuario, el remitente y la clave SMTP estaban escritos en `tedede/mail.php`. Ahora `mail.php` los toma de variables globales que se definen en el `configuracion_local.php` de **cada aplicación** (archivo ignorado por git):

```php
$smtp_host='smtp.ejemplo.gob.ar';           // servidor SMTP
$smtp_usuario='usuario@ejemplo.gob.ar';     // usuario y, por defecto, remitente
$smtp_password='la_clave';                  // clave del usuario
// $smtp_from='remitente@ejemplo.gob.ar';   // opcional: remitente si es distinto del usuario
$smtp_from_name="Nombre del remitente";     // opcional
```

- `$smtp_host`, `$smtp_usuario` y `$smtp_password` son obligatorias. `$smtp_from` y `$smtp_from_name` son opcionales.
- La codificación de `mail.php` para los mails es ISO-8859-1. Si el nombre del remitente lleva tilde, escribirlo con la secuencia de escape de PHP entre comillas dobles, por ejemplo `"Desarrollo Estad\xEDstica"` (`\xED` = í), para no depender de la codificación del archivo.
- `tedede/configuracion_local_ejemplo.php` incluye las líneas con valores de relleno.
- Si falta alguna de las obligatorias, `enviarMail()` devuelve "falta definir la configuracion del SMTP (smtp_host, smtp_usuario y smtp_password) en configuracion_local.php" y no intenta enviar.
- **Hay que agregar las líneas en el `configuracion_local.php` de cada app y de cada servidor.**
- La clave anterior sigue en el historial de git. Conviene **cambiarla** en la cuenta de correo.

### Pendiente / a tener en cuenta

- En PHP 8.3 de XAMPP (`C:\xampp\php83`) no carga `curl`. Si alguna función lo usa, falta la extensión.
- Los deprecated de los puntos 11 y 13 son por clase / por dato: seguir revisando `error.log` al probar cada opción del menú.

---

## 2026-10-28

### 16. Scripts de deploy

Pasos para instalar un operativo en un servidor:

```bash
cd /var/www/adpe
bash descargar_operativo.sh etoi264     # 1. baja solo lo necesario a ./etoi264/
cd etoi264
bash crear_configuracion.sh etoi264     # 2. config local + permisos
# 3. en el navegador, logueado como programador: etoi264.php?hacer=actualizar_instalacion
```

La app queda en `https://<servidor>/adpe/etoi264/etoi264/etoi264.php`: la primera `etoi264` es el repo y la segunda, la carpeta del operativo.

#### `descargar_operativo.sh` (en coderun/operaciones)

Clona el repo con `git sparse-checkout`: en el disco quedan solo la carpeta del operativo, las carpetas compartidas que usa y los archivos de la raíz. `git pull` sigue funcionando para actualizar.

- Vive en el repo coderun (`coderun/operaciones/descargar_operativo.sh`), no en siehphp: no depende de nada de este repo y crea el clon en el directorio desde donde se lo llama. Se copia suelto al servidor.
- Carpetas compartidas: `tedede`, `encuestas`, `tercera`, `imagenes`, `tools`. Salen de las rutas `../<carpeta>/` que usan el operativo y el código compartido. Si en el futuro hace falta otra: `git sparse-checkout add <carpeta>`.
- La rama por defecto es `migracionphp8.3.36`. Se puede pasar otra como segundo argumento: `bash descargar_operativo.sh etoi264 master`.
- `--filter=blob:none` baja solo los archivos de las carpetas elegidas. Con `etoi264` ocupa ~11 MB y tarda unos segundos.
- Si el operativo no existe en la rama, avisa y borra el clon.

#### `crear_configuracion.sh`

- Pregunta los datos de conexión a la base interactivamente.
- La clave se ingresa sin eco (`stty -echo`) para compatibilidad con `sh/dash`.
- Crea `export/` y `logs/` en la raíz del proyecto, al lado de los operativos. `export/` va en la raíz porque `encuestas/proceso_exportar_base.php` escribe en `../export/`; está ignorada por git con `/export/` en `.gitignore`.
- Les da grupo `www-data` y `chmod 2775` a la carpeta del operativo, a `export/` y a `logs/`, y permiso de escritura de grupo a los archivos de una instalación anterior (`estructura_*.js`, `Tabla_plana_*.estructura.json`, `*.log`), para que el instalador web los pueda pisar.
- Al terminar indica qué poner en la URL para instalar: `<operativo>.php?hacer=actualizar_instalacion`.

---

## 2026-10-30

### 17. Documentación: README y bitácora

- `ajustes20261026.md` (pruebas en XAMPP) se unió a este archivo como la entrada del 2026-10-26 (puntos 9 a 15).
- La guía de instalación (PHP 8.3, nginx, permisos, arranque y problemas frecuentes), que estaba al principio de este archivo, pasó al [README](README.md), generalizada para cualquier operativo. El README también describe la estructura del repo, `crear_configuracion.sh` (con el ambiente `test`, `capa` o `produccion`), `descargar_operativo.sh` y las variables de `configuracion_local.php`, incluidas las del SMTP.
- Este archivo queda solo como bitácora por fecha.
