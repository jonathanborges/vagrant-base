#!/usr/bin/env bash

echoe() {
  YELLOW='\033[31;4m'
  NC='\033[0m'
  echo -e "${YELLOW}$1${NC}"
}

echoe "Updating"
apt-get update

echoe "Installing Git"
apt-get install -y git

echoe "Installing and setting up Mariadb"

apt-get install -y software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.ufscar.br/mariadb/repo/10.1/ubuntu xenial main'

export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< "mariadb-server-10.1 mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password_again password secret"

apt-get update && apt-get install -y mariadb-server

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
/etc/init.d/mysql restart

echoe "Installing NGINX"

apt-get install -y nginx

echoe "Installing PHP"

apt-get install php7.0 php7.0-fpm php7.0-xml php7.0-pdo php7.0-mbstring php7.0-gd
