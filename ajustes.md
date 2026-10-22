# Ajustes para correr etoi262 en Ubuntu 24.04

Registro de los cambios hechos para levantar `etoi262` en un servidor Ubuntu 24.04 con nginx, PHP 8.3 y PostgreSQL 17.

URL de la app: `http://<servidor>/sieh1/etoi262/etoi262.php`

---

## Instalación de PHP 8.3 y nginx para que ande la aplicación

Configuración probada: Ubuntu 24.04.5 LTS, **PHP 8.3.36** (PHP-FPM) y **nginx 1.24.0**. Todos los comandos van en la terminal del servidor. En los ejemplos, el proyecto está en `/var/www/sieh1`, y `usuario` es el usuario del sistema que es dueño de los archivos y hace el deploy.

### Paso 1. Instalar PHP 8.3

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
| `php8.3-cli` | `php` en la terminal (scripts y pruebas) |
| `php8.3-pgsql` | `pdo_pgsql` y `pgsql`, **imprescindible** para la conexión a Postgres |
| `php8.3-mbstring` | funciones `mb_*` (UTF-8) |
| `php8.3-xml` | DOM, SimpleXML, XMLReader/Writer |
| `php8.3-curl`, `php8.3-zip` | llamadas HTTP y archivos zip |
| `php8.3-opcache` | caché de código; mejora la velocidad |

Para verificar:

```bash
php -v                                       # PHP 8.3.x
php-fpm8.3 -m | grep -iE 'pdo_pgsql|pgsql|mbstring'
```

### Paso 2. Configurar PHP 8.3

**`php.ini`:** `/etc/php/8.3/fpm/php.ini` se deja **igual que el `php.ini-production`**, sin cambios. Los valores que importan:

| Directiva | Valor | Comentario |
|---|---|---|
| `display_errors` | `Off` | los errores no salen en pantalla; van al log de nginx (ver Paso 5) |
| `short_open_tag` | `Off` | el código usa `<?php`, no hace falta |
| `date.timezone` | `UTC` | no importa: la app fija la zona en `tedede/lo_imprescindible.php` (ver punto 4) |
| `memory_limit` | `128M` | |
| `max_execution_time` | `30` | |
| `post_max_size` / `upload_max_filesize` | `8M` / `2M` | |
| `session.save_path` | `/var/lib/php/sessions` | |

Para ver los errores en pantalla mientras se prueba, la app tiene su propio interruptor en `etoi262/configuracion_local.php`, sin tocar el `php.ini`. **No dejarlo activado en producción.**

```php
$debug_via_notepadPP=true;   // muestra mensaje y stack trace de las excepciones
```

**Pool de PHP-FPM:** `/etc/php/8.3/fpm/pool.d/www.conf` se usa tal como viene. Lo importante:

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

> `pm.max_children = 5` es el valor por defecto y limita a 5 los pedidos PHP simultáneos. Con muchos usuarios a la vez, conviene subirlo según la memoria del servidor.

Si se cambia algo de PHP:

```bash
sudo php-fpm8.3 -t                  # valida la configuración
sudo systemctl restart php8.3-fpm
```

### Paso 3. Instalar y configurar nginx

```bash
sudo apt install -y nginx
```

nginx sirve por defecto solo `/var/www/html`. Hay que agregar la ruta `/sieh1/` para que apunte al proyecto (`/var/www/sieh1`) y pase los `.php` a PHP-FPM 8.3.

**Archivo:** `/etc/nginx/sites-available/default` (`sites-enabled/default` es un enlace a este). Antes de tocarlo:

```bash
sudo cp -n /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak_antes_sieh1
```

Así tiene que quedar el bloque `server`:

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

- `^~ /sieh1/` hace que esta ruta tenga prioridad sobre el `location ~ \.php$` general.
- `root /var/www` + URL `/sieh1/...` da `/var/www/sieh1/...`.
- `fastcgi_pass` tiene que coincidir con el `listen` del pool de PHP-FPM (Paso 2).
- `snippets/fastcgi-php.conf` viene con nginx. Arma `SCRIPT_FILENAME` y devuelve 404 si el `.php` no existe.
- Los `.htaccess` del proyecto son de Apache y **nginx no los lee**. Lo único necesario de ellos se replicó: el tipo `text/cache-manifest` de los `.manifest`.
- Si el servidor tiene nombre de dominio, se puede poner en `server_name` en lugar de `_`.

Para aplicar:

```bash
sudo nginx -t                 # valida la sintaxis
sudo systemctl restart nginx  # restart: con reload el cambio no se aplicó
```

### Paso 4. Permisos de las carpetas

PHP-FPM corre como `www-data`, y el proyecto es de `usuario`. Para leer alcanza con los permisos `755`. Para escribir, se le da grupo `www-data` a las carpetas donde escribe la app:

```bash
sudo chgrp www-data /var/www/sieh1/logs /var/www/sieh1/etoi262
sudo chmod 2775     /var/www/sieh1/logs /var/www/sieh1/etoi262
```

- `logs/`: logs de login y de SQL.
- `etoi262/`: archivos generados `estructura_etoi262.js` y `Tabla_plana_*.estructura.json` (ver punto 7).
- El `2` (setgid) hace que lo que se cree adentro herede el grupo `www-data`.

> Si el repo se clonó o se actualizó con `sudo`, los archivos quedan con dueño `root`, y después `git pull` falla con "Permission denied". Para corregirlo:
> ```bash
> sudo chown -R usuario:usuario /var/www/sieh1
> ```
> Después de eso hay que repetir los `chgrp`/`chmod` de arriba.

### Paso 5. Arrancar los servicios y probar

```bash
sudo systemctl enable --now php8.3-fpm nginx
systemctl is-active php8.3-fpm nginx postgresql     # los tres: active
```

Si el firewall (`ufw`) está activo, hay que abrir el puerto 80:

```bash
sudo ufw allow 'Nginx HTTP'
```

Prueba en el servidor:

```bash
curl -s -o /dev/null -w '%{http_code}\n' -L http://localhost/sieh1/etoi262/etoi262.php   # 200 (pantalla de login)
```

Desde otra máquina, abrir `http://<IP o nombre del servidor>/sieh1/etoi262/etoi262.php` en el navegador.

**Dónde ver los errores:** con `display_errors = Off`, los errores de PHP salen en el log de nginx, con el prefijo `FastCGI sent in stderr: "PHP message: ..."`:

```bash
sudo tail -f /var/log/nginx/error.log
```

| Síntoma | Causa probable |
|---|---|
| **404** en `/sieh1/...` | falta el bloque `location ^~ /sieh1/`, o nginx no se reinició |
| **502 Bad Gateway** | `php8.3-fpm` está parado, o el socket de `fastcgi_pass` no coincide |
| **500** | error fatal de PHP; mirar el `error.log` |
| `Permission denied` en el log | falta el Paso 4 |
| No conecta a la base | revisar host, puerto y clave en `configuracion_local.php`, y que Postgres esté activo |
| No abre desde otra máquina | firewall (`ufw`) o red |

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
