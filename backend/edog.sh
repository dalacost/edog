#|/bin/bash

FECHA_DIA=$(date +%d);
FECHA_MES=$(date +%m);
FECHA_ANO=$(date +%Y);

#descargar el diario autral del día
echo '[+]descargando diario austral del '$FECHA_ANO''$FECHA_MES''$FECHA_DIA;
python descargarAustralTemuco.py $FECHA_ANO''$FECHA_MES''$FECHA_DIA;
archivo_austral='imagenes/'$FECHA_DIA'_'$FECHA_MES'_'$FECHA_ANO'.pdf';
php edog_enviar.php archivo=$archivo_austral;
./lun_work.sh
php edog_enviar.php archivo=lun$(date +%Y%m%d).pdf
