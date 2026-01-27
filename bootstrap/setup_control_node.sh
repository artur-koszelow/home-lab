#!/usr/bin/bash

apt update

cd "/home/$SUDO_USER/home-lab-security-automation"

apt install -y python3-venv pip

python3 -m venv venv
source venv/bin/activate


