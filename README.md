# siehphp

Fuentes legacy del SIEH: las aplicaciones web de los operativos de encuesta (`etoi*`, `eah*`, `ut*`, `vcm*`, etc.) sobre un framework PHP propio (`tedede`) y PostgreSQL.

El código corre en **PHP 8.3** y se mantiene compatible con PHP 7. El historial de cambios de la migración está en [ajustes.md](ajustes.md).

---

## Requisitos

| | Versión probada | Comentario |
|---|---|---|
| PHP | 8.3.36 | con `pdo_pgsql`, `mbstring`, `openssl` (mails), `xml`, `zip`, `curl` |
| PostgreSQL | 17 | el locale `es_ES.UTF-8` tiene que estar generado (ver [Base de datos](#3-base-de-datos)) |
| Servidor web | nginx 1.24 + PHP-FPM | en desarrollo también anda con Apache (XAMPP con `php83`) |
| Sistema | Ubuntu 24.04 | |

## Estructura

| Carpeta | Contenido |
|---|---|
| `tedede/` | framework compartido: conexión a la base, armado de pantallas, grillas, login, procesos, mails |
| `encuestas/` | código común a todos los operativos: procesos, tablas, consistencias, exportación |
| `tercera/` | bibliotecas de terceros (PHPMailer 6.9.3, etc.) |
| `imagenes/`, `tools/` | recursos compartidos |
| `<operativo>/` | una carpeta por operativo (`etoi264/`, `eah2024/`, ...). El punto de entrada es `<operativo>/<operativo>.php` |
| `operaciones_<operativo>/` | scripts SQL y utilidades del operativo; no los usa la app web |
| `logs/`, `export/` | los escribe la app; no están en git |

Cada operativo se configura con su propio `<operativo>/configuracion_local.php` (ignorado por git). Los archivos `estructura_<operativo>.js` y `Tabla_plana_*.estructura.json` los genera la app al instalarse y tampoco están en git.

---

## Instalación del servidor

Comandos para la terminal de un Ubuntu 24.04. En los ejemplos el proyecto está en `/var/www/sieh1`, y `usuario` es el usuario dueño de los archivos que hace el deploy.

### 1. PHP 8.3

Se usa el PPA de Ondřej Surý (`deb.sury.org`), que trae la última versión de PHP 8.3; Ubuntu 24.04 trae la 8.3.6.

```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php8.3-fpm php8.3-cli php8.3-pgsql php8.3-mbstring php8.3-xml php8.3-curl php8.3-zip php8.3-opcache
```

| Paquete | Para qué |
|---|---|
| `php8.3-fpm` | el proceso PHP que atiende a nginx |
| `php8.3-cli` | `php` en la terminal (scripts y pruebas; `crear_configuracion.sh` lo usa para probar la conexión) |
| `php8.3-pgsql` | `pdo_pgsql` y `pgsql`, **imprescindible** para la conexión a Postgres |
| `php8.3-mbstring` | funciones `mb_*` (UTF-8); también la usa PHPMailer |
| `php8.3-xml` | DOM, SimpleXML, XMLReader/Writer |
| `php8.3-curl`, `php8.3-zip` | llamadas HTTP y archivos zip |
| `php8.3-opcache` | caché de código; mejora la velocidad |

Para verificar:

```bash
php -v                                       # PHP 8.3.x
php-fpm8.3 -m | grep -iE 'pdo_pgsql|pgsql|mbstring'
```

**`php.ini`:** `/etc/php/8.3/fpm/php.ini` se deja igual que el `php.ini-production`. Los valores que importan:

| Directiva | Valor | Comentario |
|---|---|---|
| `display_errors` | `Off` | los errores van al log de nginx (ver [Problemas frecuentes](#problemas-frecuentes)) |
| `short_open_tag` | `Off` | el código usa `<?php` |
| `date.timezone` | `UTC` | no importa: la app fija `America/Argentina/Buenos_Aires` en `tedede/lo_imprescindible.php` |
| `memory_limit` | `128M` | |
| `max_execution_time` | `30` | |
| `post_max_size` / `upload_max_filesize` | `8M` / `2M` | |
| `session.save_path` | `/var/lib/php/sessions` | |

**Pool de PHP-FPM:** `/etc/php/8.3/fpm/pool.d/www.conf` se usa tal como viene:

```ini
[www]
user = www-data
group = www-data
listen = /run/php/php8.3-fpm.sock    ; este socket lo usa nginx
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 5
```

> `pm.max_children = 5` limita a 5 los pedidos PHP simultáneos. Con muchos usuarios a la vez, conviene subirlo según la memoria del servidor.

Si se cambia algo de PHP:

```bash
sudo php-fpm8.3 -t                  # valida la configuración
sudo systemctl restart php8.3-fpm
```

### 2. nginx

```bash
sudo apt install -y nginx
sudo cp -n /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak_antes_sieh1
```

En `/etc/nginx/sites-available/default` se agrega la ruta `/sieh1/`, que apunta al proyecto y pasa los `.php` a PHP-FPM. El bloque `server` queda así:

```nginx
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;
	server_name _;

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

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php8.3-fpm.sock;
	}
}
```

- `^~ /sieh1/` le da prioridad a esta ruta sobre el `location ~ \.php$` general. `root /var/www` + URL `/sieh1/...` da `/var/www/sieh1/...`. Si el proyecto está en otra carpeta, cambiar ambos.
- `fastcgi_pass` tiene que coincidir con el `listen` del pool de PHP-FPM.
- Los `.htaccess` del proyecto son de Apache y **nginx no los lee**. Lo único necesario de ellos se replicó: el tipo `text/cache-manifest` de los `.manifest`. No se replicó el proxy de `^tabulado$` a `localhost:3003`.
- Si el servidor tiene nombre de dominio, se puede poner en `server_name` en lugar de `_`.

```bash
sudo nginx -t                 # valida la sintaxis
sudo systemctl restart nginx  # restart: con reload el cambio no se aplicó
```

### 3. Base de datos

`crear_<operativo>.sql` pide el locale `es_ES.UTF-8` para `LC_COLLATE`/`LC_CTYPE`, y Ubuntu no lo trae generado. Hay que generarlo **antes** de crear la base:

```bash
sudo locale-gen es_ES.UTF-8
sudo systemctl restart postgresql
```

Si la base se restaura de un `pg_dump`, el dump no incluye los `ALTER DATABASE ... SET`, y hay que volver a fijar el `search_path` (si no, faltan funciones como `para_ordenar_numeros`):

```sql
alter database <base> set search_path = encu, dbo, comun, public;
```

> Si en el servidor hay más de un cluster de Postgres, cada uno usa otro puerto (5432, 5433, ...). Para ver cuál es cuál: `pg_lsclusters`.

### 4. Arrancar los servicios

```bash
sudo systemctl enable --now php8.3-fpm nginx
systemctl is-active php8.3-fpm nginx postgresql     # los tres: active
sudo ufw allow 'Nginx HTTP'                         # solo si ufw está activo
```

---

## Instalar un operativo

```bash
cd /var/www/sieh1
bash crear_configuracion.sh etoi264 test        # ambiente: test (por defecto), capa o produccion
```

`crear_configuracion.sh` (en la raíz del repo):

- Pide los datos de conexión a la base (la clave sin eco) y prueba la conexión con `php`. Si falla, lista las bases disponibles. El nombre de base propuesto depende del ambiente: `<operativo>_test_db`, `<operativo>_capa_db` o `<operativo>_db`.
- Escribe `<operativo>/configuracion_local.php`. Si ya existe, pregunta antes de pisarlo.
- Crea `export/` y `logs/` en la raíz y les da grupo `www-data` y `chmod 2775`, igual que a la carpeta del operativo, para que PHP pueda escribir.

Después, en el navegador, entrar con un usuario de rol `programador` a:

```
http://<servidor>/sieh1/etoi264/etoi264.php?hacer=actualizar_instalacion
```

Ese proceso (Mantenimiento → "Actualizar Instalación") genera `estructura_<operativo>.js` y los `Tabla_plana_*.estructura.json`, y reinstala los triggers de `tem` y las restricciones de `respuestas`. Sin esos archivos el menú falla (`syntax error at end of input`). Hay que volver a correrlo si cambian los metadatos o si se restaura la base.

> Los procesos de tipo `Proceso_Generico` se ejecutan con solo abrir la URL (`?hacer=...`), sin confirmación.

### Descargar un solo operativo

Para no clonar el repo entero en un servidor, `descargar_operativo.sh` (vive en el repo coderun, `coderun/operaciones/`) hace un `git sparse-checkout` con la carpeta del operativo y las compartidas (`tedede`, `encuestas`, `tercera`, `imagenes`, `tools`):

```bash
cd /var/www/adpe
bash descargar_operativo.sh etoi264             # rama por defecto: migracionphp8.3.36
cd etoi264
bash crear_configuracion.sh etoi264
```

La app queda en `https://<servidor>/adpe/etoi264/etoi264/etoi264.php`: la primera `etoi264` es el repo y la segunda, la carpeta del operativo. `git pull` sigue funcionando para actualizar.

---

## `configuracion_local.php`

Lo genera `crear_configuracion.sh`. Las variables principales:

```php
$parametros_db->user          = 'tedede_php';
$parametros_db->pass          = 'la_clave';
$parametros_db->base_de_datos = 'etoi264_test_db';
$parametros_db->host          = 'localhost';
$parametros_db->port          = '5432';

$esta_es_la_base_en_produccion   = false;
$esta_es_la_base_de_capacitacion = false;
$debug_via_notepadPP = true;   // muestra mensaje y stack trace de las excepciones. NO dejarlo en producción
```

### Envío de mails (SMTP)

`tedede/mail.php` (PHPMailer 6.9.3) toma el servidor y la cuenta de estas variables, que hay que agregar a mano en el `configuracion_local.php` de cada operativo y de cada servidor:

```php
$smtp_host='smtp.ejemplo.gob.ar';           // obligatoria
$smtp_usuario='usuario@ejemplo.gob.ar';     // obligatoria; por defecto también es el remitente
$smtp_password='la_clave';                  // obligatoria
// $smtp_from='remitente@ejemplo.gob.ar';   // opcional
$smtp_from_name="Nombre del remitente";     // opcional
```

- Si falta alguna obligatoria, `enviarMail()` devuelve un error y no intenta enviar.
- Los mails van en ISO-8859-1: si el nombre del remitente lleva tilde, escribirlo con escape entre comillas dobles, por ejemplo `"Desarrollo Estad\xEDstica"` (`\xED` = í).
- Si falla STARTTLS por el certificado del servidor SMTP, agregar `$mail->SMTPAutoTLS = false;` en `mail.php`.
- `tedede/configuracion_local_ejemplo.php` tiene las líneas con valores de relleno.

---

## Problemas frecuentes

Con `display_errors = Off`, los errores de PHP salen en el log de nginx con el prefijo `FastCGI sent in stderr: "PHP message: ..."`:

```bash
sudo tail -f /var/log/nginx/error.log
```

| Síntoma | Causa probable |
|---|---|
| **404** en `/sieh1/...` | falta el bloque `location ^~ /sieh1/`, o nginx no se reinició |
| **502 Bad Gateway** | `php8.3-fpm` está parado, o el socket de `fastcgi_pass` no coincide |
| **500** | error fatal de PHP; mirar el `error.log` |
| `Permission denied` en el log | falta el grupo `www-data` en `logs/`, `export/` o la carpeta del operativo (`crear_configuracion.sh` lo arregla) |
| `git pull` da "Permission denied" | el repo se clonó o actualizó con `sudo`: `sudo chown -R usuario:usuario /var/www/sieh1` y volver a correr `crear_configuracion.sh` |
| 404 en `estructura_<operativo>.js` | falta correr `?hacer=actualizar_instalacion` |
| `function ... does not exist` | `search_path` de la base (ver [Base de datos](#3-base-de-datos)) |
| No conecta a la base | host, puerto y clave en `configuracion_local.php`, y que Postgres esté activo |
| Aparece un error que [ajustes.md](ajustes.md) da por corregido | el servidor tiene una copia vieja de `tedede/`: actualizarla y reiniciar PHP-FPM para limpiar OPcache |
