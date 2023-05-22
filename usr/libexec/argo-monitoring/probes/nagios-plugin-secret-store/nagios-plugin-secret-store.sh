#!/bin/bash

# Default values for Vault endpoint
SERVICE_URL="UNKNOWN"
HEALTH_CHECK_API="v1/sys/health"

# Timeout value is given for compatibility
# The probe should finish within few seconds, so not real use

TIMEOUT=100


# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-u URL]

Nagios probe test for Secret Store service

Optional arguments:
        -h, --help, help                Display this help message and exit
        -u URL, --url URL               Vault endpoint (service URL in GOCDB)
        -t TIMEOUT, --timeout TIMEOUT   Global timeout for probe test
EOF
}

# Test Secret Store service
test_secret_store() {

HEALTH_CHECK_URL=$SERVICE_URL$HEALTH_CHECK_API

return_value=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null $HEALTH_CHECK_URL)
return_code=$?

# Printing debug info
# echo "HEALTH_CHECK_URL is $HEALTH_CHECK_URL"
# echo "Return code is  $return_code"
# echo "Return value is $return_value"

if (($return_code == 0)); then
    if [[ $return_value =~ ^"200" ]]; then
        echo "Checking $HEALTH_CHECK_URL. Status OK - unsealed and active. Return code 200"
        exit 0
    elif [[ $return_value =~ ^"429" ]]; then
        echo "Checking $HEALTH_CHECK_URL. Status OK - unsealed and standby. Return code 429"
        exit 0
    elif [[ $return_value =~ ^"503" ]]; then
        echo "Checking $HEALTH_CHECK_URL. Status WARNING - sealed. Return code 503"
        exit 1
    else
        echo "Checking $HEALTH_CHECK_URL. Status UNKNOWN - Server reachable but something is wrong. Return value : $return_value"
        exit 3
    fi
elif (($return_code == 7)); then
        echo "Checking $HEALTH_CHECK_URL. Status CRITICAL - Server unreachable. Return code : $return_code. Return value : $return_value"
        exit 2
elif (($return_code == 6)); then
        echo "Checking $HEALTH_CHECK_URL. Status CRITICAL - DNS error. Return code : $return_code. Return value : $return_value"
        exit 2
else
        echo "Checking $HEALTH_CHECK_URL. Status UNKNOWN - Return code : $return_code. Return value : $return_value"
        exit 3
fi

}


while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -u|--url)
    SERVICE_URL="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help|help)
    show_help
    exit 0
    ;;
    *)
    echo "Invalid argument: $key"
    exit 1
    ;;
esac
done

if [[ $SERVICE_URL == "UNKNOWN" || $SERVICE_URL == "" ]]; then
    echo "Error: Service endpoint is required."
    exit 1
fi 

test_secret_store

