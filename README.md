Estas son las instrucciones para instalar una Autoridad Certificadora usando el software libre EJBCA. Las instrucciones pueden seguirse usando Ubuntu Server 16 LTS o Debian 8. 

## Requisitos

* OpenJDK 8
* [JBoss EAP 7.0](https://developers.redhat.com/download-manager/file/jboss-eap-7.0.0.zip) 
* [EJBCA CE 6.5](https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_5_0/ejbca_ce_6_5.0.5.zip)


## Instrucciones

- Descargue este repositorio y guárdelo en su servidor dentro de la carpeta /opt. Asegurese de agregar de descargar y agregar el servidor de JBoss en esta misma carpeta (jboss-eap-7.0.0.zip)
 
- Prepare su servidor ejecutando los comandos de su sistema operativo (debian-jessie.sh o ubuntu-xenial.sh).  

- Ingrese a la carpeta 'configurar-jboss', habra el archivo comandos-jboss.txt. Ejecute estos comandos uno a uno, debe asegurarse de que JBoss los comandos procesa con éxito. Al final asegurese de copiar e instalar el certificado de superadmin en la maquina que desee. 

- La interfaz publica estará disponible en http://[ip servidor]:8080/ejbca. 

- Para las maquinas que tengan instalado el certificado de 'superadmin', la página de administración estará disponible en https://[ip servidor]:8443/ejbca/adminweb/. 

## Licencia

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  
