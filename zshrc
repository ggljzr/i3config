# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ggljzr/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#

autoload -U colors && colors
PROMPT="%{$fg_bold[red]%}[%n%{$reset_color%}%{$fg_bold[blue]%}@%m] %{$fg_bold[green]%}%1~ %{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
#PROMPT="%{$fg_bold[red]%}>>%{$reset_color%} "

#RPROMPT='<<'
#
#case $TERM in
#	rxvt-unicode*)
#		preexec () {print -Pn "\e]0;%~ : $*\a"}
#        ;;
#esac

export PYTHONPATH=/home/ggljzr/Documents/git/caffe/python:$PYTHONPATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH
