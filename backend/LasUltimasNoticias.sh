#!/bin/bash
# Uso :
# Para el lun de hoy
# 	sh lun_work.sh
# Para el lun de fechas anteriores
#	./lun_work.sh 2012-11-01
#

if (($# == 0)); then
	fecha=$(date +%Y-%m-%d);
else
	fecha=$1;
fi

NOMBRE_PERIODICO="Las_Ultimas_Noticias";
DIRECTORIO_RAIZ="periodicos";
ANO=$(echo $fecha | sed 's/\(.*\)-\(.*\)-\(.*\)$/\1/g');
MES=$(echo $fecha | sed 's/\(.*\)-\(.*\)-\(.*\)$/\2/g');
DIA=$(echo $fecha | sed 's/\(.*\)-\(.*\)-\(.*\)$/\3/g');

PARAMETROS_WGET="-c"; #-c para continuar, nada para bajar siempre.

if [ ! -d "$DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES" ]; then
	mkdir -p $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES
fi

if [ ! -f "$DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_pages_$ANO"_"$MES"_"$DIA.txt" ]; then
	pages=$(curl "http://www.lun.com/pages/LUNHomepage.aspx?BodyID=0&dt=$fecha" | grep PrintPage | grep http | awk -FPrintPage '{print $2}' | awk -F';' '{print $1}' | sed 's/(//g' | sed 's/)//g' | sed "s/'//g" ); 
	echo $pages > $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_pages_$ANO"_"$MES"_"$DIA.txt;
else
	pages=$(cat $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_pages_$ANO"_"$MES"_"$DIA.txt);
fi

for i in $(echo $pages); do

#    nombre_archivo=$(expr substr $i  2);
    pg=$(basename $i);
    wget $PARAMETROS_WGET $i -O $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg;
	swfrender $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg -o $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg.png;
	rm -f $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg;
#    pngtopnm $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".png" > $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".pnm";
#    pnmtops $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".pnm" > $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".ps"
#    ps2pdf $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".ps"
#    rm -f $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg
#    rm -f $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".ps"
#    rm -f $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/LUN_$DIA_$pg".pnm"

done
#pdfmerge $(ls -otr *.swf.pdf | awk '{print $8}') "lun$(echo $fecha).pdf"
#pdftk $(ls -la $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/*.swf.pdf | awk '{print $8}') cat output lun$(echo $fecha).pdf
convert $(ls -la $DIRECTORIO_RAIZ/$NOMBRE_PERIODICO/$ANO/$MES/*.swf.png | awk '{print $8}') LUN_$DIA.pdf
#rm -f *.swf.pdf
