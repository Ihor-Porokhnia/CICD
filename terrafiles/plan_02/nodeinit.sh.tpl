#!/bin/bash
export NAME=Node${number}
export NODE_INDEX=${number}
sudo apt-get install software-properties-common
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'

sudo apt -y update
sudo apt -y install python3


export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password dclxvi'
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password dclxvi'
sudo apt install -y mariadb-server
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf


mysql -uroot -pdclxvi -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'dclxvi' WITH GRANT OPTION;CREATE USER 'remmie' IDENTIFIED BY 'nemA_666';GRANT ALL PRIVILEGES ON *.* TO 'remmie'@'%' IDENTIFIED BY 'nemA_666';FLUSH PRIVILEGES;"
sudo mysql -uroot -pdclxvi -e "CREATE DATABASE SimpleDatabase;"
sudo mysql -uroot -pdclxvi -e "CREATE TABLE SimpleDatabase.NAMES(ID INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL, NAME TEXT NOT NULL);"
sudo service mysql restart
sudo systemctl enable mariadb

sudo cat <<EOF > /etc/mysql/conf.d/galera.cnf
  [mysqld]
      max_connections=350
      log-bin=/var/log/mysql/mysql-bin
      log-bin-index=/var/log/mysql/mysql-bin.index
      binlog-format = 'ROW'
      default-storage-engine=innodb
      innodb_autoinc_lock_mode=2
      innodb_rollback_on_timeout=1
      innodb_lock_wait_timeout=600

      innodb_doublewrite=1
      innodb_support_xa = 0

      innodb_flush_log_at_trx_commit=0
      bind-address=0.0.0.0

      wsrep_provider=/usr/lib/galera/libgalera_smm.so
      wsrep_cluster_address="gcomm://172.31.0.10,172.31.0.11,172.31.0.12"
      wsrep_on=ON

      wsrep_cluster_name="cluster"

      wsrep_sst_method=rsync

      wsrep_node_address="172.31.0.1${number - 1}"
      wsrep_node_name="node${number}"

EOF
sudo service mysql restart




wget https://dl.influxdata.com/telegraf/releases/telegraf_1.13.2-1_amd64.deb
sudo dpkg -i telegraf_1.13.2-1_amd64.deb
sudo telegraf --input-filter cpu:mem:disk:diskio:kernel:system:nginx:tomcat:mysql --output-filter influxdb config > /etc/telegraf/telegraf.conf
sudo sed -i 's/# urls = \[\"http:\/\/127.0.0.1:8086\"\]/urls = \[\"http:\/\/innodb.bugoga.ga:8086\"\]/g' /etc/telegraf/telegraf.conf

apt install -y virtualenv
cd /opt && git clone https://github.com/ratibor78/srvstatus.git
cd /opt/srvstatus
virtualenv --python=python3 venv && source venv/bin/activate
pip install -r requirements.txt
chmod +x ./service.py
deactivate
sudo cat <<EOF > settings.ini
[SERVICES]
name = nginx.service tomcat.service mariadb.service
EOF


sudo cat <<EOF >> /etc/telegraf/telegraf.conf
[[inputs.exec]]

   commands = [
    "/opt/srvstatus/venv/bin/python /opt/srvstatus/service.py"
   ]

   timeout = "5s"
   name_override = "services_stats"
   data_format = "json"
   tag_keys = [
     "service"
   ]
EOF
systemctl start telegraf
systemctl enable telegraf
systemctl restart telegraf


curl -s -X POST  https://api.telegram.org/bot885165924:AAEJaALHk3xsudGlv4ETlU_CJgoj9VUdxtk/sendMessage -d chat_id="-393518449" -d text="$NAME is ready"
