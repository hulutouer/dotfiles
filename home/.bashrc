#
# ~/.bashrc
#

# If not running interactively, don't do anything
#export WORKON_HOME=$HOME/virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
# source $HOME/.local/bin/virtualenvwrapper.sh
[[ $- != *i* ]] && return
lunar-date

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx 
fi

[ ! -e ~/.dircolors ] && eval $(dircolors -p > ~/.dircolors) 
[ -e /bin/dircolors ] && eval $(dircolors -b  ~/.dircolors)
PS1='[\u@\h \W]\$ '

### ALIASES ###
alias grep='grep --color=auto'
alias hibernate="systemctl hibernate"
alias fetchit="fetchit -t cyan -b yellow -o magenta -f ~/software/woman_ascii.txt "

# list
alias l.="ls -A | egrep '^\.'"
alias ls='ls --color=auto'
alias ll="ls -alFh"
alias la="ls -A"
alias l="ls -CF"

alias df="df -sh"
# free 
alias free="free -mt"
#add new fonts
alias update-fc='sudo fc-cache -fv'
