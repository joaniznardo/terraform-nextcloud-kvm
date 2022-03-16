#!/bin/bash

sudo apt-get install apache2 php zip libapache2-mod-php php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip php-mysql php-bcmath php-gmp zip -y

wget https://download.nextcloud.com/server/releases/nextcloud-22.0.0.zip
unzip nextcloud-22.0.0.zip
sudo mv nextcloud /var/www/html/
sudo chown -R www-data:www-data /var/www/html/nextcloud

#cat <<EOF >/etc/apache2/sites-available/nextcloud.conf
## Alias /nextcloud "/var/www/html/nextcloud/"
##
##Options +FollowSymlinks
##
##SetEnv HOME /var/www/html/nextcloud
##SetEnv HTTP_HOME /var/www/html/nextcloud
## EOF
sudo tee /etc/apache2/sites-available/nextcloud.conf <<EOF
<VirtualHost *:80>
        DocumentRoot "/var/www/html/nextcloud"
        ServerName nextcloud.just4fun.org

        ErrorLog /var/log/apache2/nextcloud.error
        CustomLog /var/log/apache2/nextcloud.access combined

        <Directory /var/www/html/nextcloud/>
            Require all granted
            Options FollowSymlinks MultiViews
            AllowOverride All

           <IfModule mod_dav.c>
               Dav off
           </IfModule>

        SetEnv HOME /var/www/html/nextcloud
        SetEnv HTTP_HOME /var/www/html/nextcloud
        Satisfy Any

       </Directory>

</VirtualHost>
EOF

sudo tee /var/www/html/nextcloud/config/storage.config.php << EOF 
<?php
\$CONFIG = array (
  "objectstore" => array( 
      "class" => "OC\\Files\\ObjectStore\\S3",
      "arguments" => array(
        "bucket" => "nextcloud-001",
        "autocreate" => false,
        "key"    => "clau-access-minio",
        "secret" => "minio-secret",
        "hostname" => "10.0.100.46",
        "port" => 9000,
        "use_ssl" => false,
        "region" => "us-east-1",
        "use_path_style"=>true
      ),
    ),
  );
EOF
#============
# warning: harcoded values!!
#===========
sudo tee /var/www/html/nextcloud/config/autoconfig.php << EOF
<?php
\$AUTOCONFIG = array(
  "dbtype"        => "mysql",
  "dbname"        => "nextcloud",
  "dbuser"        => "nextcloud5",
  "dbpass"        => "6y33XHJJpSkt7JyU",
  "dbhost"        => "10.0.100.45:3306",
  "dbtableprefix" => "oc_",
  "adminlogin"    => "admin",
  "adminpass"     => "ocpo059ur1g4",
  "directory"     => "/var/www/html/nextcloud/data",
);
EOF
#============
sudo a2ensite nextcloud
sudo a2enmod rewrite headers env dir mime
sudo sed -i '/^memory_limit =/s/=.*/= 512M/' /etc/php/7.4/apache2/php.ini

sudo systemctl restart apache2
curl http://10.0.100.44/nextcloud/index.php
echo "all is done" > /tmp/final
