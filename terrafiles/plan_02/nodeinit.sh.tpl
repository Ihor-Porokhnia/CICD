#!/bin/bash
sudo apt -y update
sudo apt -y install nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
