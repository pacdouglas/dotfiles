eval "$(starship init zsh)"

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS

# History configuration
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

# Opções úteis do ZSH
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# General settings
setopt AUTO_CD             # automatic cd
setopt CORRECT             # command correction
setopt GLOB_DOTS           # include hidden files in glob
setopt NO_BEEP             # no beep sound
setopt PROMPT_SUBST        # prompt substitution

# ==========================================
# NAVIGATION AND KEYBOARD SHORTCUTS
# ==========================================

# Enable emacs mode for line editing
bindkey -e

# CTRL + Backspace: delete previous word
bindkey '^H' backward-kill-word

# CTRL + Delete: delete next word
bindkey '^[[3;5~' kill-word

# CTRL + Left Arrow: move word backward
bindkey '^[[1;5D' backward-word

# CTRL + Right Arrow: move word forward
bindkey '^[[1;5C' forward-word

# CTRL + H: move word backward (alternative)
bindkey '^[h' backward-word

# CTRL + L: move word forward (alternative)
bindkey '^[l' forward-word

# Alt + Backspace: delete word (backup)
bindkey '^[^?' backward-kill-word

# Other useful shortcuts
bindkey '^A' beginning-of-line      # CTRL + A: beginning of line
bindkey '^E' end-of-line           # CTRL + E: end of line
bindkey '^K' kill-line             # CTRL + K: delete to end
bindkey '^U' kill-whole-line       # CTRL + U: delete entire line
bindkey '^R' history-incremental-search-backward  # CTRL + R: history search

# Home and End keys
bindkey '^[[H' beginning-of-line     # Home key
bindkey '^[[F' end-of-line           # End key
bindkey '^[[1~' beginning-of-line    # Home key (alternative)
bindkey '^[[4~' end-of-line          # End key (alternative)

# xterm sequences
bindkey '^[[7~' beginning-of-line    # Home key (xterm)
bindkey '^[[8~' end-of-line          # End key (xterm)

# Additional common sequences
bindkey '^[OH' beginning-of-line     # Home key (tmux/screen)
bindkey '^[OF' end-of-line           # End key (tmux/screen)

# Delete key configurations
bindkey '^[[3~' delete-char          # Delete key (main)
bindkey '^[[P' delete-char           # Delete key (alternative)

# ==========================================
# ADVANCED AUTOCOMPLETION
# ==========================================

# Load completion system
autoload -Uz compinit
compinit

# Completion settings
zstyle ':completion:*' menu select                          # interactive menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'        # case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # colors for files
zstyle ':completion:*' rehash true                          # search for new executables
zstyle ':completion:*' accept-exact '*(N)'                 # accept exact matches
zstyle ':completion:*' use-cache on                        # use cache
zstyle ':completion:*' cache-path ~/.zsh/cache            # cache location

# Complete processes for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# ==========================================
# CUSTOM PROMPT
# ==========================================

# Colors
autoload -U colors && colors

# ==========================================
# USEFUL ALIASES
# ==========================================

# File listing
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lah'

# Colored commands
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# Safe commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Useful commands
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# System info
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -E'

# ==========================================
# PLUGINS AND ENHANCEMENTS
# ==========================================

# Syntax highlighting - try multiple locations
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions - try multiple locations
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
elif [[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
fi

source <(fzf --zsh)

# ==========================================
# USEFUL FUNCTIONS
# ==========================================

# Extract various archive formats
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

# Create directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Search in history
hgrep() {
    history | grep "$1"
}

# Directory sizes sorted
dsize() {
    du -sh * | sort -h
}

export PATH="$HOME/.local/bin:$PATH"
export ASDF_DATA_DIR="/opt/tools/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
export FILEMANAGER=thunar
export GTK_USE_PORTAL=0

# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
