#!/bin/bash
# Marcelo Eduardo Redoschi
# January 2024

echo "--------------------------------------------------"
echo "Building ruby container image (3.0.6 rvm)         " 
sudo docker build . -f containerization/dockerfiles/Dockerfile-ubuntu-rvm-ruby-3_0_6 -t ubuntu-rvm-ruby-3_0_6 --progress=plain
echo "--------------------------------------------------"
