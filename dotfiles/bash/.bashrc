#  ____                      _                      
# | __ )  __ _  ___ | |__  _ __ ___ 
# |  _ \ / _` |/ __|| '_ \| '__/ __|
# | |_) | (_| |\__ \| | | | | | (__ 
# |____/ \__,_||___/|_| |_|_|  \___|
#

#  Fedora Global Definitions 
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

#  Interactive Check
[[ $- != *i* ]] && return

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# --- CUSTOMIZATIONS ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tmux='tmux -u'

# starship
eval "$(starship init bash)"

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
