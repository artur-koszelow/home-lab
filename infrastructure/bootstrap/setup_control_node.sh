#!/usr/bin/bash

echo -e '\nEXECUTING: apt update\n'
sudo apt update

echo -e '\nEXECUTING: cd "/home/$USER/home-lab"\n'
cd "/home/$USER/home-lab"

echo -e '\nEXECUTING: sudo apt install -y python3-venv pip\n'
sudo apt install -y python3-venv pip

echo -e '\nEXECUTING: python3 -m venv venv\n'
python3 -m venv venv

echo -e '\nEXECUTING:source venv/bin/activate\n'
source venv/bin/activate

echo -e '\nEXECUTING: pip install -r requirements.txt\n'
pip install -r requirements.txt 
