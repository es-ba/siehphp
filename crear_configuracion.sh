#!/bin/bash
# crear_configuracion.sh
# Crea configuracion_local.php para un operativo.
# Uso:
#   ./crear_configuracion.sh etoi264
#   ./crear_configuracion.sh          (pide el nombre interactivo)

set -e

# ── Nombre del operativo ─────────────────────────────────────────────────────

OPERATIVO="${1:-}"

if [ -z "$OPERATIVO" ]; then
    # Listar carpetas que parecen operativos (tienen un .php con el mismo nombre)
    echo "Operativos disponibles:"
    for d in */; do
        d="${d%/}"
        if [ -f "$d/$d.php" ]; then
            printf "  %s\n" "$d"
        fi
    done
    echo ""
    read -rp "Nombre del operativo: " OPERATIVO
fi

DESTINO="$OPERATIVO/configuracion_local.php"

if [ ! -d "$OPERATIVO" ]; then
    echo "Error: no existe la carpeta '$OPERATIVO'." >&2
    exit 1
fi

if [ -f "$DESTINO" ]; then
    echo "Ya existe $DESTINO"
    read -rp "¿Sobreescribir? [s/N] " RESP
    if [[ ! "$RESP" =~ ^[sS]$ ]]; then
        echo "Cancelado."
        exit 0
    fi
fi

# ── Valores por defecto ───────────────────────────────────────────────────────

DB_HOST_DEF="192.168.3.44"
DB_PORT_DEF="5433"
DB_USER_DEF="tedede_php"
DB_NAME_DEF="${OPERATIVO}_test_db"
DB_PASS_DEF=""
DEBUG_DEF="true"
PRODUCCION_DEF="false"
COLOR_DEF="#C6DEBA"
ES_TELE_DEF="false"

# ── Pedir datos ───────────────────────────────────────────────────────────────

echo ""
echo "Configuración de base de datos para '$OPERATIVO'"
echo "(Enter para aceptar el valor entre corchetes)"
echo ""

# Prueba la conexión con php (el mismo driver que usa la app). Si falla y el
# servidor responde, lista las bases disponibles para ayudar a elegir el nombre.
PROBAR_DB='
$dsn = "pgsql:host=".getenv("DB_HOST").";port=".getenv("DB_PORT");
try {
    new PDO("$dsn;dbname=".getenv("DB_NAME"), getenv("DB_USER"), getenv("DB_PASS"));
    echo "  OK: la base responde.\n";
} catch (PDOException $e) {
    echo "  ERROR: ", $e->getMessage(), "\n";
    try {
        $db = new PDO("$dsn;dbname=postgres", getenv("DB_USER"), getenv("DB_PASS"));
        $bases = $db->query("select datname from pg_database where not datistemplate order by 1")->fetchAll(PDO::FETCH_COLUMN);
        echo "  Bases disponibles:\n    ", implode("\n    ", $bases), "\n";
    } catch (PDOException $e2) {
    }
    exit(1);
}
'

while true; do
    read -rp "  Host DB        [$DB_HOST_DEF]: " DB_HOST
    DB_HOST="${DB_HOST:-$DB_HOST_DEF}"

    read -rp "  Puerto DB      [$DB_PORT_DEF]: " DB_PORT
    DB_PORT="${DB_PORT:-$DB_PORT_DEF}"

    read -rp "  Usuario DB    [$DB_USER_DEF]: " DB_USER
    DB_USER="${DB_USER:-$DB_USER_DEF}"

    read -rp "  Base de datos [$DB_NAME_DEF]: " DB_NAME
    DB_NAME="${DB_NAME:-$DB_NAME_DEF}"

    printf "  Clave DB: "
    stty -echo 2>/dev/null; read -r DB_PASS; stty echo 2>/dev/null
    echo ""
    DB_PASS="${DB_PASS:-$DB_PASS_DEF}"

    if ! command -v php >/dev/null; then
        echo "  Aviso: no hay php de línea de comandos; no se prueba la conexión." >&2
        break
    fi

    echo ""
    echo "  Probando conexión a $DB_NAME en $DB_HOST:$DB_PORT ..."
    if DB_HOST="$DB_HOST" DB_PORT="$DB_PORT" DB_USER="$DB_USER" DB_NAME="$DB_NAME" DB_PASS="$DB_PASS" \
        php -r "$PROBAR_DB"; then
        break
    fi

    echo ""
    read -rp "  ¿Volver a cargar los datos de la base? [S/n] " RESP
    if [[ "$RESP" =~ ^[nN]$ ]]; then
        echo "  Se sigue con estos datos; la app no va a poder conectarse hasta corregirlos."
        break
    fi
    # En el reintento, Enter conserva lo que se cargó recién
    DB_HOST_DEF="$DB_HOST"; DB_PORT_DEF="$DB_PORT"; DB_USER_DEF="$DB_USER"
    DB_NAME_DEF="$DB_NAME"; DB_PASS_DEF="$DB_PASS"
    echo ""
