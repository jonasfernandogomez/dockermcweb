FROM node:10.20.0-buster as builder

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update 
RUN apt-get -y install git

#Copy Source
WORKDIR /app
#COPY . /app

#WORKDIR /app/src/widget
RUN npm install
#RUN npm run build

WORKDIR /app

RUN npm install
#RUN npm run copy-libs-local
#RUN npm run copy-libs-awesome
#RUN npm run copy-libs
#RUN npm run build

FROM debian:stable-slim

RUN apt-get -y update 
RUN apt install -y apache2

RUN sed -i 's/None/All/g' /etc/apache2/apache2.conf

WORKDIR /var/www/html
VOLUME /var/www/html
EXPOSE 80

#COPY --from=builder --chown=www-data /app/public/ /var/www/html
COPY ./htaccess /var/www/html/.htaccess
COPY ./index.html /var/www/html/
RUN a2enmod rewrite
RUN service apache2 reload
CMD bash -c "/usr/sbin/apache2ctl -D FOREGROUND"
