# Interactive shell settings: prompt, aliases, completions, and history.

# Put this at the absolute top of ~/.zshrc
typeset -U path cdpath fpath manpath

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

export TERM="tmux-256color"

# https://apple.stackexchange.com/questions/40734/why-is-my-host-name-wrong-at-the-terminal-prompt-when-connected-to-a-public-wifi
# scutil --get HostName
# sudo scutil --set HostName 'yourHostName'

eval "$(pyenv init -)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Set readline-style/emacs-style keybindings for zsh line editing
bindkey -e

# TAB COMPLETIONS
autoload -Uz compinit && compinit

# NEOVIM ALIASES
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvim-lazyvim='NVIM_APPNAME="nvim-lazyvim" nvim'
alias vi=nvim
alias vim=nvim

# ZSH CONFIG ALIASES
alias sourceenv='. "$HOME/.zshenv"'
alias lessenv='less "$HOME/.zshenv"'
alias catenv='cat "$HOME/.zshenv"'
alias vimenv='vi "$HOME/.zshenv"'

alias sourcebp='. "$HOME/.zshrc"'
alias sourcerc='. "$HOME/.zshrc"'
alias lessrc='less "$HOME/.zshrc"'
alias catrc='cat "$HOME/.zshrc"'
alias vimrc='vi "$HOME/.zshrc"'

# SSH
alias publickey='cat ~/.ssh/id_ed25519.pub | pbcopy'
alias sshconfig='vi ~/.ssh/config'
alias knownhosts='vi ~/.ssh/known_hosts'

# SHORTCUT COMMANDS
alias ll='ls -laG'
alias code='cd ~/code'
alias ccc='cat_common_commands'

# UTILITY COMMANDS
alias gitlog="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias log_start_time='DATE_STRING=$(date +"%r %F");echo "Start Time: $DATE_STRING"'
alias log_end_time='DATE_STRING=$(date +"%r %F");echo "End Time: $DATE_STRING"'

# functions
stlight() {
    # set_theme "catppuccin-latte"
    set_theme "tokyonight-day"
}

stdark() {
    set_theme "tokyonight-storm"
}

set_theme() {
    MYPWD=${PWD}
    code && cd machine-config && ./set_theme.sh $1
    cd $MYPWD
}

cat_common_commands() {
    clear
    cat << CCC
COMMON COMMANDS

    alias

    git update-index --chmod=+x path/to/new/file.txt

    grep -r --exclude-dir=node_modules select2.js . | less

    cat something.txt | pbcopy

CCC
}

# cd_fnm() {
#     builtin cd "$@"
#
#     if [[ -f .node-version && .node-version ]]; then
#         echo "fnm: Found .node-version"
#         fnm use
#     elif [[ -f .nvmrc && .nvmrc ]]; then
#         echo "fnm: Found .nvmrc"
#         fnm use
#     fi
# }

ngb() { #generate a new git branch name beginning
    local yearNumber=$(date +%y)
    local weekNumber=$(date +%U)
    local remainder=$(($weekNumber%2))

    if [[ $remainder -eq 1 ]]
    then
        local evenWeekNumber=$(($weekNumber-1))
        echo "$yearNumber$evenWeekNumber-kar-"
    else
        echo "$yearNumber$weekNumber-kar-"
    fi
}

gitcb() { #git checkout new branch
    git checkout -b $(ngb)$1
}

if [[ -r "${HOMEBREW_PREFIX:-}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX:-}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -r "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -r "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
