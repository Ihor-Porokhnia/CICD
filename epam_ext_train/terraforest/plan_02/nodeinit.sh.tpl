#!/bin/bash
export NAME=Node${number}
export NODE_INDEX=${number}
curl -s -X POST  https://api.telegram.org/bot885165924:AAHOfTezrjpHhwsTAh7kjRxRGV5_4hyF-fM/sendMessage -d chat_id="-393518449" -d text="$NAME is ready"
