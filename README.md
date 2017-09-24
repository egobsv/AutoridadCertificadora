Estas son las instrucciones para instalar una Autoridad Certificadora usando el software libre EJBCA.

#Requisitos

* OpenJDK 8
* [JBoss EAP 7.0](https://developers.redhat.com/download-manager/file/jboss-eap-7.0.0.zip) 
* [EJBCA CE 6.5](https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_5_0/ejbca_ce_6_5.0.5.zip)

Las instrucciones pueden seguirse usando Ubuntu Server 16 LTS o Debian 8. 

##Instrucciones

- Descargue este repositorio y guárdelo en su servidor dentro de la carpeta /opt. Asegurese de agregar de descargar y agregar el servidor de JBoss en esta misma carpeta (jboss-eap-7.0.0.zip)
 
- Prepare su servidor ejecutando los comandos de su sistema operativo (debian-jessie.sh o ubuntu-xenial.sh).  

- Ingrese a la carpeta 'configurar-jboss', habra el archivo comandos-jboss.txt. Ejecute estos comandos uno a uno, asegurese de que JBoss los comandos procesa con éxito. Al final asegurese de copiar e instalar el certificado de superadmin en la maquina que desee. 

- La interfaz publica estara disponible en http://[ip servidor]:8080/ejbca. La pagina de administración esta disponible solo para las maquinas  que tengan instalado el certificado de 'superadmin'. 
