#!/usr/bin/bash

apt update

cd ~/home-lab-security-automtion

apt install -y python3-venv pip

python3 -m venv venv
source venv/bin/activate


