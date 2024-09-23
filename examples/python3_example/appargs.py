#
# appargs.py
#  Example helper class parses command line arguments.
#
# Created 8/2/2024 by Richard Healy <rhealy@multitech.com> 
#

########################################################################
# Imports
########################################################################

import json
import logging
import argparse
import applogger

logger = applogger.get_logger()

########################################################################
# Classes
########################################################################

#
# DEFAULT_DESCRIPTION[]
#  Default application description used if none specified in 
#  AppArgs.__init__()
#
DEFAULT_DESCRIPTION = (
    'This a default description for the application.'
)

class AppArgs():
    """Command line argument parser including config file loading."""

    def __init__(self, desc = DEFAULT_DESCRIPTION):
        self.parser = argparse.ArgumentParser(description = desc)

        self.parser.add_argument (
            '--cfgfile',
            required = True,
            dest = 'cfgfile',
            help='Name of JSON formatted configuration file. All other command line arguments are ignored.',
            type = str
        )

    def parse_args(self):
        argobj = self.parser.parse_args()
        if argobj.cfgfile:
            logger.info(f'Loading configuration file "{argobj.cfgfile}"...')
            with open(argobj.cfgfile, 'rb') as f:
                argobj = json.loads(f.read())
                logger.info(f'Configuration file loaded.')
        return argobj