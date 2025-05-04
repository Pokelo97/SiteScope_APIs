#!/bin/bash
HOSTNAME=$Delete_API
USERNAME=$1
BASE_DN=$2
BASIC_AUTH=$3


# 🧩 Define templates and groups based on BASE_DN type
if [ "$BASE_DN" == "OU=SERVICES,O=AUTH" ]; then
  groups=(
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20Locked%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20Expiry%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20About%20to%20Expire%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP%20Password%20age%20OU%20Service%20Dashboard"
  )
  
elif [ "$BASE_DN" == "OU=USERS,O=AUTH" ]; then
  groups=(
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20Locked%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20Expiry%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS%20Service%20Account%20Password%20About%20to%20Expire%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20EAS%20User%20Monitoring%20Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP%20Password%20age%20OU%20Users%20Dashboard"
  )
  
elif [ "$BASE_DN" == "OU=SERVICES,O=IAM" ]; then
  groups=(
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20Locked%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20Expire%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20About%20to%20Expire%20Notification_sis_path_delimiter_OU%20Services"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP%20Password%20age%20OU%20Service%20Dashboard"
  )
  

elif [ "$BASE_DN" == "OU=USERS,O=IAM" ]; then
  groups=(
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20Locked%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20Expire%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV%20Service%20Account%20Password%20About%20to%20Expire%20Notification_sis_path_delimiter_OU%20Users"
    "X%20-%20IDV%20User%20Monitoring%20Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP%20Password%20age%20OU%20Users%20Dashboard"
  )
  
else
  echo "⚠️ Unknown BASE_DN type: $BASE_DN" >> sitescope.logs
  exit 1
fi
# 🚀 Loop over groups
for i in "${!groups[@]}"; do
  echo "🔄 Delete monitor: $USERNAME in ${groups[$i]}" >> sitescope.logs
  http_response=$(curl -s -k -X DELETE "$HOSTNAME?fullPathToGroup=${groups[$i]}_sis_path_delimiter_$USERNAME" \
    -H "Authorization: Basic $BASIC_AUTH" \
    -o response.txt -w "%{response_code}")

  if [ "$http_response" != "204" ]; then
    echo "$(date) ❌ Failed to Delete (HTTP $http_response)" >> sitescope.logs
    cat response.txt >> logs
  else
    echo "$(date) ✅ Successfully Deleted." >> sitescope.logs
  fi

  echo "-------------------------------" >> sitescope.logs
done
