Estas son las instrucciones para instalar una Autoridad Certificadora usando el software libre EJBCA. Las instrucciones pueden seguirse usando Ubuntu Server 16 LTS o Debian 8. 

## Requisitos

* OpenJDK 8
* [JBoss EAP 7.0](https://developers.redhat.com/download-manager/file/jboss-eap-7.0.0.zip) 
* [EJBCA CE 6.5](https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_5_0/ejbca_ce_6_5.0.5.zip)


## Instrucciones

- Descargue este repositorio y guárdelo en su servidor dentro de la carpeta /opt. Asegurese de descargar y agregar el servidor de JBoss en esta misma carpeta (jboss-eap-7.0.0.zip)
 
- Prepare su servidor ejecutando los comandos de su sistema operativo (debian-jessie.sh o ubuntu-xenial.sh).  

- Ingrese a la carpeta 'configurar-jboss', habra el archivo comandos-jboss.txt. Ejecute estos comandos uno a uno, debe asegurarse de que JBoss porcesa cada comando con éxito uno a uno. Al final asegurese de copiar e instalar el certificado de superadmin en la maquina que desee. 

- La interfaz publica estará disponible en http://[ip servidor]:8080/ejbca. 

- Para las maquinas que tengan instalado el certificado de 'superadmin', la página de administración estará disponible en https://[ip servidor]:8443/ejbca/adminweb/. 

## Perfiles de Certificados

Estos perfiles define las características técnicas de los certificados. Ademas de los perfiles que instala por defecto EJBCA, el archivo perfiles-cert.zip contiene perfiles de certificados que pueden ser usados como referencia.  Para usarlos desde la página de Administración, seleccione 'CA Functions', 'Certificate Profiles', 'Import from Zip file'. Una vez importados los certificados, use la opción 'Certificate Authorities' para crear una CA Raíz y dos subordinadas.

 ```
         CA Raíz
     ------ | --------
     |               |

SubCA Personas     SubCA Servicios
```

## Perfiles de Entidades

Estos perfiles definen el contenido de certificados a usuarios o entidades finales. El archivo perfiles-enti.zip contiene perfiles de entidades que pueden ser usados como referencia.  Para usarlos desde la página de Administración, seleccione 'RA Functions', 'End Entity Profiles', 'Import from Zip file'. 

Una vez importados puede agregar usuarios desde la opción 'Add End Entity'. Cada usuario
creado podrá ingresar desde la web publica http://[ip servidor]:8080/ejbca y obtener su certificado. 

## Licencia

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  
