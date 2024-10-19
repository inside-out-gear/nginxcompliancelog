# NGINX Compliance Logging Script

## Overview

`nginxcompliance.sh` is a Bash script designed to process NGINX access logs and generate compliance reports for website access data. This script is crucial for audit and compliance purposes, providing detailed insights into IP address access patterns.

## Features

- Processes NGINX access logs
- Generates a comprehensive IP log with timestamps and geolocation data
- Creates a report of repeated IP addresses
- Handles date parsing for NGINX log format
- Utilizes geoiplookup for country information

## Prerequisites

- Bash shell
- NGINX server with access logs
- `geoiplookup` utility installed
- Write access to `/appdata/compliance/reports/` directory

## Installation

1. Clone this repository or download the `nginxcompliance.sh` script.
2. Place the script in a suitable directory, e.g., `/usr/local/bin/`.
3. Make the script executable:

chmod +x /usr/local/bin/nginxcompliance.sh
text

## Configuration

1. Open `nginxcompliance.sh` in a text editor.
2. Modify the following variables if necessary:
- `LOG_FILE`: Path to your NGINX access log (default: `/var/log/nginx/access.log`)
- `IP_LOG_FILE`: Path for the generated IP log
- `REPEATED_IP_REPORT`: Path for the repeated IP report

## Usage

Run the script manually:


/usr/local/bin/nginxcompliance.sh
text

The script will generate two files:
1. An IP log file: `/appdata/compliance/reports/ip_log_YYYY-MM-DD.csv`
2. A repeated IP report: `/appdata/compliance/reports/repeated_ip_log_YYYY-MM-DD.csv`

## Cron Job Setup

To run the script automatically, set up a cron job:

1. Open the crontab file:

crontab -e
text

2. Add the following line to run the script daily at 1 AM:

0 1 * * * /usr/local/bin/nginxcompliance.sh
text

3. Save and exit the crontab editor.

## Script Explanation

1. **Log Processing**: 
- Reads the NGINX access log line by line.
- Parses the date and time from each log entry.
- Extracts the IP address from each entry.

2. **Geolocation**:
- Uses `geoiplookup` to determine the country of each IP address.

3. **IP Log Generation**:
- Creates a CSV file with IP addresses, access timestamps, and countries.

4. **Repeated IP Detection**:
- Counts occurrences of each IP address.
- Generates a separate report for IPs that appear more than once.

5. **Output**:
- Produces two CSV files: one for all IP accesses and another for repeated IPs.

## Troubleshooting

- Ensure the script has execute permissions.
- Verify that the NGINX log file path is correct.
- Check if `geoiplookup` is installed and functioning.
- Ensure the script has write permissions for the output directory.

## Limitations

- The script processes the entire NGINX log file each time it runs, which may be resource-intensive for very large log files.
- Geolocation data accuracy depends on the `geoiplookup` database's freshness.

## Contributing

Contributions to improve the script are welcome. Please submit pull requests or open issues for any enhancements or bug fixes.

## License

MIT License
