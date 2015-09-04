#!/bin/bash

cat $1/xres > ~/.Xresources
cat $1/config > ~/.i3/config
cat $1/i3blocks > ~/.i3blocks.conf
cat $1/userChrome.css > "/home/ggljzr/.mozilla/firefox/az8dnp0b.default-1441248752478/chrome/userChrome.css" 
cat $1/redmond > ~/.vim/colors/redmond.vim
cat $1/ncmpcppConfig > ~/.ncmpcpp/config

xrdb -load ~/.Xresources
