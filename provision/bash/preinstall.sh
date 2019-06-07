#!/usr/bin/env bash
echo -e "\n[*] Fix name server.\n"
echo "nameserver 8.8.8.8" > /etc/resolv.conf
sudo apt-get update
echo -e "\n[*] Install python-pip, python-dev, git, curl, wget, nano.\n"
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev python-pip git curl wget nano;
sudo pip install --upgrade setuptools;
sudo curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py
echo -e "\n[*] Install markupsafe.\n"
sudo pip install markupsafe;
echo -e "\n[*] Install ansible.\n"
sudo pip install ansible;
echo -e "\n[*] Autoremove unused software .\n"
sudo apt-get autoremove -y;
echo -e "\n[x] Done.\n"