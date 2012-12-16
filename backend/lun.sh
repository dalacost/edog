#! /bin/bash

for i in $(curl http://www.lun.com/pages/LUNHomepage.aspx?BodyID=0 | grep PrintPage | awk -FPrintPage '{print $2}' | awk -F';' '{print $1}'|sed 's/(//g'|sed 's/)//g'|sed "s/'//g" );

do wget $i;
	pg=$(basename $i);
	swfrender $pg -o $pg"LUN_intermedio.png";
	rm -f $pg;
done

convert $(ls | grep LUN_intermedio | grep .png) LUN_$(date +%Y%m%d).pdf;

#rm -f *LUN_intermedio.png;

