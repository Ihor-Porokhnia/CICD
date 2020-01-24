#!/bin/bash
sudo apt update
sudo apt install nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
