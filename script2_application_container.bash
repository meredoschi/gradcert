#!/bin/bash
# Marcelo Eduardo Redoschi
# January 2024
echo "Build the ruby 3.0.6 image"
bash build_image_2_ruby.bash
echo "Build the application image"
bash build_image_3_graduate_certificate.bash
sudo docker run -t graduate-certificate