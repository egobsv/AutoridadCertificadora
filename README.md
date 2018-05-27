
## Instalación de una PKI
Estas son las instrucciones para instalar una PKI, Autoridad Certificadora y sus servicios asociados, usando el software libre EJBCA. Las instrucciones pueden seguirse usando Ubuntu Server 16 LTS o Debian 8. 
EJBCA es la implementación de referencia de una PKI que ofrece un [amplio número de servicios](https://www.ejbca.org/features.html) asociados a la firma electrónica. 

### Requisitos de Instalación

* OpenJDK 8
* [JBoss EAP 7.0](https://developers.redhat.com/download-manager/file/jboss-eap-7.0.0.zip) 
* [EJBCA CE 6.5](https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_5_0/ejbca_ce_6_5.0.5.zip)


### Instrucciones

- Descargue este repositorio y guárdelo en su servidor dentro de la carpeta /opt. Asegurese de descargar y agregar el servidor de JBoss en esta misma carpeta (jboss-eap-7.0.0.zip)
 
- Prepare su servidor ejecutando los comandos de su sistema operativo (debian-jessie.sh o ubuntu-xenial.sh).  

- Edite la variable 'ca.dn' dentro de /opt/ejbca/conf/install.properties. Este es el nombre de la CA administrativa creada por defecto y no tiene ninguna relación con la Certificadora Raíz que crearemos más adelante.  

- Edite el archivo /opt/ejbca/conf/web.properties, asegurese de tomar nota las credenciales del Usurio Super Admin:  superadmin.cn, superadmin.dn, superadmin.password.

- Edite el archivo /opt/ejbca/conf/web.properties, asegurese de tomar nota del nombre de dominio y las credenciales de configuración de HTTPS:  httpsserver.password, httpsserver.dn, httpsserver.hostname, java.trustpassword.

- Ingrese a la carpeta '/opt/scripts' y edite el archivo conf-jboss05.cli, asegúrese de usar los valores del paso anterior. 

- Ingrese a la carpeta '/opt/scripts', abra el archivo comandos-jboss.txt. Ejecute estos comandos uno a uno, debe asegurarse de que JBoss procesa cada comando con éxito uno a uno. Al final asegúrese de copiar e instalar el certificado de superadmin en la maquina que desee. 

- La interfaz publica estará disponible en http://[ip servidor]:8080/ejbca. 

- Para las maquinas que tengan instalado el certificado de 'superadmin', la página de administración estará disponible en https://[ip servidor]:8443/ejbca/adminweb/. 

## Perfiles de Certificados

Estos perfiles define las características técnicas de los certificados. Ademas de los perfiles que instala por defecto EJBCA, el archivo perfiles-cert.zip contiene perfiles de certificados que pueden ser usados como referencia.  Para usarlos desde la página de Administración, seleccione 'CA Functions', 'Certificate Profiles','Seleccionar Archivo', 'Import from Zip file'. Una vez importados los certificados, use la opción 'Certificate Authorities' para crear una CA Raíz y dos subordinadas como se muestra en el siguiente diagrama.

 ```
          CA Raíz
     ------ | --------
     |               |

SubCA Personas     SubCA Servicios
```

Finalmente revise los perfiles que importados, asegures que usan las CA que acaba de crear y haga los ajustes que considere necesarios.
 

## Perfiles de Entidades

Estos perfiles definen el contenido de certificados a usuarios o entidades finales. El archivo perfiles-enti.zip contiene perfiles de entidades que pueden ser usados como referencia.  Para usarlos desde la página de Administración, seleccione 'RA Functions', 'End Entity Profiles', 'Seleccionar Archivo','Import from Zip file'. 

Finalmente, revise los perfiles importados, asegures que usan los Perfiles de Certificados instalados en el paso anterior y haga los ajustes que considere necesarios. Puede agregar usuarios desde la opción 'Add End Entity'. Cada entidad es un nuevo usuario que podrá ingresar desde la web pública http://localhost:8080/ejbca y obtener su certificado. 

### Configuración de Servicio OCSP

El servicio OCSP permite que un usuario o aplicación valide el estado (revocado, activo, expirado, etc.) de un certificado ante la Autoridad Certificadora correspondiente en tiempo real. 

Esta instalación utiliza EJBCA como Autoridad Certificadora y Autoridad de Validación OCSP. Es posible configurar EJBCA para que actúe como Autoridad de Validación dedicada y ofrecer únicamente el servicio OCSP. A continuación se describen los pasos para agregar y configurar el servicio OCSP.

1. Certificado OCSP: Cada consulta OCSP recibe una respuesta firmada electrónicamente, por esto necesitamos contar con un certificado para firmar consultas OCSP (Extended key usage = OCSP Signer). Agregaremos una nueva entidad usando el perfil 'validacion-ocsp', vinculada a la CA 'SubCA Servicios'. Este entidad será usada para generar el certificado que firma respuestas OCSP, antes de generarlo desde la interfaz pública complete los siguientes pasos: 

2. Almacén de llaves: Crearemos un almacén (Crypto Token) para guardar las llaves que usará el servicio OCSP. Desde el menú principal seleccione:

'CA Functions' -> 'Crypto Tokens' -> 'Create New' 

Asigne un nombre, márquelo como activo y genere un nuevo par de llaves.

3. Vinculación de llaves: En este paso asociaremos el almacén y llaves del paso anterior con un nuevo servicio OCSP, elija:  
'System Functions' -> 'Internal Key Bindings' -> OcspKeyBindings -> 'Create new'

Asígnele un nombre y seleccione el Crypto Token creado en el paso anterior. 

4. Crear Petición CSR: En este paso crearemos una petición de firma (CSR) para utilizar la entidad creada en el paso 1. Desde la lista de OcspKeyBindings seleccione el elemento creado en el paso anterior y desde la columna 'Action' seleccione 'CSR'. Luego desde la página pública de EJBCA (http://localhost:8080/ejbca) seleccione 'Create Certificate from CSR', use las credenciales de la entidad creada en el paso 1 y suba el archivo CSR.

5. Activar el servicio OCSP: Desde 'Internal Key Bindings' -> 'OcspKeyBindings'  seleccione el elemento creado en el paso 3 y desde la columna 'Action' seleccione 'Update'. El sistema encontrará el certificado recién generado usando las llaves que ya tiene nuestro Crypto Token. Finalmente seleccione el botón "Enable" para dejar activo el servicio OCSP.

Para probar el servicio puede usar OpenSSL y los certificados de la autoridad certificadora:

```
openssl ocsp -req_text -issuer subCA.pem -CAfile CARaiz.pem -cert entidad.pem  -url http://localhost:8080/ejbca/publicweb/status/ocsp  
```

### URL de Consulta OCSP
A continuación crearemos un URL de consulta OCSP más amigable. Para esto usaremos NGINX como proxy inverso.
```
apt-get install nginx-light
```
Editar la configuración dentro de  /etc/nginx/sites-enabled/default, y agregar el siguiente bloque:
```
       location /ocsp {
          proxy_pass http://localhost:8080/ejbca/publicweb/status/ocsp;
           proxy_read_timeout 30s;
        }
```
Después de reiniciar el servicio de NGINX, podremos consultar el servicio OCSP usando el nuevo URL:
```
openssl ocsp -req_text -issuer subCA.pem -CAfile CARaiz.pem -cert entidad.pem  -url http://localhost/ocsp  
```

## Servicio de Sellado de Tiempo TSA

Los mismos creadores de EJBCA ofrecen un servidor de firma de alto desempeño que incluye el servicio de sellado de tiempo, las instrucciones de instalación están disponibles en [este repositorio](https://github.com/egobsv/ServidorDeFirma). 


## Licencia

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  
