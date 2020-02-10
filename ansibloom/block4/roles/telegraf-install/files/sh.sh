#!/bin/bash
git clone https://github.com/ratibor78/srvstatus.git
cp -r srvstatus /opt
cd /opt/srvstatus
virtualenv --python=python3 venv
source venv/bin/activate
pip install -r requirements.txt
chmod +x ./service.py
deactivate

