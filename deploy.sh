#!/bin/bash
set -e

main() {
    declare -A local vars=(
        ['IMAGE']="${1}"
        ['TAG']="${2}"
        ['CONTAINER_NAME']="${3}"
        ['EXTERNAL_PORT']="${4}"
        ['INTERNAL_PORT']="${5}"
        ['POSTGRES_USER']="${6}"
        ['POSTGRES_PASSWORD']="${7}"
    )

    validate
    deployWithDockerRun
}

deployWithDockerRun() {
    local outputStop=$(docker stop "${vars['CONTAINER_NAME']}")
    local outputRemove=$(docker rm "${vars['CONTAINER_NAME']}")
    local outputDockerImageRemove=$(docker image rm "${vars['IMAGE']}":"${vars['TAG']}")
    docker run -d \
        --name "${vars['CONTAINER_NAME']}" \
        -p "${vars['EXTERNAL_PORT']}":"${vars['INTERNAL_PORT']}" \
        -t "${vars['IMAGE']}":"${vars['TAG']}" \
        -e "POSTGRES_HOST=postgres" \
        -e "POSTGRES_USER=${POSTGRES_USER}" \
        -e "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" \
        -e "POSTGRES_DB=demo"
}

validate() {
    local MISSING_ARGUMENTS=()

    for key in "${!vars[@]}"; do
        if [ -z "${vars[${key}]}" ];then
            MISSING_ARGUMENTS+=("${key}")
        fi
    done

    if [ "${#MISSING_ARGUMENTS[@]}" != "0" ];then
        printf "Error! Missing arguments for"
        printf -v joined ' %s,' "${MISSING_ARGUMENTS[@]}"
        echo "${joined%,}"
        exit 1
    fi
}

createENV() {
    echo "IMAGE=${vars['IMAGE']}" > .env
    echo "TAG=${vars['TAG']}" >> .env
    echo "CONTAINER_NAME=${vars['CONTAINER_NAME']}" >> .env
    echo "EXTERNAL_PORT=${vars['EXTERNAL_PORT']}" >> .env
    echo "INTERNAL_PORT=${vars['INTERNAL_PORT']}" >> .env
}

deployWithDockerCompose() {
    createENV
    docker-compose down
    docker-compose up -d
}

main "$@"