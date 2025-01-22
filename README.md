# Docker con Apache, PHP y SSL

Proyecto para la construcción de un contenedor de Docker con APACHE, PHP y SSL con el objetivo de servir un sitio web sencillo y con soporte HTTPS.

## 👤 Autor

- [@PedroG-Dev](https://github.com/PedroG-Dev)

## 🚀 Instalación y uso

Antes de nada dentro de la carpeta web1 habrá que crear la carpeta tls y dentro de esta las carpetas certs y private donde irán los certificados y las claves

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/PedroG-Dev/Docker-php-apache.git
cd nombre-del-repositorio
```

### 2️⃣ Construir la imagen Docker

En el directorio del proyecto ejecuta:

```bash
sudo docker build -t nombre-imagen .
```

### 3️⃣ Ejecutar el contenedor

Lanza el contenedor

```bash
sudo docker run -d -p 80:80 -p 443:443 --name nombre-contenedor nombre-imagen
```

### 🌐 Acceso al sitio web

- HTTP: http://web1.com:80
- HTTPS: https://web1.com:443

En este caso con VirtualHost y con /etc/hosts/ hemos usado un nombre de dominio en lugar de utilizar localhost

### 📂 Estructura del proyecto

- Dockerfile: Define cómo se construye el contenedor.

```bash
#Usar la imagen base
FROM php:apache

#Actualizar repositorios e instalar herramientas necesarias
RUN apt-get update && apt-get install -y vim nano net-tools openssl

#Copiar la web que queremos publicar
COPY web1/public_html /var/www/html/web1/public_html

#Add VirtualHost
COPY web1/web1.com.conf /etc/apache2/sites-available

#Copiamos los certificados al contenedor
COPY web1/tls/certs/ca_web1.crt /etc/ssl/certs/
COPY web1/tls/private/ca_web1.key /etc/ssl/private
COPY web1/tls/private/ca_web1.csr /etc/ssl/private

#Habilitamos SSL en Apache
RUN a2enmod ssl

#Activar el VirtualHost
RUN a2ensite web1.com.conf

#Sobreescritura
RUN a2enmod rewrite

#Add dominio e IP al host
RUN echo "127.0.0.1 web1.com" >> /etc/hosts

#Exponer los puertos
EXPOSE 80 443
```

- web1/public_html: Contiene los archivos de la página web que se servirán.
- web1/tls: Para incluir los certificados SSL auto-firmados para HTTPS.
- Archivo web1.com.conf para configurar el VirtualHost

```bash
<VirtualHost *:80 *:443>
    ServerAdmin pedromvgit@gmail.com
    ServerName web1.com
    DocumentRoot /var/www/html/web1/public_html

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/ca_web1.crt
    SSLCertificateKeyFile /etc/ssl/private/ca_web1.key


</VirtualHost>
```

- Tambien un .gitignore para no incluir los certificados y las claves
