# Put this at the absolute top of ~/.zshrc
typeset -U path cdpath fpath manpath

export TERM="tmux-256color"

# https://apple.stackexchange.com/questions/40734/why-is-my-host-name-wrong-at-the-terminal-prompt-when-connected-to-a-public-wifi
# scutil --get HostName
# sudo scutil --set HostName 'yourHostName'

eval "$(pyenv init -)"
eval "$(fnm env --use-on-cd)"
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

# ZSH PROFILE ALIASES
alias sourcebp='. "$ZDOTDIR/.zprofile"'
alias lessbp='less "$ZDOTDIR/.zprofile"'
alias catbp='cat "$ZDOTDIR/.zprofile"'
alias vimbp='vi "$ZDOTDIR/.zprofile"'

alias sourcerc='. "$ZDOTDIR/.zshrc"'
alias lessrc='less "$ZDOTDIR/.zshrc"'
alias catrc='cat "$ZDOTDIR/.zshrc"'
alias vimrc='vi "$ZDOTDIR/.zshrc"'

# SSH
alias publickey='cat ~/.ssh/id_rsa.pub | pbcopy'
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

fzf_catppuccin-latte() {
    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#ccd1da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
    --color=fg:#3c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
    --color=marker:#dc7a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
}

fzf_catppuccin-frappe() {
    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
    --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
    --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
}

fzf_tokyonight-day() {
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=fg:#3760bf,bg:#e1e2e7,hl:#b15c00 \
    --color=fg+:#3760bf,bg+:#c4c8da,hl+:#b15c00 \
    --color=info:#2e7de9,prompt:#007197,pointer:#007197 \
    --color=marker:#587539,spinner:#587539,header:#587539"
}

fzf_tokyonight-storm() {
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
}

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

cd_fnm() {
    builtin cd "$@"

    if [[ -f .node-version && .node-version ]]; then
        echo "fnm: Found .node-version"
        fnm use
    elif [[ -f .nvmrc && .nvmrc ]]; then
        echo "fnm: Found .nvmrc"
        fnm use
    fi
}

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
