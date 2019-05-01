#!/bin/sh

#
# our API Key
#
API_KEY=$1

#
# Must match with name explicit in ./get_cert_id.sh...
#
NAME="EdgeXCert"
DESC="EdgeXCert"

ID=`./get_cert_id.sh ${API_KEY} | sed 's/"//g'`
if [ "X" = "${ID}X" ]; then
     #echo "Creating Developer Certificate..."
     ID=`./create_dev_cert.sh ${API_KEY} ${NAME} ${DESC} | sed 's/"//g'`
fi
#echo "Certificate ID:" ${ID}
#echo "Getting Developer C-File..."
./get_dev_cert.sh ${API_KEY} ${ID}
