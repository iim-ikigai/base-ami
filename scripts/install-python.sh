#!/bin/bash
sudo apt-get update
sudo apt install -y bash python3 python3-pip
python3 -m pip install --upgrade pip wheel setuptools
python3 -m pip install --upgrade --user ansible
export PATH=/home/ubuntu/.local/bin:$PATH
