#!/bin/bash
export NAME=Node${number}
export NODE_INDEX=${number}
sudo apt-get install software-properties-common
#sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'


sudo apt -y update
sudo apt -y install python3
#
#wget https://dl.influxdata.com/telegraf/releases/telegraf_1.13.2-1_amd64.deb
#sudo dpkg -i telegraf_1.13.2-1_amd64.deb
#sudo telegraf --input-filter cpu:mem:disk:diskio:kernel:system:nginx:tomcat:mysql --output-filter influxdb config > /etc/telegraf/telegraf.conf
#sudo sed -i 's/# urls = \[\"http:\/\/127.0.0.1:8086\"\]/urls = \[\"http:\/\/innodb.bugoga.ga:8086\"\]/g' /etc/telegraf/telegraf.conf

#apt install -y virtualenv
#cd /opt && git clone https://github.com/ratibor78/srvstatus.git
#cd /opt/srvstatus
#virtualenv --python=python3 venv && source venv/bin/activate
#pip install -r requirements.txt
#chmod +x ./service.py
#deactivate
#sudo cat <<EOF > settings.ini
#[SERVICES]
#name = nginx.service tomcat.service mariadb.service
#EOF
#
#
#sudo cat <<EOF >> /etc/telegraf/telegraf.conf
#[[inputs.exec]]
#
#   commands = [
#    "/opt/srvstatus/venv/bin/python /opt/srvstatus/service.py"
#   ]
#
#   timeout = "5s"
#   name_override = "services_stats"
#   data_format = "json"
#   tag_keys = [
#     "service"
#   ]
#EOF



curl -s -X POST  https://api.telegram.org/bot885165924:AAEJaALHk3xsudGlv4ETlU_CJgoj9VUdxtk/sendMessage -d chat_id="-393518449" -d text="$NAME is ready"
