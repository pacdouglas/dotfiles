function pauseSpotifyIn() {
    sleep $1 && dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
}

function find() {
	if [ $# = 1 ];
	then
		command find . -iname "*$@*"
	else
		command find "$@"
	fi
}

function extract () {
        if [ -f $1 ] ; then
                case $1 in
                        *.tar.bz2)        tar xjf $1                ;;
                        *.tar.gz)        tar xzf $1                ;;
                        *.bz2)                bunzip2 $1                ;;
                        *.rar)                rar x $1                ;;
                        *.gz)                gunzip $1                ;;
                        *.tar)                tar xf $1                ;;
                        *.tbz2)                tar xjf $1                ;;
                        *.tgz)                tar xzf $1                ;;
                        *.zip)                unzip $1                ;;
                        *.Z)                uncompress $1        ;;
                        *)                        echo "'$1' cannot be extracted via extract()" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
}

mvn_changed_modules(){
    [ -z "$1" ] && echo "Expected command : mvn_changed_modules (install/build/clean or any maven command)" && exit 0

        modules=$(git status | grep -E "modified:|deleted:|added:" | awk '{print $2}' | cut -f1 -d"/")

                if [  -z "$modules" ];
                then
                        echo "No changes (modified / deleted / added)  found"
                else
                        echo "Changed modules are : `echo $modules`"
                        mvn $1 -amd -pl $modules
                fi
}
