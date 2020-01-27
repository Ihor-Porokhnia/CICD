#!/bin/bash
export NAME=${Name}
sudo apt-get install software-properties-common
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.serverion.com/mariadbrepo/10.4/ubuntu bionic main'
sudo apt -y update
sudo apt -y install nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
sudo apt -y install default-jdk
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
sudo apt -y install unzip wget
cd /tmp
wget http://apache.ip-connect.vn.ua/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz
tar -xzvf apache-tomcat-9.0.30.tar.gz
sudo mkdir -p /opt/tomcat
sudo mv apache-tomcat-9.0.30/ /opt/tomcat/
sudo ln -s /opt/tomcat/apache-tomcat-9.0.30 /opt/tomcat/latest
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
sudo cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

EOF
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password dclxvi'
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password dclxvi'
sudo apt install -y mariadb-server
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf


mysql -uroot -pdclxvi -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'dclxvi' WITH GRANT OPTION;CREATE USER 'remmie' IDENTIFIED BY 'nemA_666';GRANT ALL PRIVILEGES ON *.* TO 'remmie'@'%' IDENTIFIED BY 'nemA_666';FLUSH PRIVILEGES;"
sudo mysql -uroot -pdclxvi -e "CREATE DATABASE SimpleDatabase;"
sudo mysql -uroot -pdclxvi -e "CREATE TABLE NAMES(ID INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL, NAME TEXT NOT NULL);"

sudo service mysql restart
curl -s -X POST  https://api.telegram.org/bot885165924:AAEJaALHk3xsudGlv4ETlU_CJgoj9VUdxtk/sendMessage -d chat_id="-393518449" -d text="I'm ready"
