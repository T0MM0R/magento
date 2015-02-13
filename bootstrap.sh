#!/bin/sh

##Disable interactive shell
export DEBIAN_FRONTEND=noninteractive;

##Fetch updated software packages
apt-get update > /dev/null;

##Install nginx and php
apt-get install -qy nginx php5 php5-fpm php-pear php5-common php5-mcrypt php5-mysql php5-cli libcurl3 php5-curl php5-gd php5-memcache php5-memcached memcached;

##TODO:  nginx turn sendfile off
sed -i 's/sendfile on;/sendfile off;/' /etc/nginx/nginx.conf;

cp /vagrant/magento-host /etc/nginx/sites-available/magento-host;
ln -s /etc/nginx/sites-available/magento-host /etc/nginx/sites-enabled/magento-host;
/etc/init.d/nginx restart;

##Install mysql
apt-get install -y mysql-server; 

##Set mysql password
mysqladmin -u root -h localhost password 'root';

echo "creating db";
mysql -u root -proot -e "create database magento";
mysql -u root -proot magento < /vagrant/magento_sample_data_for_1.9.1.0.sql;
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON magento.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;";

