#!/bin/bash
#Script para generar las carpetas correspondientes a un nuevo operativo

if [ $# -eq 0 ]; then
    echo "Invocar con 3 parametros : \.generar_nuevas_carpetas.sh path_absoluto_proyecto carpeta_origen carpeta_nueva"
	exit
fi
cpath=$1
corigen=$2
cnueva=$3
export corigen
export cnueva

pref=""
echo " Origen $corigen Nueva $cnueva "
# controlar existencia de origen y no existencia de Nueva
if [ ! -d "$cpath/$pref$corigen" ]; then
    echo "La carpeta Origen No existe." && exit
fi
if [ -d "$cpath/$pref$cnueva" ]; then
    echo "La carpeta Nueva $cpath/$pref$cnueva existe." && exit
fi
for it in {1..2}; do
   echo "Iteracion $it"
   cp -r $cpath/$pref$corigen $cpath/$pref$cnueva
   echo "carpeta para renombrar archivos $cpath/$pref$cnueva"
   cd "$cpath/$pref$cnueva"||(echo " No existe Nueva $pref$cnueva" && exit)
   find . -name "*$corigen*" -exec bash -c 'mv "$1" "${1//"$corigen"/"$cnueva"}"' _ {} \;
   echo "reemplazando origen $corigen dentro de los archivos..."
   find ./ -type f -not -name "*.pdf" -not -name "*.png" -not -name "*.gif" -not -name "*.svg" -not -name "*.jpg" -exec grep -l "$corigen" {} \;| xargs sed -i "s/$corigen/$cnueva/g"
   
    pref="operaciones_"
   cd ..
done
echo 'Falta revisar nro onda, busqueda de mayusculas '