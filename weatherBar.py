#!/usr/bin/python
# -*- coding: utf-8 -*-

#gets data from openweathermap and from local raspberry pi with dht11 sensor
#requires pango markup in weather widget
import sys
import subprocess

import urllib2
import json

piFlaskPort = 'raspberrypi.local:5000'
xresLoc = '/home/ggljzr/.Xresources'
location = 'Prague'
apiKey = "your_api_key" #you need to register on www.openweathermap.org to get api key

response = None
localResponse = None

#show help :-D
if '-h' in sys.argv or '--help' in sys.argv:
	print 'use -s or --short for shortened output'
	print 'use -i or --icons for icons in output instead of text'
	sys.exit()

#localDataColor = '"#C36661"'
#gets red color from .Xresources, not very nice, only simple error handling

procCat = subprocess.Popen(["cat", xresLoc], stdout=subprocess.PIPE)
procGrep = subprocess.Popen(["grep", "color9"], stdin=procCat.stdout, stdout=subprocess.PIPE)
procCat.stdout.close()

#get color (last 7 chars) after striping whitespaces
localDataColor = '"' +procGrep.communicate()[0].strip()[-7:] + '"' 
if localDataColor == '""':
	localDataColor = '"#C36661"'

#requires pango markup in i3blocks
markup = 'foreground = ' + localDataColor

temp = '-'
tempLocal = '<span '+ markup + ' >-</span>'
hum =  '-'
humLocal = '<span '+ markup + ' >-</span>'

#printout format
tempPrint = 'Temperature '
humPrint = 'Humidity '

#get openweathermap data
try:
	response = urllib2.urlopen('http://api.openweathermap.org/data/2.5/weather?q=' 
			+ location +
			'&units=metric&APPID=' 
			+ apiKey )
except urllib2.URLError:
	pass
else:
	rawData = response.read()
	jsonData = json.loads(rawData)
	
	try:
		main = jsonData['main']
	except KeyError:
		pass
	else:
		temp = str(main['temp'])
		hum = str(main['humidity'])

#get local data
try:
	localResponse = urllib2.urlopen('http://' + piFlaskPort + '/getTemp' )
except urllib2.URLError:
	pass	

else:
	rawLocalData = localResponse.read()
	jsonLocalData = json.loads(rawLocalData)

	try:
		tempLocal = '<span '+ markup + ' >' + str(jsonLocalData['temp']) + '</span>'
		humLocal = '<span '+ markup + ' >' + str(jsonLocalData['hum']) + '</span>'
	except KeyError:
		pass



if response is None and localResponse is None:
	sys.stdout.write('No connection')
	sys.exit()

#shortened printout option


if '-s' in sys.argv or '--short' in sys.argv:
	tempPrint = 'Tmp '
	humPrint = 'Hum '
if '-i' in sys.argv or '--icon' in sys.argv:
	tempPrint = ' '
	humPrint = ' '

sys.stdout.write(tempPrint + temp + ' (' + tempLocal + ') °C / ' + humPrint + hum + 
		 ' (' + humLocal + ') %')



