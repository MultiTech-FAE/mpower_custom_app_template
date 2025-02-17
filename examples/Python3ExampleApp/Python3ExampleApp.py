#!/usr/bin/python3
#
# Python3ExampleApp.py
#  Example mPower custom application using python3.
#

import os
import time

# Environment variable contains application directory where `status.json` is located.
APP_DIR_ENV = 'APP_DIR'

# Sleep time between status updates in seconds.
SLEEP_TIME_SEC = 10

if __name__ == '__main__':
    last_update_time_str = 'Unknown'
    status_json_fname = os.path.join(os.getenv(APP_DIR_ENV), 'status.json')

    while(1):
        last_update_time_str = time.strftime('%X %x %Z')
        status_msg = f'Last update: {last_update_time_str}, sleeping {SLEEP_TIME_SEC} second(s).'
        try:
            with open(status_json_fname, 'w') as f:
                pid = os.getpid()
                f.write (
                    '{'
                        f'"pid":"{pid}",'
                        f'"AppInfo":"{status_msg}"'
                    '}'
                )
        except Exception as e:
            pass

        time.sleep(SLEEP_TIME_SEC)
