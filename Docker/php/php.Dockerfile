FROM php:7.0-apache
RUN apt update -y && apt upgrade -y
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli
ADD chitale_herdman  /var/www/html
COPY  docker.conf  /etc/apache2/conf-available
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && a2enmod rewrite && service apache2 restart
