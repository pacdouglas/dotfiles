parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | awk '{print ""$0" "}'
}
PS1="\n ┌─(\[\033[1;32m\]\w\[\033[0m\]) \[\033[1;33m\]\$(parse_git_branch)\[\033[0m\]\n └> \[\033[0;32m\]\$\[\033[0m\] "
