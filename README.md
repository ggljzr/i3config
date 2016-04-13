# i3config
dotfiles and scripts for i3 wm (Airblader's gaps fork (https://github.com/Airblader/i3))

custom userChrome.css works best with Simple White theme (https://addons.mozilla.org/en-US/firefox/addon/simplewhite/)

newtab for firefox uses zrssfeed (http://www.zazar.net/developers/jquery/zrssfeed/) to fetch news 
and is based on https://github.com/pyonium/dotfiles/blob/master/.firefox/newtab.html

So apparently openweathermap api now requires key to access it, so you need to register on www.openweathermap.org to get free api key.

TODO: 
update Startify color config in vim color scheme for other themes, add pango markup
support for weather widget to all themes, add colorschemes for vimperator

## simple themes

themes generated from simple file defining basic colors (like in .Xresources) in format

color0:#rgb:tag (tag = red, darkRed, etc)

tag is technically optional, but it is used in script that generates the theme (lightGrey and darkGrey for firefox theme)

other options in file is dark or light theme for firefox and i3 windows border size

for example themes see simple_themes/gotham.theme (try sh themeScript2.sh gotham.theme)
