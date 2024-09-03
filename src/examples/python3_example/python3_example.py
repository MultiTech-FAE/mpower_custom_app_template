#!/usr/bin/python3
#
# python3_example.py
#  Example mPower custom application using python3.
#
# Created 8/2/2024 by Richard Healy <rhealy@multitech.com> 
#

########################################################################
# Imports
########################################################################

import applogger
applogger.init(handle = "python3_example")
logger = applogger.get_logger()

from appargs import AppArgs
from mpower_api import get_device_serial_number

########################################################################
# Main
########################################################################

APP_DESCRIPTION = (
    'Example loads a configuration file, gets device serial number '
    'using the mPower HTTP API, and writes output to /var/log/messages.'
)

if __name__ == '__main__':
    #Begin.
    logger.info("python3 example application begin...")

    #Get command line arguments.
    args = AppArgs(APP_DESCRIPTION).parse_args()

    #Get device serial number.
    serialno = get_device_serial_number()
    if not serialno:
        serialno = '0'

    # Write to logs.
    logger.info(f'Device Serial Number: {serialno}'
    for key,val in args:
        logger.info(f'Argument {key} = {value}'

    #End.
    logger.info("python3 example application end.")