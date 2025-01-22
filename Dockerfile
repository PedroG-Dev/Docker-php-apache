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

