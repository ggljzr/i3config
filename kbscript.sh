#!/bin/bash
LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}')

NUM1=2
NUM2=1
if   [[ $LAYOUT == "cz" ]]; then
		setxkbmap us
elif [[ $LAYOUT == "us" ]]; then
		setxkbmap cz
else 
		setxkbmap cz
fi

#toggle numlock to reset leds
numlockx toggle
numlockx toggle
