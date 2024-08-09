#!/usr/bin/python

#Sample Test

import time

from datetime import datetime


if __name__ == '__main__':

    #BT - Using the with statement - you don't have to worry about closing file. It will
    #     automatically taking care it for you.
    while True:
        with open("test.txt",'w') as f:
            # datetime object containing current date and time
            now = datetime.now()
            # dd/mm/YY H:M:S
            dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
            f.write(dt_string)
            f.write('\r\n')

        time.sleep(1)

    


