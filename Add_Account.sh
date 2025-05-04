#!/bin/bash
HOSTNAME=$Deployment_API
USERNAME=$1
APPLICATION=$2
DOMAIN=$3
OWNER=$4
BASE_DN=$5
BASIC_AUTH=$6
MAIL=$7
k=0

# 🧩 Define templates and groups based on BASE_DN type
if [ "$BASE_DN" == "OU=SERVICES,O=AUTH" ]; then
  templates=(
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Locked Notification_sis_path_delimiter_LDAP Password age ou=services Locked Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Expiry Notification_sis_path_delimiter_LDAP Password age ou=services Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password About to Expire Notification_sis_path_delimiter_LDAP Password age ou=services Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age ou=services Dashboard_sis_path_delimiter_Username_sis_path_delimiter_Username"
  )

  groups=(
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Locked Notification_sis_path_delimiter_OU Services"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Expiry Notification_sis_path_delimiter_OU Services"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password About to Expire Notification_sis_path_delimiter_OU Services"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age OU Service Dashboard"
  )
  

elif [ "$BASE_DN" == "OU=USERS,O=AUTH" ]; then
  templates=(
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Locked Notification_sis_path_delimiter_LDAP Password age ou=users Locked Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Expiry Notification_sis_path_delimiter_LDAP Password age ou=users Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password About to Expire Notification_sis_path_delimiter_LDAP Password age ou=users Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "EAS Dashboard and Alerting_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age ou=users Dashboard_sis_path_delimiter_Username_sis_path_delimiter_Username"
  )

  groups=(
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Locked Notification_sis_path_delimiter_OU Users"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password Expiry Notification_sis_path_delimiter_OU Users"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_EAS Service Account Password About to Expire Notification_sis_path_delimiter_OU Users"
    "X - EAS User Monitoring Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age OU Users Dashboard"
  )
  

elif [ "$BASE_DN" == "OU=SERVICES,O=IAM" ]; then
  templates=(
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Locked Notification_sis_path_delimiter_LDAP Password age ou=services Locked Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Expiry Notification_sis_path_delimiter_LDAP Password age ou=services Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password About to Expire Notification_sis_path_delimiter_LDAP Password age ou=services Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Dashboard_sis_path_delimiter_IDV Password age ou=services Dashboard_sis_path_delimiter_Username_sis_path_delimiter_Username"
  )

  groups=(
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Locked Notification_sis_path_delimiter_OU Services"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Expire Notification_sis_path_delimiter_OU Services"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password About to Expire Notification_sis_path_delimiter_OU Services"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age OU Service Dashboard"
  )

elif [ "$BASE_DN" == "OU=USERS,O=IAM" ]; then
  templates=(
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Locked Notification_sis_path_delimiter_LDAP Password age ou=users Locked Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Expiry Notification_sis_path_delimiter_LDAP Password age ou=users Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password About to Expire Notification_sis_path_delimiter_LDAP Password age ou=users Alerting_sis_path_delimiter_Username_sis_path_delimiter_Username"
    "IDV Dashboard and Alerting_sis_path_delimiter_Dashboard_sis_path_delimiter_IDV Password age ou=users Dashboard_sis_path_delimiter_Username_sis_path_delimiter_Username"
  )

  groups=(
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Locked Notification_sis_path_delimiter_OU Users"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password Expire Notification_sis_path_delimiter_OU Users"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Alerting_sis_path_delimiter_IDV Service Account Password About to Expire Notification_sis_path_delimiter_OU Users"
    "X - IDV User Monitoring Creation_sis_path_delimiter_Dashboard_sis_path_delimiter_LDAP Password age OU Users Dashboard"
  )

else
  echo "$(date) ⚠️ Unknown BASE_DN type: $BASE_DN" >> sitescope.logs
  exit 1
fi

if echo $MAIL | /usr/bin/grep -Eq "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"; then
  # 🚀 Loop over templates and groups
  for i in "${!templates[@]}"; do
    echo "$(date) 🔄 Deploying template: ${templates[$i]}" >> sitescope.logs
    http_response=$(curl -s -k -X POST "$HOSTNAME" \
      -H "Authorization: Basic $BASIC_AUTH" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -H "Accept-Encoding: gzip,deflate" \
      -H "MIME-Version: 1.0" \
      -o response.txt -w "%{response_code}" \
      --data-urlencode "pathToTemplate=${templates[$i]}" \
      --data-urlencode "pathToTargetGroup=${groups[$i]}" \
      --data-urlencode "Username=$USERNAME" \
      --data-urlencode "Application=$APPLICATION" \
      --data-urlencode "Domain_Name=$DOMAIN" \
      --data-urlencode "Application_Owner=$OWNER")

    if [ "$http_response" != "204" ]; then
      echo "$(date) ❌ Deployment failed (HTTP $http_response)" >> sitescope.logs
      cat response.txt
      echo
    else
      echo "$(date) ✅ Deployment succeeded. $USERNAME added!" >> sitescope.logs
      # Create Alert 
      ./Add_Alert.sh $USERNAME "${groups[$i]}" $BASIC_AUTH $MAIL $k
    fi
    let k++
    echo "-------------------------------" >> sitescope.logs
  done
else
  echo "$(date) ❌ Email address is invalid " $MAIL  "Please fix the email address before deploying template for:" $USERNAME >> sitescope.logs
  echo  "$USERNAME,$DOMAIN,$MAIL,$OWNER" >> table.csv
fi