#!/usr/bin/env bash
# Convierte los SVG de tool/escenarios/ en los PNG que usa la app (a 2x).
# Requiere rsvg-convert (paquete librsvg). Ejecutar desde la raíz del proyecto:
#   bash tool/generar_escenarios.sh
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p assets/images/escenarios
for svg in tool/escenarios/*.svg; do
  nombre=$(basename "$svg" .svg)
  rsvg-convert --zoom 2 "$svg" -o "assets/images/escenarios/$nombre.png"
  echo "assets/images/escenarios/$nombre.png"
done
