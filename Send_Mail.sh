#!/bin/bash

input_file="table.csv"
table="table.txt"
mail_body="mail_body.txt"
_to="IAMNotifications@vodacom.co.za"


# Header
printf " %-14s | %-20s | %-35s | %-30s |\n" "Service Account" "LDAP Host" "Email Address" "Full Name (Owner's Details)" > $table
printf "|----------------------|----------------------|-------------------------------------|------------------------------|\n" >> $table

# Initialize variables
current_service_account=""

# Process the file line by line
while IFS= read -r line; do
    # Clean the line (trim spaces, normalize pipes)
    clean_line=$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | tr -s '|' '|')
    clean_line=$(echo "$clean_line" | sed 's/^|//; s/|$//')  # remove leading/trailing pipes

    # Skip empty lines and lines with just dashes (separators)
    if [[ -z "$clean_line" || "$clean_line" =~ ^-+$ ]]; then
        continue
    fi

    # If the service account field is empty, we should append this line to the previous one
    if [[ "$clean_line" =~ ^[[:space:]]*, ]]; then
        # Append this line to the current service account
        current_service_account="$current_service_account$(echo "$clean_line" | xargs)"
        continue
    fi

    # Split line by commas (fields should be split by | but we expect commas in this case)
    IFS=',' read -ra fields <<< "$clean_line"
    
    # If service account is found, update it
    if [[ -n "${fields[0]}" ]]; then
        current_service_account="${fields[0]}"
    fi

    # Extract the fields
    service_account=$(echo "$current_service_account" | xargs)
    ldap_host=$(echo "${fields[1]}" | xargs)
    email=$(echo "${fields[2]}" | xargs)
    full_name=$(echo "${fields[3]}" | xargs)

    # Print the formatted row
    printf "| %-20s | %-20s | %-35s | %-30s |\n" "$service_account" "$ldap_host" "$email" "$full_name" >> $table
done < "$input_file"

echo -e "Hi Team,\n\n
      Can you please add the correct information for the accounts listed below? 
      The email address or Owner Details have not been provided.
      Service Accounts will not been monitored SiteScope without the correct details
      \n\n
      $(cat $table)
      \n
      Regards,
      \nIAM TEAM" > $mail_body

mail -a "$input_file" \
    -s "Service Accounts missing information" \
    -r "$VarHost"@vodacom.co.za $_to \
    < $mail_body


