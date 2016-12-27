git submodule init
git submodule update

./ln.sh
./brew.sh

# Macの設定
defaults write com.apple.dock autohide -bool Yes; killall Dock

# ssh公開鍵をいろいろなところに配る
# JDK 入れる
# brew cask alfred link

# sudo vi /etc/shells に /usr/local/bin/zsh 追加して chsh -s /usr/local/bin/zsh
