#!/bin/bash
# Marcelo Eduardo Redoschi - January 2024
export GRADUATE_CERTIFICATE_DATABASE_USER=gradcert
export GRADUATE_CERTIFICATE_DATABASE_PREFIX=gradcert_
export GRADUATE_CERTIFICATE_DATABASE_PASSWORD=sample-db-password
export GRADUATE_CERTIFICATE_DATABASE_HOST=172.17.0.2
rvm use ruby-3.0.6 
RAILS_ENV=development rake db:reset
rails s -b 0.0.0.0 -p 3000