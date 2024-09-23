#
# applogger.py
#  Initializes and manages logger functionality. Run applogger.init() 
#  before importing any modules that use applogger. Edit global variable
#  `APPLOGGER_FORMAT_STRING` to change appearance in log.
#
# Usage Example:
# <module.py>
#  import applogger
#  logger = applogger.get_logger()
#  logger.info("This is an informational message.")
# 
# <main.py>
#  import applogger
#  applogger.init()
#  import module
#
# Based on:
#  https://stackoverflow.com/questions/7016056/python-logging-not-outputting-anything
#  https://stackoverflow.com/questions/3968669/how-to-configure-logging-to-syslog-in-python#3969772
#
# Created on 8/28/2024 by Richard Healy <rhealy@multitech.com> 
#

########################################################################
# Imports
########################################################################

import logging
import logging.handlers

########################################################################
# Globals - Edit these.
########################################################################

# Format string. Edit to change appearance in log.
APPLOGGER_FORMAT_STRING = '%(asctime)s %(name)s [%(levelname)s] %(message)s'

########################################################################
# Globals - Do not edit.
########################################################################

# Default handle if none specified in init() function.
APPLOGGER_HANDLE_DEFAULT = 'applogger'

# Default log level if none specified in init() function.
APPLOGGER_DEFAULT_MAX_LEVEL = logging.INFO

# Global handle set by init() function. Do not touch.
APPLOGGER_HANDLE = None


########################################################################
# Functions
########################################################################

def init(handle = APPLOGGER_HANDLE_DEFAULT, max_level = APPLOGGER_DEFAULT_MAX_LEVEL, format_string = APPLOGGER_FORMAT_STRING):
    global APPLOGGER_HANDLE

    if APPLOGGER_HANDLE:
        raise Exception("Application logger already initialized.")

    #Set up logger root.
    logging.basicConfig(format = format_string, level = max_level)
    APPLOGGER_HANDLE = handle

def use_syslog():
    if APPLOGGER_HANDLE:
        logger = logging.getLogger(APPLOGGER_HANDLE)
        hndlr  = logging.handlers.SysLogHandler(address='/dev/log')
        fmtr   = logging.Formatter(APPLOGGER_FORMAT_STRING)

        hndlr.setFormatter(fmtr)
        logger.addHandler(hndlr)

def use_log_file(fname):
    '''Attempts to log to file in addition to syslog.'''
    if APPLOGGER_HANDLE:
        logger = logging.getLogger(APPLOGGER_HANDLE)
        hndlr  = logging.FileHandler(fname)
        fmtr   = logging.Formatter(APPLOGGER_FORMAT_STRING)

        hndlr.setFormatter(fmtr)
        logger.addHandler(hndlr)
    else:
        raise Exception("Application logger is not initialized. Use applogger.init() first.")        

def get_logger():
    if APPLOGGER_HANDLE:
        return logging.getLogger(APPLOGGER_HANDLE)
    raise Exception("Application logger is not initialized. Use applogger.init() first.")