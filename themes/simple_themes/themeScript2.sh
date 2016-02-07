#!/bin/bash
template_path=~/Documents/git/i3config/themes/templates
ff_profile="az8dnp0b.default-1441248752478"

declare -a templates
IFS=' ' read -r -a templates <<< $(ls $template_path)

for entry in "${templates[@]}"
do


	bckg=$(cat $1 | grep bckg | cut -d: -f2)
	sed s/"##bckg##"/$bckg/ $template_path/$entry > "$entry".temp

	fore=$(cat $1 | grep fore | cut -d: -f2)
	sed s/"##fore##"/$fore/ "$entry".temp > temp

	mv temp "$entry".temp

	for i in {0..15}
	do
		color=$(cat $1 | grep "color$i:" | cut -d: -f2)
		sed s/"##color$i##"/$color/ "$entry".temp > temp
		mv temp "$entry".temp	
	done

done

border=$(cat $1 | grep border | cut -d: -f2)
sed s/"##border##"/$border/ config.temp> temp
mv temp config.temp

#parsovani barvy do firefox podle toho jesli je theme dark
#nebo light
ff_theme=$(cat $1 | grep ff_theme | cut -d: -f2)
ff_theme_color=$(cat $1 | grep "$ff_theme"Grey | cut -d: -f2)
sed s/"##special1##"/$ff_theme_color/ newtab.css.temp > temp
mv temp newtab.css.temp

sed s/"##special1##"/$ff_theme_color/ userChrome.css.temp > temp
mv temp userChrome.css.temp

sed s/"##special1##"/$ff_theme_color/ redmond.vimp.temp > temp
mv temp redmond.vimp.temp

mv xres.temp ~/.Xresources
mv config.temp ~/.i3/config
mv dunstrc.temp ~/.config/dunst/dunstrc
mv i3blocks.temp ~/.i3blocks.conf
mv newtab.css.temp ~/Documents/ffConfig/newtab/newtab.css
mv userChrome.css.temp ~/.mozilla/firefox/"$ff_profile"/chrome/userChrome.css 
mv redmond.vimp.temp ~/.vimperator/colors/redmond.vimp

xrdb -load ~/.Xresources
