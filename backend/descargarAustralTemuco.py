import sys, os, re, urllib2

try:
	hay = False
	original = os.getcwd()
	anio, mes, dia = sys.argv[1][:4], sys.argv[1][4:6], sys.argv[1][6:8]
	
	print anio,mes,dia

	web = urllib2.urlopen('http://www.australtemuco.cl/impresa/'+anio+'/'+mes+'/'+dia+'/papel/')
	
	for lin in web:
		if lin.find('jump-to-section-pages') != -1:
			paginas = len(lin[:-1].split('http://www.australtemuco.cl/impresa/'))-1
			hay = True
			break

	if hay:
		
		print "paginas:",paginas
	
		for num in range(paginas):
			num += 1
		
			webImagen = urllib2.urlopen('http://www.australtemuco.cl/impresa/'+anio+'/'+mes+'/'+dia+'/full/'+str(num)+'/')
		
			for lin in webImagen:
				if lin.find('/AustralTemuco/') != -1 and lin.find('full-box box-1'):
					link = re.match('.+(http://.+\jpg)',lin).group(1)
					if paginas < 100:
						os.system('wget '+str(link)+' -O imagenes/'+dia+'_'+mes+'_'+\
							anio+'_pag_'+str(link[-11:-9])+str(link[-4:]))
					else:
						os.system('wget '+str(link)+' -O imagenes/'+dia+'_'+mes+'_'+\
							anio+'_pag_'+str(link[-12:-9])+str(link[-4:]))
					break
	else:
		print 'No existe un diario para esa fecha'

	print 'Creando PDF'
	os.chdir('imagenes')
	os.system('convert $(ls | grep '+dia+'_'+mes+'_'+anio+' | grep .jpg) '+dia+'_'+mes+'_'+anio+'.pdf')
	os.chdir(original)

	print "Borrando Imagenes"
	os.system('rm -rf  imagenes/'+dia+'_'+mes+'_'+anio+'*.jpg')

	print "Proceso Terminado"
			
except urllib2.HTTPError:
	print "pagina no encontrada"

except IndexError:
	print "ingresa la fecha pelotuo"

