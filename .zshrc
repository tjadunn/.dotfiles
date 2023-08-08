export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

HISTSIZE=99999
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE

#set -o vi
#comment these out as it messes with sdk
#SCALA_HOME="/usr/local/share/scala-2.11.8"
#PATH="${SCALA_HOME}/bin:/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"

export SPARK_HOME=/Users/tobydunn/Dev/spark-3.3.1-bin-hadoop3
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PATH=$SPARK_HOME/bin/:$PATH
export PYSPARK_DRIVER_PYTHON=ipython

# Kafka
export PATH=/Users/tobydunn/Dev/kafka_2.13-3.3.1/bin/:$PATH

#scala coursier
export PATH="$PATH:/Users/tobydunn/Library/Application Support/Coursier/bin"

#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias l='ls -l'
alias ll='ls -Al'

alias weather='function _weather() { curl wttr.in/$1; };_weather'
alias diffstash='function _diffstash() { git diff HEAD stash@{$1} -- $2; };_diffstash'

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

alias vgitdiff='git difftool --tool=vimdiff --no-prompt'
# Add an "alert" alias for long running commands.  Use like so:


# Setting PATH for Python 3.11
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[ -f "/Users/tobydunn/.ghcup/env" ] && source "/Users/tobydunn/.ghcup/env" # ghcup-env

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tobydunn/Dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tobydunn/Dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tobydunn/Dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tobydunn/Dev/google-cloud-sdk/completion.zsh.inc'; fi
alias dotfiles='/usr/bin/git --git-dir=/Users/tobydunn/.dotfiles/ --work-tree=/Users/tobydunn'
