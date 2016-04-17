#!/bin/bash
LED=$(xset q | grep LED | cut -d: -f4 | tr -d " ")

OFF_COLOR=$(cat /home/ggljzr/.Xresources | grep "color8" | cut -d: -f2 | tr -d " ")
ON_COLOR=$(cat /home/ggljzr/.Xresources | grep "color14" | cut -d: -f2 | tr -d " ")

if (( ($LED & 2) >> 1 ))
then
    echo '<span foreground = "'$ON_COLOR'">NUM</span>'
    #echo "NUM ON"
else
    echo '<span foreground = "'$OFF_COLOR'">NUM</span>'
    #echo "NUM OFF"
fi

