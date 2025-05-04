#!/bin/bash
LDAP_URIS=("${@:1:2}")  
BASE=("${@:3:4}")
i=0
k=0

for ldap_uri in "${LDAP_URIS[@]}"; do
    if [ "$ldap_uri" == "ldaps://eassec.vodacom.corp" ]; then
        DOMAIN="EAS"
        BASE_DNS=("OU=USERS,O=AUTH" "OU=SERVICES,O=AUTH")
        BIND_DN=($EAS_BIND_DN) #LDAP EAS Account
        LDAP_PASS=$(echo "$EAS_LDAP_PASS" | base64 -d)
    elif [ "$ldap_uri" == "ldaps://idv.vodacom.corp" ]; then
        DOMAIN="IDV"
        BASE_DNS=("OU=USERS,O=IAM" "OU=SERVICES,O=IAM")
        BIND_DN=($IDV_BIND_DN) #LDAP IDV Account
        LDAP_PASS=$(echo "$IDV_LDAP_PASS" | base64 -d)
    else
        echo "$(date) ⚠️ Unknown LDAP Server: $ldap_uri" >> sitescope.logs
    fi

    # TEST LDAP 
    output=$(ldapsearch -LLL -H $ldap_uri -D $BIND_DN -w $LDAP_PASS -b $BIND_DN dn 2>&1)
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        #Add Accounts
        for BASE_DN in "${BASE_DNS[@]}"; do
            ldapsearch -LLL -H "$ldap_uri" -D "$BIND_DN" -w "$LDAP_PASS" -b $BASE_DN \
                '(&(|(cn=svc*)(sn=Service Account))(!(loginDisabled=true)))' cn mail fullname 2>/dev/null |
            awk -v uri="$ldap_uri" '
                BEGIN { cn=""; mail=""; fullname="" }
                /^dn:/ { if (cn != "") { print cn, mail, fullname; cn=""; mail=""; fullname="" } }
                /^cn:/ { cn=$2 }
                /^mail:/ { mail=$2 }
                /^fullname:/ { fullname=substr($0, index($0,$2)) }
                END { if (cn != "") { print cn, mail, fullname } }
            ' | while read cn mail fullname; do
                user=$( ./search_account.sh $cn $DOMAIN "${BASE[$i]}" $BASIC_AUTH )
                if [ $user ]; then
                    echo "$(date) ❌ uniqueness violation - the name $user exists" >> sitescope.logs
                else
                    ./Add_Account.sh $cn $cn $DOMAIN "$fullname" "$BASE_DN" $BASIC_AUTH $mail
                fi
            done
            let i++
        done
        #Delete Disabled Accounts
        for BASE_DN in "${BASE_DNS[@]}"; do
            ldapsearch -LLL -H "$ldap_uri" -D "$BIND_DN" -w "$LDAP_PASS" -b $BASE_DN \
                '(&(|(cn=svc*)(sn=Service Account))(loginDisabled=true))' cn 2>/dev/null |
            awk -v uri="$ldap_uri" '
                BEGIN { cn="" }
                /^dn:/ { if (cn != "") { print cn; cn="" } }
                /^cn:/ { cn=$2 }
                END { if (cn != "") { print cn } }
            ' | while read cn; do
                user=$( ./search_account.sh $cn $DOMAIN "${BASE[$k]}" $BASIC_AUTH )
                if [ $user ]; then
                ./Delete_Account.sh $cn "$BASE_DN" $BASIC_AUTH
                else
                    echo "$(date) ❌ No group named $cn was found" >> sitescope.logs
                fi
            done
            let k++
        done

        # send email if errors occured due to email or fullname is missing from IDV or EAS
        if [ -s "table.csv" ]; then
            ./Send_Mail.sh
        fi
        
        # clean up 
        rm -f table.csv response.json response.txt email_Properties.json mail_body.txt

    else
        echo "$(date) ❌ ldapsearch failed with exit code $exit_code." >> sitescope.logs
        echo "$(date) ❌ ldapsearch failed to connect to $ldap_uri." >> sitescope.logs
        echo "$(date) ❌ Error output:" >> sitescope.logs
        echo "$(date) $output" >> sitescope.logs
    fi
done
