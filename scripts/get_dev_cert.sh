#!/bin/sh

API_KEY=$1
CERT_ID=$2

curl -s -X GET "https://api.us-east-1.mbedcloud.com/v3/developer-certificates/${CERT_ID}" -H "accept: application/json" -H "Authorization: Bearer ${API_KEY}" -H "content-type: application/json" | jq .security_file_content
