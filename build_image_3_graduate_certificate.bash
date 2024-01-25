#!/bin/bash
# Marcelo Eduardo Redoschi
# January 2024
echo "---------------------------------------------------------------"
echo "Building application container image (graduate certificate)    " 
echo "---------------------------------------------------------------"

sudo docker build . -f containerization/dockerfiles/Dockerfile-graduate-certificate -t graduate-certificate --progress=plain 

echo "***************************************************"
echo ""
