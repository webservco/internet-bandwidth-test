#!/bin/bash

# webservco/internet-bandwidth-test
# Test internet bandwidth using speedtest-cli and write the results in a CSV file.

p_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/" # program path

# Check external command
command -v speedtest-cli >/dev/null 2>&1 || {
    echo >&2 "speedtest-cli not installed. Aborting.";
    return 1;
}

# Check if configuration file is present
if [ ! -f "${p_path}config.sh" ]; then
    echo "Configuration file is missing"
    return 1
fi

. "${p_path}config.sh" # load custom configuration

log_date=$(date '+%Y-%m-%d') # log file date format
log_dir=$(date '+%Y-%m')
log_file="${log_path}${log_dir}/${log_name}-$log_date.csv" # log file name

mkdir -p $(dirname $log_file) # create log dir if not exists

if [ -n "$server_id" ]
then
    result=$(speedtest-cli --simple --share --server $server_id 2>&1) # perform speedtest action
else
    result=$(speedtest-cli --simple --share 2>&1) # perform speedtest action
fi

# Parse result
r_ping=$(echo "$result" | grep 'Ping' | awk '{print $2}')
r_download=$(echo "$result" | grep 'Download' | awk '{print $2}')
r_upload=$(echo "$result" | grep 'Upload' | awk '{print $2}')
r_share=$(echo "$result" | grep 'Share' | awk '{print $3}')

r_message=''
if [ "$debug" = 1 ]; then
    r_message=$(echo "$result")
fi

# log full result on error, even if debug disabled
if [[ ( -z "$r_ping" ) || ( "$r_download" = "0" ) ]]; then
    r_message=$(echo "$result")
fi

# If log file doesn't exist yet, write the header line
if [ ! -f $log_file ]; then
    echo "Date,Ping,Download,Upload,Message" >> $log_file
fi

log_time=$(date '+%Y-%m-%dT%H:%M:%S') # log time format

#  Write result in log file
echo "$log_time,$r_ping,$r_download,$r_upload,$r_share,\"$r_message\"" >> $log_file
