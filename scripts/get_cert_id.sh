#!/bin/sh

API_KEY=$1

curl -s -X GET "https://api.us-east-1.mbedcloud.com/v3/trusted-certificates" -H "accept: application/json" -H "Authorization: Bearer ${API_KEY}" -H "content-type: application/json" | jq '.data[] | select(.name=="EdgeXCert") | .id'
