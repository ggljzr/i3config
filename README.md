# i3config
dotfiles and scripts for i3 wm (Airblader's gaps fork (https://github.com/Airblader/i3))

custom userChrome.css works best with Simple White theme (https://addons.mozilla.org/en-US/firefox/addon/simplewhite/)

all themes should be up to date

config files for lemonbar are based on https://github.com/ObliviousGmn/Dotfiles/tree/master/Panel

space for lemonbar is created via empty conky window, more info about i3 with lemonbar here https://www.reddit.com/r/i3wm/comments/369sr5/lemonbar_or_i3_bar_with_gaps/

default lemonbar script (lemon) and bar_config uses 'forest' theme colors

themes to be used with lemonbar have _lemon suffix (TODO update theme script)

newtab for firefox uses zrssfeed (http://www.zazar.net/developers/jquery/zrssfeed/) to fetch news 
and is based on https://github.com/pyonium/dotfiles/blob/master/.firefox/newtab.html

So apparently openweathermap api now requires key to access it, so you need to register on www.openweathermap.org to get free api key.

TODO: make newtab.css files for different themes to match colors, update themeScripts.sh to change
these .css files, update Startify color config in vim color scheme for other themes, add pango markup
support for weather widget to all themes, add colorschemes for vimperator

## simple themes

themes generated from simple file defining basic colors (like in .Xresources) in format

color0:#rgb:tag (tag = red, darkRed, etc)

tag is technically optional, but it is used in script that generates the theme (lightGrey and darkGrey for firefox theme)

other options in file is dark or light theme for firefox and i3 windows border size

for example themes see simple_themes/gotham.theme (try sh themeScript2.sh gotham.theme)
