#!/bin/bash

#TODO vim support, tam neni aby to nastavilo tmavy pismo pro bilej terminal

template_path=~/Documents/git/i3config/themes/templates
ff_profile="az8dnp0b.default-1441248752478"

declare -a templates
IFS=' ' read -r -a templates <<< $(ls $template_path)

font_size=$(cat $1 | grep font | cut -d: -f3)
font_family=$(cat $1 | grep font | cut -d: -f2)

bckg=$(cat $1 | grep bckg | cut -d: -f2)
fore=$(cat $1 | grep "^fore:.*" | cut -d: -f2)

for entry in "${templates[@]}"
do


	sed s/"##bckg##"/$bckg/g $template_path/$entry > "$entry".temp
	sed -i s/"##fore##"/$fore/g "$entry".temp
	
	sed -i s/"##font_size##"/$font_size/g "$entry".temp
	sed -i s/"##font_family##"/$font_family/g "$entry".temp

	for i in {0..15}
	do
		color=$(cat $1 | grep "color$i:" | cut -d: -f3)
		sed -i s/"##color$i##"/$color/g "$entry".temp
	done
done

#nastaveni i3-gaps
border=$(cat $1 | grep border | cut -d: -f2)

#kdyz sou mezery 0, tak vodstrani i3gaps funkci z konfigu
gaps_inner=$(cat $1 | grep gaps_inner | cut -d: -f2)
gaps_outer=$(cat $1 | grep gaps_outer | cut -d: -f2)

if (( $gaps_inner == 0 && $gaps_outer == 0 )) 
then
	sed -i s/"gaps inner"/"##"/ config.temp
	sed -i s/"gaps outer"/"##"/ config.temp

	#kdyz je border 0, pouzije klasicky i3 dekorace/titlebars
	if (( $border == 0 )) 
	then
		sed -i s/"##titlebars##"/"##"/g config.temp
	else
		sed -i s/"##titlebars##"/""/g config.temp
		sed -i s/"##border##"/$border/g config.temp
	fi
else
	sed -i s/"##gaps_inner##"/$gaps_inner/g config.temp
	sed -i s/"##gaps_outer##"/$gaps_outer/g config.temp
	sed -i s/"##titlebars"/""/g config.temp
	sed -i s/"##border##"/$border/g config.temp
fi

#nastaveni i3 barev

for placeholder in "focused" "inactive" "unfocused" "urgent" "foreground"
do
	color=$(cat $1 | grep "^$placeholder" | cut -d: -f2)
	color_val=$(cat $1 | grep ":$color:" | cut -d: -f3)
	sed -i s/"##"$placeholder"##"/$color_val/g config.temp
done	

#vypnuti/zapnuti stinu
shadows=$(cat $1 | grep shadows | cut -d: -f2)
sed -i s/"##shadows##"/$shadows/g compton.conf.temp

#parsovani barvy do firefox podle toho jesli je theme dark
#nebo light
ff_theme=$(cat $1 | grep ff_theme | cut -d: -f2)
ff_theme_color=$(cat $1 | grep ":$ff_theme"Grey: | cut -d: -f3)
sed -i s/"##special1##"/$ff_theme_color/g newtab.css.temp

sed -i s/"##special1##"/$ff_theme_color/g userChrome.css.temp

sed -i s/"##special1##"/$ff_theme_color/g redmond.vimp.temp

#nastaveni pozadi
wallpaper_path=$(cat $1 | grep wallpaper | cut -d: -f2)
sed -i s@"##wallpaper##"@$wallpaper_path@ config.temp

mv xres.temp ~/.Xresources
mv config.temp ~/.i3/config
mv dunstrc.temp ~/.config/dunst/dunstrc
mv i3blocks.temp ~/.i3blocks.conf
mv newtab.css.temp ~/Documents/ffConfig/newtab/newtab.css
mv userChrome.css.temp ~/.mozilla/firefox/"$ff_profile"/chrome/userChrome.css 
mv redmond.vimp.temp ~/.vimperator/colors/redmond.vimp
mv compton.conf.temp ~/.config/compton.conf

#load wallpaper
feh --bg-scale $wallpaper_path

#load xres
xrdb -load ~/.Xresources

#restart compton
pkill compton
compton -b

#restart i3
i3-msg restart
