#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -f /etc/bash_completion ]; then
	./etc/bash_completion
fi