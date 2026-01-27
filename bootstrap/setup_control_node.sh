#!/usr/bin/bash

echo -e '\nEXECUTING: apt update\n'
sudo apt update

echo -e '\nEXECUTING: cd "/home/$USER/home-lab-security-automation"\n'
cd "/home/$USER/home-lab-security-automation"

echo -e '\nEXECUTING: sudo apt install -y python3-venv pip\n'
sudo apt install -y python3-venv pip

echo -e '\nEXECUTING: python3 -m venv venv\n'
python3 -m venv venv


