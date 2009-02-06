alias g='git'
alias gci='git ci -m'
alias gcia='git ci -a -m'
alias gpull='git pull origin master'
alias gpush='git push origin master'

export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend
PROMPT_COMMAND='history -a'

PS1="[\[\033[1;33m\]\h\[\033[0m\] \W]$ "


# Plesk server stuff
if [ -d /var/www/vhosts/ ]
then
    export PLESKVHOST=/var/www/vhosts
fi

if [ -d /home/httpd/vhosts ]
then
    export PLESKVHOST=/var/www/vhosts
fi

function _vhosts {
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts=`ls $PLESKVHOST`
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

function cdv {
    cd "$PLESKVHOST/$1/httpdocs"
    if [ "$?" -ne "0" ]; then
        return 1
    fi
    export LASTDOMAIN=$1 
}

function repermission {
    local user=`ls -la "$PLESKVHOST/$1/httpdocs" | awk '{ print $3 }' | grep -v 'root' | sort -n -r | head -n 1`
    echo "Setting to $user"
    chown -R "$user:psacln" "$PLESKVHOST/$1/httpdocs/$2"
}

complete -F "_vhosts" -o "default" "cdv"
complete -F "_vhosts" -o "default" "repermission"
