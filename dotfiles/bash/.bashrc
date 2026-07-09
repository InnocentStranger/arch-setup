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
set EDITOR=nvim

# nvm
if [ -f /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
