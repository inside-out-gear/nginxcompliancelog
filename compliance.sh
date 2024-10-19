#!/bin/bash

# Define the log file and output file paths
LOG_FILE="/var/log/nginx/access.log"
IP_LOG_FILE="/appdata/compliance/reports/ip_log_$(date +%Y-%m-%d).csv"
REPEATED_IP_REPORT="/appdata/compliance/reports/repeated_ip_log_$(date +%Y-%m-%d).csv"

# Create CSV headers for the IP log
echo "IP Address,Date (UTC),Country" > $IP_LOG_FILE

# Create CSV headers for the repeated IP report
echo "IP Address,Access Count,Country" > $REPEATED_IP_REPORT

# Temporary file for counting repeated IPs
TEMP_FILE=$(mktemp)

# Process the nginx log file
awk '{print $1, $4, $5}' $LOG_FILE | while read -r ip date time; do
    # Remove the opening '[' and closing ']'
    datetime_string="${date:1}${time%]*}"
    
    # Convert the nginx log date format to a format that 'date' can understand
    formatted_date=$(echo "$datetime_string" | sed 's/:/\ /' | sed 's/\//\-/g')
    
    # Convert the datetime to UTC format
    datetime_utc=$(date -d "$formatted_date" -u +"%Y-%m-%d %H:%M:%S" 2>/dev/null)

    if [ -z "$datetime_utc" ]; then
        echo "Debug: Skipping invalid date format for IP=$ip, Date=$datetime_string"
        continue
    fi

    country=$(geoiplookup "$ip" | awk -F ': ' '{print $2}')
    echo "$ip,$datetime_utc,$country" >> $IP_LOG_FILE
    echo "$ip" >> $TEMP_FILE
done

# Process the temporary file to create the repeated IP report
sort $TEMP_FILE | uniq -c | awk '$1 > 1 {print $2 "," $1}' | while IFS=',' read -r ip count; do
    country=$(awk -F ',' -v ip="$ip" '$1 == ip {print $3; exit}' $IP_LOG_FILE)
    echo "$ip,$count,$country" >> $REPEATED_IP_REPORT
done

# Remove temporary file
rm $TEMP_FILE

# Print confirmation messages
echo "IP log saved to $IP_LOG_FILE"
echo "Repeated IP report saved to $REPEATED_IP_REPORT"
