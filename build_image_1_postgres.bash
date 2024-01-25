!#/bin/bash
# Marcelo Eduardo Redoschi
# January 2024
echo "--------------------------------------------------"
echo "Building database container image (Postgresql 15_5)    " 
echo "--------------------------------------------------"

sudo docker build . -f containerization/dockerfiles/Dockerfile-alpine-postgres-15_5 -t alpine-postgres-15_5 --progress=plain 
