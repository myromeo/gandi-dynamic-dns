#!/bin/bash

# Load Gandi API token from Home Assistant secrets
GANDI_TOKEN=$(grep gandi_api_token /config/secrets.yaml | cut -d ' ' -f2)

# Set domain and subdomain details
DOMAIN="YOUR_DOMAIN"
SUBDOMAIN="YOUR_SUBDOMAIN"
TTL=10800
IPLOOKUP="http://whatismyip.akamai.com/"
LOG_FILE="/config/gandi-dns-update.log"

# Get current external IP
CURRENT_IP=$(curl -s $IPLOOKUP)
if [ -z "$CURRENT_IP" ]; then
    echo "$(date): Error: Unable to fetch current IP." >> "$LOG_FILE"
    exit 1
fi

# Fetch existing DNS record
DNS_INFO=$(curl -s -H "Authorization: Bearer $GANDI_TOKEN" \
"https://api.gandi.net/v5/livedns/domains/$DOMAIN/records/$SUBDOMAIN/A")

# Extract DNS IP and TTL
DNS_IP=$(echo "$DNS_INFO" | jq -r '.rrset_values[0]')
DNS_TTL=$(echo "$DNS_INFO" | jq -r '.rrset_ttl')

# Validate DNS response
if [ -z "$DNS_IP" ] || [ "$DNS_IP" == "null" ]; then
    echo "$(date): Error: Failed to retrieve valid DNS record." >> "$LOG_FILE"
    exit 1
fi

# Update DNS if IP changed
if [ "$CURRENT_IP" != "$DNS_IP" ]; then
    echo "$(date): IP changed from $DNS_IP to $CURRENT_IP. Updating DNS..." >> "$LOG_FILE"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $GANDI_TOKEN" \
        -d "{\"rrset_values\": [\"$CURRENT_IP\"], \"rrset_ttl\": $TTL}" \
        "https://api.gandi.net/v5/livedns/domains/$DOMAIN/records/$SUBDOMAIN/A")

    if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 201 ]; then
        echo "$(date): DNS A record updated to $CURRENT_IP with TTL $TTL seconds." >> "$LOG_FILE"
    else
        echo "$(date): Error: API request failed with status code $RESPONSE." >> "$LOG_FILE"
    fi
else
    echo "$(date): IP unchanged at $CURRENT_IP. TTL: $DNS_TTL seconds." >> "$LOG_FILE"
fi
