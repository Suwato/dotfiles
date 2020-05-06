autoload -U compinit
compinit

# zplug start
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:19
zplug "zsh-users/zsh-history-substring-search"

zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"
zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-autosuggestions"

zplug "plugins/git", from:oh-my-zsh
# zplug "themes/gnzh", from:oh-my-zsh, nice:11

zplug "~/src/dotfiles/themes/gnzh-gcp.zsh-theme", from:local, nice:11 

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose
# zplug end

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

export LANG=ja_JP.UTF-8

export PYENV_ROOT=${HOME}/.pyenv
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [ -f "$(which dvm)" ]; then
  eval "$(dvm env)"
fi

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
export GRADLE_OPTS="-Dorg.gradle.daemon=true"
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$JAVA8_HOME/bin

# go のpath設定
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin

export GO15VENDOREXPERIMENT=1
export PATH=$PATH:$GOPATH/bin

export GO111MODULE=on

# terraform
export PATH=$PATH:~/terraform/

# php の path設定
export PATH=~/.phpenv/bin:$PATH
eval "$(phpenv init -)"

## Path settings
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:$PATH
# nvm より優先する
export PATH=~/.nodebrew/current/bin:$PATH

# google
export PATH=$PATH:~/google-cloud-sdk/bin
if [ -s ~/google-cloud-sdk/completion.zsh.inc ]; then
  source ~/google-cloud-sdk/completion.zsh.inc
fi

export PATH=$HOME/google-cloud-sdk/platform/google_appengine:$PATH

# misc
export PATH=~/.cabal/bin:$PATH
export PATH=$PATH:$(brew --prefix git)/share/git-core/contrib/diff-highlight
eval "$(rbenv init - zsh)"
export PATH=$PATH:~/bin
export PATH=$PATH:~/work/bin
export PATH=$PATH:/usr/texbin
export PATH=$PATH:~/src/dotfiles/bin

export MANPATH=/opt/local/man:$MANPATH

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi
export LESS='-R'


export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_all_dups
setopt hist_ignore_dups     # ignore duplication command history list
setopt hist_save_nodups
setopt share_history        # share command history data
# setopt correct
setopt append_history
setopt inc_append_history
setopt hist_no_store
setopt hist_reduce_blanks
setopt no_beep
setopt hist_ignore_space

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

autoload colors
colors

# alias 
alias ls="ls -G"
alias la="ls -laGF"
alias java7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7`"
alias java8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`"
alias gb="gb"
alias python="python3"

autoload -Uz add-zsh-hook

export EDITOR=vim
eval "$(direnv hook zsh)"

bindkey -e

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/satoutakashi/.sdkman"
[[ -s "/Users/satoutakashi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/satoutakashi/.sdkman/bin/sdkman-init.sh"
setopt nonomatch

function disable_git_push_origin_master() {
    if [[ $2 = "git push origin master" ]]; then 
            exit
    fi
}
export PATH="/usr/local/opt/bison@2.7/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/satoutakashi/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/satoutakashi/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/satoutakashi/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/satoutakashi/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
