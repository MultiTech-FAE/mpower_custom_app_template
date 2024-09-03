#
# mpower_api.py
#  Helper functions use the mPower HTTP based API to get information.
#
#  May only be used on device when executed with superuser privileges.
#
# Created 8/2/2024 by Richard Healy <rhealy@multitech.com> 
#

########################################################################
# Imports
########################################################################

import sys
import requests
import applogger

logger = applogger.get_logger()


########################################################################
# Private Functions
########################################################################

def _validate_and_return_result(json_dict):
    '''Make sure HTTP response code is 200 and return result if exists.'''
    if 'code' in json_dict:
        code = json_dict['code']
        if code == 200:
            if 'result' in json_dict:
                return json_dict['result']
            else:
                logger.error("Did not get expected 'result' member in JSON.")
        else:
            logger.error(f'Expected code 200. Got {code} instead.')
    else:
        logger.error("Did not get expected 'code' member in JSON.")

    return None


def _invoke_api(api_url):
    '''Invoke API.'''
    try:
        response = requests.get(api_url, verify=False)
        if response:
            return _validate_and_return_result(response.json())
        else:
            logger.error('Did not get API response.')
    except:
        pass


########################################################################
# Public Functions
########################################################################

def get_device_serial_number():
    '''Gets the device's serial number.'''
    return _invoke_api("https://127.0.0.1/api/system/deviceId")


def get_device_nat_firewall_rules():
    '''Returns device's packet forwarding rules.'''
    return _invoke_api("https://127.0.0.1/api/nat")