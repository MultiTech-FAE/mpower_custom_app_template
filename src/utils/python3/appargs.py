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

from types import SimpleNamespace

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

#
# REQUIRED_CONFIGURATION_FILE_ARGUMENTS[]
#  Array of required argument name strings in configuration file 
# (--cfgfile)  or JSON configuration (--cfgjson).
#
# Example:
#  REQUIRED_CONFIGURATION_FILE_ARGUMENTS = ["foo"]
#
REQUIRED_CONFIGURATION_FILE_ARGUMENTS = []


class AppArgs():
    """Command line argument parser with examples of common arguments."""

    def __init__(self, desc = DEFAULT_DESCRIPTION):
        self.parser = argparse.ArgumentParser(description = desc)

        self.parser.add_argument (
            '--cfgfile',
            required = False,
            dest = 'cfgfile',
            help='Name of JSON formatted configuration file. All other command line arguments are ignored.',
            type = str
        )

        self.parser.add_argument (
            '--cfgjson',
            required = False,
            dest = 'cfgjson',
            help='Use supplied JSON string as the configuration. All other command line arguments are ignored',
            type = str
        )

# Example of a JSON formatted array of arguments.
#  Change `--json_array` to desired command line argument. Change `json_array` to arg object. 
#
#        self.parser.add_argument (
#            '--json_array',
#            required = False,
#            dest = 'json_array',
#            help='JSON formatted array of additional arguments that will be passed to the invocation. Example: --json_array \'["port 2000","dst 192.168.2.1","src 192.168.2.20"]\'',
#            default = [],
#            type=json.loads
#        )


# Example of an integer argument.
#  Change `--integer` to desired command line argument. Change `integer` to arg object. 
#
#        self.parser.add_argument (
#            '--integer',
#            required = False,
#            dest = 'integer',
#            help='Integer argument.',
#            default = 5,
#            type = int
#        )

# Example of boolean argument.
#  Change `--boolean` to desired command line argument. Change `boolean` to arg object. 
#        self.parser.add_argument (
#            '--boolean',
#            dest='boolean',
#            action='store_true',
#            help='Boolean argument will set value based on `action` and `default`.',
#            default = False
#        )


# Example of string argument.
#  Change `--string` to desired command line argument. Change `string` to arg object.
#        self.parser.add_argument (
#            '--string',
#            required = False,
#            dest = 'string',
#            help = ('String argument ".'),
#            default = 'PacketAnalyzerClientID',
#            type = str
#        )

    def load_configuration_file(self, fname):
        '''Try to load and validate JSON formatted configuration file.'''
        logger.info(f'Loading configuration file "{fname}"...')

        with open(fname, 'rb') as f:
            jsonstr = f.read()
            jsonobj = json.loads (
                jsonstr,
                object_hook=lambda d: SimpleNamespace(**d)
            )

            for arg in REQUIRED_CONFIGURATION_FILE_ARGUMENTS:
                if hasattr(jsonobj, arg):
                    continue
                raise Exception(f'--cfgfile - Configuration file missing required argument "{arg}".')

            logger.info(f'Configuration file loaded.')
            return jsonobj

    def self.parse_json_configuration_str(self, jsonstr):
        logger.info(f'Parsing JSON configuration string "{jsonstr}"...')
        jsonobj = json.loads (
            jsonstr,
            object_hook=lambda d: SimpleNamespace(**d)
        )

        for arg in REQUIRED_CONFIGURATION_FILE_ARGUMENTS:
            if hasattr(jsonobj, arg):
                continue
            raise Exception(f'--cfgjson - Configuration missing required argument "{arg}".')

        logger.info(f'JSON configuration string parsed.')
        return jsonobj

    def parse_args(self):
        argobj = self.parser.parse_args()

        if argobj.cfgfile:
            argobj = self.load_configuration_file(argobj.cfgfile)
        elif argobj.cfgjson:
            argobj = self.parse_json_configuration_str(argobj.cfgjson)

        return argobj