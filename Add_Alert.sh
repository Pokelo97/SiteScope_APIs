#!/bin/bash
Config_API=$Config_API
Alert_API=$Alert_API
USERNAME=$1
PATH=$2
BASIC_AUTH=$3
mail=$4
i=$5

if [ $i == 0 ]; then
  MAIL_NAME="EAS Service Account Password Locked Notification"
elif [ $i == 1 ]; then
  MAIL_NAME="EAS Service Account Password Expiry Notification"
elif [ $i == 2 ]; then
  MAIL_NAME="EAS Service Account Password About to Expire Notification"
else
  exit 1
fi

data=$Config_API"?isFullConfig=true&fullPathsToGroups="$PATH"_sis_path_delimiter_"$USERNAME
data=${data// /%20}

http_response=$(/usr/bin/curl -s -k -X GET "$data" -H "Authorization: Basic $BASIC_AUTH")

echo $http_response > response.json
PATH=$PATH"_sis_path_delimiter_"$USERNAME
entityID=$(/usr/bin/jq -r --arg key "$PATH" '.[$key].entitySnapshot_properties._id' response.json)
./Alert_Properties.sh $entityID "$MAIL_NAME" $mail

http_response=$(/usr/bin/curl -s -k -X POST "$Alert_API?entityID=$entityID" \
    -H "Authorization: Basic $BASIC_AUTH" \
    -H 'Content-Type: application/json' \
    -H "Accept-Encoding: gzip,deflate" \
    -H "MIME-Version: 1.0" \
    -o response.txt -w "%{response_code}" \
    -d @email_Properties.json)

if [ "$http_response" != "201" ]; then
  echo $(date) "❌ Failed To Create Alert (HTTP $http_response)" >> sitescope.logs
else
  echo $(date) "✅ Alert Created Successfully!" >> sitescope.logs
fi
