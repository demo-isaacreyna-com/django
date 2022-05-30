#!/bin/bash
set -e
export POSTGRES_HOST=''
export POSTGRES_DB=''
export POSTGRES_USER=''
export POSTGRES_PASSWORD=''
export PORT=''

errors=()

if [[ -z "${POSTGRES_HOST}" ]]; then
    errors+=( "Error: POSTGRES_HOST is not set" )
fi

if [[ -z "${POSTGRES_DB}" ]]; then
    errors+=( "Error: POSTGRES_DB is not set" )
fi

if [[ -z "${POSTGRES_USER}" ]]; then
    errors+=( "Error: POSTGRES_USER is not set" )
fi

if [[ -z "${POSTGRES_PASSWORD}" ]]; then
    errors+=( "Error: POSTGRES_PASSWORD is not set" )
fi

if [[ -z "${PORT}" ]]; then
    errors+=( "Error: PORT is not set" )
fi

if [[ "${#errors[@]}" ]]; then
    for index in "${!errors[@]}"; do
        echo "${errors[$index]}"
    done
    exit 1
fi


#python manage.py runserver 8000