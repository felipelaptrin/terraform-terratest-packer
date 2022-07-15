#!/bin/bash
sleep 30

sudo apt-get update
sudo apt-get install pip -y
sudo apt-get install zip -y
sudo apt-get install python3.10-venv -y

sudo unzip /tmp/static_webapp.zip -d /home/ubuntu

cd /home/ubuntu
python3 -m venv venv
source venv/bin/activate
pip install -r static_webapp/requirements.txt

sudo mv /tmp/static.service /etc/systemd/system/static.service
sudo systemctl enable static.service
sudo systemctl start static.service