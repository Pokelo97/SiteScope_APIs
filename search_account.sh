#!/bin/bash
HOSTNAME=$Search_API
USERNAME=$1
DOMAIN=$2
BASE_DN=$3
BASIC_AUTH=$4
http_response=$(curl -s -k -X GET "$HOSTNAME?name=$USERNAME" \
   -H "Authorization: Basic $BASIC_AUTH")

if [[ $http_response == *"$DOMAIN"* && $http_response == *"$BASE_DN"* ]]; then
  echo $USERNAME
fi
