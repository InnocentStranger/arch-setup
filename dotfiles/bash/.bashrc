#  ____                      _                      
# | __ )  __ _  ___ | |__  _ __ ___ 
# |  _ \ / _` |/ __|| '_ \| '__/ __|
# | |_) | (_| |\__ \| | | | | | (__ 
# |____/ \__,_||___/|_| |_|_|  \___|
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tmux='tmux -u'

# starship
eval "$(starship init bash)"

# nvm
source /usr/share/nvm/init-nvm.sh
