autoload -U compinit
compinit

# zplug start
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:19
zplug "zsh-users/zsh-history-substring-search"

zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"
zplug "zsh-users/zsh-completions"

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

export LANG=ja_JP.UTF-8

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [ -d ~/android-sdk ]; then
  export ANDROID_SDK_ROOT=~/android-sdk
elif [ -d ~/android-sdks ]; then
  export ANDROID_SDK_ROOT=~/android-sdks
elif [ -d ~/work/android-sdk-mac_x86 ]; then
  export ANDROID_SDK_ROOT=~/work/android-sdk-mac_x86
fi

if [ -f "$(which dvm)" ]; then
  eval "$(dvm env)"
fi

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)

export ANDROID_SDK_HOME=$ANDROID_SDK_ROOT
export ANDROID_HOME=$ANDROID_SDK_HOME
export ANDROID_NDK_ROOT=~/android-ndk-r9b
export ANDROID_AVD_HOME=$ANDROID_SDK_HOME/.android/avd 

export SCALA_HOME=/opt/local/share/scala
export PLAY_HOME=~/work/play-2.0.4

export DART_SDK=/Applications/dart/dart-sdk

# https://bitbucket.org/ymotongpoo/goenv
export GOPATH=~/Dropbox/work/go-work
export GOROOT=$(brew --prefix go)/libexec
export PATH=$PATH:$GOPATH/bin
export APPENGINE_DEV_APPSERVER=~/go_appengine/dev_appserver.py
export PATH=$PATH:~/go_appengine

export NACL_SDK_ROOT=~/nacl_sdk/pepper_31

if [ -s /opt/local/bin/phantomjs ]; then
  export PHANTOMJS_BIN=/opt/local/bin/phantomjs
elif [ -s /usr/local/bin/phantomjs ]; then
  export PHANTOMJS_BIN=/usr/local/bin/phantomjs
fi

# boot2docker up するたびに変わるのでこの対応はあまりよくないかも
# $(boot2docker shellinit)

# setup gvm (Groovy)
if [ -s ~/.gvm/bin/gvm-init.sh ]; then
  source ~/.gvm/bin/gvm-init.sh
fi
export GRADLE_OPTS="-Dorg.gradle.daemon=true"

if [ -s ~/google-cloud-sdk/completion.zsh.inc ]; then
  source ~/google-cloud-sdk/completion.zsh.inc
fi

## Path settings
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:$PATH
# nvm より優先する
export PATH=~/.nodebrew/current/bin:$PATH
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$JAVA8_HOME/bin
# android
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_NDK_ROOT
# google
export PATH=$PATH:~/google-cloud-sdk/bin
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

export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"

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

# alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ls="ls -G"
alias la="ls -laGF"
alias emacs="open -a Emacs"
alias pwdweb="python -m SimpleHTTPServer 8989"
alias java7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7`"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/satoutakashi/.sdkman"
[[ -s "/Users/satoutakashi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/satoutakashi/.sdkman/bin/sdkman-init.sh"
