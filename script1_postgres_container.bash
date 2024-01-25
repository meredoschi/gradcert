#!/bin/bash
# Marcelo Eduardo Redoschi
# January 2024
echo "Build the postgres image"
bash build_image_1_postgres.bash 
echo "Run the container"
sudo docker run --env-file containerization/postgres_container_env -it alpine-postgres-15_5