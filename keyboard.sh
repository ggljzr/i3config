LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}')

echo "$LAYOUT"
