#
# publishers.py
#  Stdout and MQTT publishers.
#
# Created 7/22/2024 by Richard Healy <rhealy@multitech.com> 
#

########################################################################
# Imports
########################################################################

import applogger
logger = applogger.get_logger()

import paho.mqtt.client as mqtt

########################################################################
# Classes
########################################################################

class MQTTClient(mqtt.Client):
    '''Simple MQTT client connects, publishes message to topic, disconnects.'''
    #Time representation format string.
    STRFTIME_FMT_STR = '%Y-%m-%d %H:%M:%S'

    #MQTT client connection keepalive time.
    CONNECTION_KEEPALIVE_SECONDS = 60

    #Number of times to try to connect to MQTT client.
    CONNECTION_TRIES = 5

    def __init__(self,
                 client_id,
                 host, port,
                 uname, passwd,
                 sub_topics = None):

        #Create mqtt object.
        super().__init__(client_id, 
                         protocol=mqtt.MQTTv311, 
                         clean_session=True)

        #Initialize class members.
        self.mqtt_client_id  = client_id
        self.mqtt_uname      = uname
        self.mqtt_passwd     = passwd
        self.mqtt_host       = host
        self.mqtt_port       = port
        self.mqtt_connected  = False
        self.mqtt_sub_topics = []

        #mqtt.Client.subscribe() method takes an array of (topic, QoS) tuples.
        if sub_topics:
            for topic in sub_topics:
                self.mqtt_sub_topics.append((topic, 0))

        #Set username and password in mqtt.Client.
        self.username_pw_set(uname, passwd)

    def start(self):
        logger.info(f'Starting MQTT client. '
                    f'Client ID = {self.mqtt_client_id}, '
                    f'host = {self.mqtt_host}:{self.mqtt_port}, '
                    f'uname = {self.mqtt_uname} ')

        self.connect (
            host = self.mqtt_host,
            port = self.mqtt_port,
            keepalive = self.CONNECTION_KEEPALIVE_SECONDS
        )

        self.subscribe(self.mqtt_sub_topics)
        self.loop_start()

    def stop(self):
        self.disconnect()
        while self.mqtt_connected:
            time.sleep(.1)

    def publish_message(self, message, topic):
        self.publish(topic, message)

    def publish_dictionary(self, dictionary, topic):
        '''Recurses through dictionary items using key as the topic level.'''

        def _publish_dictionary_recursive(cur_topic, cur_dict):
            for key, value in cur_dict.items():
                new_topic = cur_topic + '/' + key
                if isinstance(value, dict):
                    _publish_dictionary_recursive(new_topic, value)
                else:
                    self.publish(new_topic, value)

        #Recursive function traverses nested dictionaries and publishes items.
        _publish_dictionary_recursive(topic, dictionary)

    ################################################
    # MQTT Callback Functions
    ################################################

    def on_connect(self, client, userdata, flags, rc):
        '''When successfully connected subscribe to topics.'''
        logger.info(f'MQTTClient.on_connect(): Connection succeeded.')
        self.mqtt_connected = True

    def on_connect_fail(self, client, userdata):
        '''When successfully connected subscribe to desired topic.'''
        logger.info(f'MQTTClient.on_connect(): Connection failed.')
        client.mqtt_connected = False

    def on_message(self, client, userdata, message):
        logger.info(f'MQTTClient.on_message(): Received message "{message.payload}" on topic "{message.topic}"')

    def on_subscribe(self, client, obj, mid, reason_code_list):
        logger.info(f'MQTTClient.on_subscribe(): Subscribed to topics.')

    def on_publish(self, client, userdata, result):
#        logger.debug(f'MQTTClient.on_publish(): Message published.')
        pass

    def on_disconnect(self, client, userdata,  reason_code):
        logger.info(f'MQTTClient.on_disconnect(): disconnected with reason code {reason_code}.')
        client.mqtt_connected = False


class StdOut():
    def __init__(self):
        pass

    def publish_message(self, message, topic):
        print (
            '{'
            f'"{topic}":'
            f'{message}'
            '}'
        )

    def publish_dictionary(self, dictionary, topic):
        print (
            '{'
            f'"{topic}":'
            f'{dictionary}'
            '}'
        )