done

echo ""
echo "Configuración de la aplicación"
echo ""

read -rp "  debug_via_notepadPP       [$DEBUG_DEF]: " DEBUG
DEBUG="${DEBUG:-$DEBUG_DEF}"

read -rp "  esta_es_la_base_en_produccion [$PRODUCCION_DEF]: " PRODUCCION
PRODUCCION="${PRODUCCION:-$PRODUCCION_DEF}"

if [[ "$PRODUCCION" =~ ^[tT]rue$|^1$ ]]; then
    read -rp "  color_de_fondo            [$COLOR_DEF]: " COLOR
    COLOR="${COLOR:-$COLOR_DEF}"
    COLOR_LINE="\$color_de_fondo_de_la_aplicacion = '$COLOR';"
else
    COLOR_LINE="// \$color_de_fondo_de_la_aplicacion = '$COLOR_DEF';  // descomentar para activar"
fi

read -rp "  es_tele_etoi              [$ES_TELE_DEF]: " ES_TELE
ES_TELE="${ES_TELE:-$ES_TELE_DEF}"

# ── Permisos de escritura ─────────────────────────────────────────────────────

if [ ! -w "$OPERATIVO" ]; then
    echo "Sin permiso de escritura en '$OPERATIVO', corrigiendo con sudo chown ..."
    sudo chown -R "$(whoami):$(whoami)" "$OPERATIVO"
fi

# ── Generar el archivo ────────────────────────────────────────────────────────

cat > "$DESTINO" <<PHP
<?php
//UTF-8:SÍ
global \$parametros_db, \$ICON_APP, \$detenido, \$debug_via_notepadPP,
       \$color_de_fondo_de_la_aplicacion, \$img_de_fondo_de_la_aplicacion,
       \$revisando_metadatos, \$es_tele_etoi;

\$esta_es_la_base_en_produccion = $PRODUCCION;
\$revisando_metadatos           = true;
\$es_tele_etoi                  = $ES_TELE;

\$detenido           = false;
\$debug_via_notepadPP = $DEBUG;

\$loguear_ultimos_debug_trace = 1;
// \$loguear_excepciones_hasta = '2026-01-01';   // descomentar para activar
// \$pdo_log_sql_hasta_fecha   = '2026-01-01';   // descomentar para activar

$COLOR_LINE
\$img_de_fondo_de_la_aplicacion   = '${OPERATIVO}_fondo_t.png';
\$ICON_APP                        = '../${OPERATIVO}/${OPERATIVO}_icon.png';

\$parametros_db->user          = '$DB_USER';
\$parametros_db->pass          = '$DB_PASS';
\$parametros_db->base_de_datos = '$DB_NAME';
\$parametros_db->host          = '$DB_HOST';
\$parametros_db->port          = '$DB_PORT';
PHP

cat >> "$DESTINO" <<'PHP'
// $parametros_db->search_path = 'encu, dbo, comun, public';  // descomentar si hace falta

?>
PHP

# export/ va en la raíz: encuestas/proceso_exportar_base.php escribe en ../export/
mkdir -p export logs

# ── Permisos para que PHP (www-data) pueda escribir ──────────────────────────

echo ""
echo "Ajustando permisos para www-data ..."
sudo chgrp www-data "$OPERATIVO" export logs
sudo chmod 2775     "$OPERATIVO" export logs
# Archivos de una instalación anterior: si quedaron de otro grupo, PHP no los puede pisar
sudo find "$OPERATIVO" export logs -maxdepth 1 -type f \
    \( -name 'estructura_*.js' -o -name 'Tabla_plana_*.estructura.json' -o -name '*.log' \) \
    -exec chgrp www-data {} + -exec chmod g+w {} +

echo ""
echo "Creado: $DESTINO"
echo ""
echo "Para instalar, entrá a la app con usuario programador y en la URL"
echo "reemplazá lo que sigue a la última barra por:"
echo "  $OPERATIVO.php?hacer=actualizar_instalacion"
