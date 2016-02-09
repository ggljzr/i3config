#!/bin/bash
template_path=~/Documents/git/i3config/themes/templates
ff_profile="az8dnp0b.default-1441248752478"

declare -a templates
IFS=' ' read -r -a templates <<< $(ls $template_path)

font_size=$(cat $1 | grep font | cut -d: -f3)
font_family=$(cat $1 | grep font | cut -d: -f2)

bckg=$(cat $1 | grep bckg | cut -d: -f2)
fore=$(cat $1 | grep fore | cut -d: -f2)

for entry in "${templates[@]}"
do


	sed s/"##bckg##"/$bckg/ $template_path/$entry > "$entry".temp
	sed -i s/"##fore##"/$fore/ "$entry".temp
	
	sed -i s/"##font_size##"/$font_size/ "$entry".temp
	sed -i s/"##font_family##"/$font_family/ "$entry".temp

	for i in {0..15}
	do
		color=$(cat $1 | grep "color$i:" | cut -d: -f2)
		sed -i s/"##color$i##"/$color/ "$entry".temp
	done
done

border=$(cat $1 | grep border | cut -d: -f2)
sed -i s/"##border##"/$border/ config.temp

#parsovani barvy do firefox podle toho jesli je theme dark
#nebo light
ff_theme=$(cat $1 | grep ff_theme | cut -d: -f2)
ff_theme_color=$(cat $1 | grep "$ff_theme"Grey | cut -d: -f2)
sed -i s/"##special1##"/$ff_theme_color/ newtab.css.temp

sed -i s/"##special1##"/$ff_theme_color/ userChrome.css.temp

sed -i s/"##special1##"/$ff_theme_color/ redmond.vimp.temp

mv xres.temp ~/.Xresources
mv config.temp ~/.i3/config
mv dunstrc.temp ~/.config/dunst/dunstrc
mv i3blocks.temp ~/.i3blocks.conf
mv newtab.css.temp ~/Documents/ffConfig/newtab/newtab.css
mv userChrome.css.temp ~/.mozilla/firefox/"$ff_profile"/chrome/userChrome.css 
mv redmond.vimp.temp ~/.vimperator/colors/redmond.vimp

xrdb -load ~/.Xresources
