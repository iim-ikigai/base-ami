#!/bin/bash
apt-get update
apt install -y bash python3 python3-pip
python3 -m pip install --upgrade pip wheel setuptools
python3 -m pip install --upgrade --user ansible

