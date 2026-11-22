#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y apache2 php libapache2-mod-php php-mysql git

rm -rf /var/www/html/*
git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/app
cp -r /tmp/app/src/* /var/www/html/
rm -rf /tmp/app

sed -i "s/localhost/192.168.56.20/g" /var/www/html/config.php
sed -i "s/database_name_here/lamp_db/g" /var/www/html/config.php
sed -i "s/username_here/javier-lamp/g" /var/www/html/config.php
sed -i "s/password_here/1234/g" /var/www/html/config.php

chown -R www-data:www-data /var/www/html/
systemctl restart apache2
systemctl enable apache2