# ==========================================
# HISTORY
# ==========================================
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ==========================================
# GENERAL
# ==========================================
setopt AUTO_CD
setopt CORRECT
setopt GLOB_DOTS
setopt NO_BEEP
setopt PROMPT_SUBST

# ==========================================
# NAVIGATION AND KEYBOARD SHORTCUTS
# ==========================================
bindkey -e

bindkey '^H'       backward-kill-word   # CTRL+Backspace: delete previous word
bindkey '^[[3;5~'  kill-word            # CTRL+Delete: delete next word
bindkey '^[[1;5D'  backward-word        # CTRL+Left: move word backward
bindkey '^[[1;5C'  forward-word         # CTRL+Right: move word forward
bindkey '^[h'      backward-word
bindkey '^[l'      forward-word
bindkey '^[^?'     backward-kill-word   # Alt+Backspace
bindkey '^A'       beginning-of-line
bindkey '^E'       end-of-line
bindkey '^K'       kill-line
bindkey '^U'       kill-whole-line
bindkey '^R'       history-incremental-search-backward
bindkey '^[[H'     beginning-of-line
bindkey '^[[F'     end-of-line
bindkey '^[[1~'    beginning-of-line
bindkey '^[[4~'    end-of-line
bindkey '^[[7~'    beginning-of-line
bindkey '^[[8~'    end-of-line
bindkey '^[OH'     beginning-of-line
bindkey '^[OF'     end-of-line
bindkey '^[[3~'    delete-char
bindkey '^[[P'     delete-char

# ==========================================
# AUTOCOMPLETION
# ==========================================
autoload -U colors && colors
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

compdef _ls eza

# ==========================================
# ALIASES
# ==========================================

# Modern replacements
alias ls='eza -la --icons'
alias cat='bat --style=plain'
alias grep='rg'
alias find='fd'
alias top='btop'
alias du='dust'
alias df='duf'

# Colored fallbacks
alias diff='diff --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safe commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Useful
alias history='fc -l 1'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -E'
alias xclip='xclip -selection c'

# ==========================================
# FUNCTIONS
# ==========================================

extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

hgrep() {
    fc -l 1 | grep "$1"
}

dsize() {
    du -sh * | sort -h
}

# ==========================================
# ENVIRONMENT
# ==========================================
export PATH="$HOME/.local/bin:$PATH"
export ASDF_DATA_DIR="/opt/tools/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
export FILEMANAGER=thunar
export GTK_USE_PORTAL=0
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000

fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# ==========================================
# PLUGINS
# ==========================================
ZSH_PLUGINS="$HOME/.zsh/plugins"

if [[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi
if [[ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
fi

source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

eval $(keychain --eval --quiet ~/.ssh/github ~/.ssh/gitlab_kaffa)

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
fi

# Auto-start tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    if tmux has-session 2>/dev/null; then
        exec tmux attach
    else
        exec tmux new-session
    fi
fi

# Starship prompt (sempre por ultimo)
eval "$(starship init zsh)"
