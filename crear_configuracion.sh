#!/bin/bash
# crear_configuracion_local.sh
# Crea configuracion_local.php para un operativo.
# Uso:
#   ./crear_configuracion_local.sh etoi264
#   ./crear_configuracion_local.sh          (pide el nombre interactivo)

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

DB_HOST_DEF="localhost"
DB_PORT_DEF="5432"
DB_USER_DEF="tedede_php"
DB_NAME_DEF="${OPERATIVO}_produc_db"
DB_PASS_DEF=""
DEBUG_DEF="false"

# ── Pedir datos ───────────────────────────────────────────────────────────────

echo ""
echo "Configuración de base de datos para '$OPERATIVO'"
echo "(Enter para aceptar el valor entre corchetes)"
echo ""

read -rp "  Host          [$DB_HOST_DEF]: " DB_HOST
DB_HOST="${DB_HOST:-$DB_HOST_DEF}"

read -rp "  Puerto        [$DB_PORT_DEF]: " DB_PORT
DB_PORT="${DB_PORT:-$DB_PORT_DEF}"

read -rp "  Usuario DB    [$DB_USER_DEF]: " DB_USER
DB_USER="${DB_USER:-$DB_USER_DEF}"

read -rp "  Base de datos [$DB_NAME_DEF]: " DB_NAME
DB_NAME="${DB_NAME:-$DB_NAME_DEF}"

read -rsp "  Clave DB: " DB_PASS
echo ""
DB_PASS="${DB_PASS:-$DB_PASS_DEF}"

read -rp "  debug_via_notepadPP [$DEBUG_DEF]: " DEBUG
DEBUG="${DEBUG:-$DEBUG_DEF}"

# ── Generar el archivo ────────────────────────────────────────────────────────

cat > "$DESTINO" <<PHP
<?php
//UTF-8:SÍ
global \$parametros_db, \$ICON_APP, \$detenido, \$debug_via_notepadPP;

\$detenido = false;

\$debug_via_notepadPP = $DEBUG;

\$parametros_db->user     = '$DB_USER';
\$parametros_db->pass     = '$DB_PASS';
\$parametros_db->base_de_datos = '$DB_NAME';
\$parametros_db->host     = '$DB_HOST';
\$parametros_db->port     = '$DB_PORT';
PHP

# Agregar search_path solo si hay alguno definido (se puede editar a mano)
cat >> "$DESTINO" <<'PHP'
// $parametros_db->search_path = 'encu, dbo, comun, public';  // descomentar si hace falta

?>
PHP

echo ""
echo "Creado: $DESTINO"
echo ""
echo "Próximos pasos:"
echo "  1. Verificar permisos de escritura:"
echo "     sudo chgrp www-data $OPERATIVO logs 2>/dev/null || true"
echo "     sudo chmod 2775     $OPERATIVO logs 2>/dev/null || true"
echo "  2. Entrar con usuario programador:"
echo "     ?hacer=actualizar_instalacion"
