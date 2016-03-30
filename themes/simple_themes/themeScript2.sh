#!/bin/bash

#TODO vim support, tam neni aby to nastavilo tmavy pismo pro bilej terminal

template_path=~/Documents/git/i3config/themes/templates
ff_profile="az8dnp0b.default-1441248752478"

declare -a templates
IFS=' ' read -r -a templates <<< $(ls $template_path)

#parse theme
parsed_theme="parsed_theme.temp"
sed '/^#/ d' $1 > $parsed_theme

font_size=$(cat $parsed_theme | grep font | cut -d: -f3)
font_family=$(cat $parsed_theme | grep font | cut -d: -f2)

bckg=$(cat $parsed_theme | grep bckg | cut -d: -f2)
fore=$(cat $parsed_theme | grep "^fore:.*" | cut -d: -f2)

color_pat="^#[a-fA-F0-9]{6}$"

for entry in "${templates[@]}"
do


	sed s/"##bckg##"/$bckg/g $template_path/$entry > "$entry".temp
	sed -i s/"##fore##"/$fore/g "$entry".temp
	
	sed -i s/"##font_size##"/$font_size/g "$entry".temp
	sed -i s/"##font_family##"/$font_family/g "$entry".temp

	for i in {0..15}
	do
		color=$(cat $parsed_theme | grep "color$i:" | cut -d: -f3)
		sed -i s/"##color$i##"/$color/g "$entry".temp
	done
done

#nastaveni i3-gaps
border=$(cat $parsed_theme | grep border | cut -d: -f2)

#kdyz sou mezery 0, tak vodstrani i3gaps funkci z konfigu
gaps_inner=$(cat $parsed_theme | grep gaps_inner | cut -d: -f2)
gaps_outer=$(cat $parsed_theme | grep gaps_outer | cut -d: -f2)

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

for placeholder in "i3_focused" "i3_inactive" "i3_unfocused" "i3_urgent" "i3_foreground" 
do
	color=$(cat $parsed_theme | grep "^$placeholder" | cut -d: -f2)
	if [[ $color =~ $color_pat ]]
	then
		color_val=$color
	else	
		color_val=$(cat $parsed_theme | grep ":$color:" | cut -d: -f3)
	fi

	sed -i s/"##"$placeholder"##"/$color_val/g config.temp
done

#vypnuti/zapnuti stinu
shadows=$(cat $parsed_theme | grep shadows | cut -d: -f2)
sed -i s/"##shadows##"/$shadows/g compton.conf.temp

#parsovani barvy do firefox podle toho jesli je theme dark
#nebo light
theme=$(cat $parsed_theme | grep theme | cut -d: -f2)
ff_theme_color=$(cat $parsed_theme | grep ":$theme"Grey: | cut -d: -f3)
sed -i s/"##special1##"/$ff_theme_color/g newtab.css.temp

sed -i s/"##special1##"/$ff_theme_color/g userChrome.css.temp

sed -i s/"##special1##"/$ff_theme_color/g redmond.vimp.temp

#zshprompt
zshprompt=$(cat $parsed_theme | grep zshprompt | cut -d: -f2)
sed -i s/"^PROMPT=.*$"/"PROMPT=$zshprompt"/ ~/.zshrc

#nastaveni pozadi
wallpaper_path=$(cat $parsed_theme | grep wallpaper | cut -d: -f2)
sed -i s@"##wallpaper##"@$wallpaper_path@ config.temp

#vim
if [ $theme == "dark" ]
then
	sed -i s/"##vim_normal##"/"white"/g redmond.vim.temp
else
	sed -i s/"##vim_normal##"/"black"/g redmond.vim.temp
fi

mv xres.temp ~/.Xresources
mv config.temp ~/.i3/config
mv dunstrc.temp ~/.config/dunst/dunstrc
mv i3blocks.temp ~/.i3blocks.conf
mv newtab.css.temp ~/Documents/ffConfig/newtab/newtab.css
mv userChrome.css.temp ~/.mozilla/firefox/"$ff_profile"/chrome/userChrome.css 
mv redmond.vimp.temp ~/.vimperator/colors/redmond.vimp
mv compton.conf.temp ~/.config/compton.conf
mv redmond.vim.temp ~/.vim/colors/redmond.vim

#load wallpaper
feh --bg-scale $wallpaper_path

#load xres
xrdb -load ~/.Xresources

#restart compton
pkill compton
compton -b

#restart i3
i3-msg restart

#restart dunst
pkill dunst
notify-send "theme: $1"
