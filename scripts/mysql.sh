#!/bin/bash
echo "antic"
#==========
echo "estic a mysql"
export DEBIAN_FRONTEND=noninteractive
export ROOTPWD="JmPSJJaJJQ89WyVM"
export NEXTCLOUDPWD="6y33XHJJpSkt7JyU"
export NEXTCLOUDDB="nextcloud"
export NEXTCLOUDUSER="nextcloud5"

##sudo debconf-set-selections <<< "mysql-server-8.0 mysql-server/root_password password $ROOTPWD"
##sudo debconf-set-selections <<< "mysql-server-8.0 mysql-server/root_password_again password $ROOTPWD" 

echo "mysql-server-8.0 mysql-server/root_password password $ROOTPWD" | sudo tee debconf-set-selections 
echo "mysql-server-8.0 mysql-server/root_password_again password $ROOTPWD" | sudo tee debconf-set-selections  

sudo apt-get install mysql-server -y


sudo sed -i '/addre/s|127.0.0.1|0.0.0.0|' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql
sudo systemctl status mysql

#tee client-data <<EOF
cat <<EOF > /tmp/client-data
[client]
user=root
password=$ROOTPWD
EOF

## mysql  --defaults-extra-file=client-data -h 10.0.100.45

#mysqladmin -u root password >mPSJ_a>]Q89WyVM

#sudo mysql -u root -p
###          >mPSJ_a>]Q89WyVM
# sudo -u root <<EOF
sudo mysql --defaults-extra-file=/tmp/client-data <<EOF
CREATE DATABASE $NEXTCLOUDDB;
CREATE USER '$NEXTCLOUDUSER'@'%' IDENTIFIED BY '$NEXTCLOUDPWD';
GRANT ALL PRIVILEGES ON $NEXTCLOUDDB.* TO '$NEXTCLOUDUSER'@'%';
FLUSH PRIVILEGES;
exit
EOF

# validaci
cat <<EOF > client-data
[client]
user=$NEXTCLOUDUSER
password=$NEXTCLOUDPWD
host=10.0.100.45
EOF

#==========
