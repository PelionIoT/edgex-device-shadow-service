#!/bin/sh

API_KEY=$1
CERT_NAME=$2
CERT_DESC=$3

curl -s -X POST "https://api.us-east-1.mbedcloud.com/v3/developer-certificates" -H "accept: application/json" -H "Authorization: Bearer ${API_KEY}" -H "content-type: application/json" -d "{ "\"name\"": "\"${CERT_NAME}\"", "\"description\"": "\"${CERT_DESC}\""}" | jq .id
