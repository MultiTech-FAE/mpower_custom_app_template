#!/bin/bash
#
# BashExampleApp.sh - Get device serial number, log, and quit application.
#

set -x

#Use mPower API to get device serial number (AKA deviceID)
DEVICE_ID=$(wget -qO- --no-check-certificate https://127.0.0.1/api/system/deviceId)

#Log result to /var/log/messages
logger -t BashExampleApp $DEVICE_ID
