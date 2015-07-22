#!/bin/bash

cat $1/xres > ~/.Xresources
cat $1/config > ~/.i3/config
cat $1/i3blocks > ~/.i3blocks.conf
cat $1/userChrome.css > ~/.mozilla/firefox/01xfdl7t.default/chrome/userChrome.css
cat $1/bashrc > ~/.basrc
cat $1/redmond > ~/.vim/colors/redmond.vim


xrdb -load ~/.Xresources
