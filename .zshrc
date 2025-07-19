# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="xiong-chiamiov-plus"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    #emacs
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export TERM="tmux-256color"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# echo ".zshrc"

# ENV VARS, PATH UPDATES
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=

export XDG_CONFIG_HOME="$HOME/.config"
export ZELLIJ_CONFIG_DIR=~/.config/zellij/


export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

export PATH=/Users/kronning/.local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH=/Users/kronning/.fnm/current/bin:$PATH
export PATH="/Users/kronning/.fnm:$PATH"

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$GOBIN:$PATH

# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home

# https://apple.stackexchange.com/questions/40734/why-is-my-host-name-wrong-at-the-terminal-prompt-when-connected-to-a-public-wifi
# scutil --get HostName
# sudo scutil --set HostName 'yourHostName'
# export PS1="\d \T @\u:\W \`parse_git_branch\` $ "
# export PS1="\T \u \W \`parse_git_branch\` $ "
export EMACS_FONT="Fira Code"
export EMACS_FONT_SIZE=16
export EMACS_COLOR_THEME="doom-outrun-electric"
export EMACS_COLOR_THEME_PACKAGE="doom-themes"


eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(fnm env --use-on-cd)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# TAB COMPLETIONS
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
# fnm completions --shell bash


# SET VARIABLES


# BASH PROFILE ALIASES
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvim-lazyvim='NVIM_APPNAME="nvim-lazyvim" nvim'
alias vi=nvim
alias vim=nvim
alias sourcebp='. ~/.zshrc'
alias lessbp='less ~/.zshrc'
alias catbp='cat ~/.zshrc'
alias emacsbp='emacs -nw ~/.zshrc'
alias vimbp='vi  ~/.zshrc'

# SSH
alias publickey='cat ~/.ssh/id_rsa.pub | pbcopy'
alias sshconfig='vi ~/.ssh/config'
alias knownhosts='vi ~/.ssh/known_hosts'

# SHORTCUT COMMANDS
# alias cd='cd_fnm'
alias ll='ls -laG'
alias code='cd ~/code'
alias cc='cd ~/code'
alias ccc='cat_common_commands'
alias vscode=' /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

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

glowlight() {
    glow -p -s ~/code/machine-config/.config/charm/glow/light.json $1
}

glowdark() {
    glow -p -s ~/code/machine-config/.config/charm/glow/dark.json $1
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

ap() {
    pipenv run ansible-playbook $1
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/kronning/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/Users/kronning/.opencode/bin:$PATH
