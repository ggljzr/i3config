# -*- coding: utf-8 -*-
import sys

import urllib2
import json


response = urllib2.urlopen('http://api.openweathermap.org/data/2.5/weather?q=Prague,cz&units=metric')
rawData = response.read()
jsonData = json.loads(rawData)
main = jsonData['main']

temp = 'Temperature ' + str(main['temp']) + u' °C'
hum = ' Humidity ' + str(main['humidity']) + ' %'

sys.stdout.write(temp.encode('utf-8') + ' /' + hum)

