#!/bin/bash
set -e
export POSTGRES_HOST='localhost'
export POSTGRES_DB='demo'
export POSTGRES_USER='admin_sa'
export POSTGRES_PASSWORD='admin8520'
export PORT=5432

python manage.py runserver 8000