#!/bin/bash
#
# bash_example.sh
#
#  Example mPower custom application using bash.
#
# Created 9/23/2024 by Richard Healy <rhealy@multitech.com> 
#

set -x

DEVICE_ID=$(wget -qO- --no-check-certificate https://127.0.0.1/api/system/deviceId)

logger -t bash_example $DEVICE_ID