#!/bin/bash

# webservco/internet-bandwidth-test
# Test internet bandwidth using speedtest-cli and write the results in a CSV file.

P_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/" # program path

command -v speedtest-cli >/dev/null 2>&1 || {
    echo >&2 "speedtest-cli not installed. Aborting.";
    return 1;
}

# Check if configuration file is present
if [ ! -f "${P_PATH}config.sh" ]; then
    echo "Configuration file is missing"
    return 1
fi

. "${P_PATH}config.sh" # load custom configuration

LOG_DATE=$(date '+%Y-%m-%d') # log file date format
LOG_FILE="${LOG_PATH}${LOG_NAME}-$LOG_DATE.csv" # log file name

mkdir -p $(dirname $LOG_FILE) # create log dir if not exists

SPEED_TEST_RES=$(speedtest-cli --simple --share --server $SERVER_ID 2>/dev/null) # perform speedtest action

# Parse result

RESULT_PING=$(echo $SPEED_TEST_RES | awk '{print $2}')
RESULT_DOWNLOAD=$(echo $SPEED_TEST_RES | awk '{print $5}')
RESULT_UPLOAD=$(echo $SPEED_TEST_RES | awk '{print $8}')
RESULT_SHARE=$(echo $SPEED_TEST_RES | awk '{print $12}')

# Default data
[[ -z "$RESULT_DOWNLOAD" ]] && { RESULT_PING=0; RESULT_DOWNLOAD=0; RESULT_UPLOAD=0; RESULT_SHARE=''; }


# If log file doesn't exist yet, write the header line
if [ ! -f $LOG_FILE ]; then
    echo "Date,Ping,Download,Upload,Result" >> $LOG_FILE
fi

LOG_TIME=$(date '+%Y-%m-%dT%H:%M:%S') # log time format

#  Write result in log file
echo "$LOG_TIME,$RESULT_PING,$RESULT_DOWNLOAD,$RESULT_UPLOAD,$RESULT_SHARE" >> $LOG_FILE

return 0
