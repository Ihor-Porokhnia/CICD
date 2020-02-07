#!/bin/bash
export NAME=Node${number}
export NODE_INDEX=${number}
#sudo apt-get install software-properties-common
#sudo apt -y update
#sudo apt -y install python3

curl -s -X POST  https://api.telegram.org/bot885165924:AAEJaALHk3xsudGlv4ETlU_CJgoj9VUdxtk/sendMessage -d chat_id="-393518449" -d text="$NAME is ready"
