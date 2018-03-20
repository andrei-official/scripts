#!/usr/bin/env bash

lsb_release -a
echo "tested with ubuntu-17.10.1-desktop-amd64"

echo "installing dotnet dependencies"
sudo apt-get install \
    apt-transport-https \
    curl \
    gettext \
    install \
    libcurl3 \
    libicu57 \  # for 17.X
#   libicu52 \  # for 14.x
#   libicu55 \  # for 16.x
    libkrb5-3 \
    liblttng-ust0 \
    libssl1.0.0 \
    libunwind8 \
    libuuid1 \
    zlib1g \
    || failed=true
sudo apt-get update || failed=true

echo "trusting microsft gpg key"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

echo "installing dotnet [current coherent linux-x64]"
wget --tries 10 -O /tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh || failed=true
sh /tmp/dotnet-install.sh --channel Current --version coherent --verbose --runtime-id linux-x64 || failed=true

echo "installing VSCode [stable main]"
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update || failed=true
sudo apt-get dist-upgrade || failed=true
sudo apt-get install code || failed=true # or code-insiders
code --install-extension esbenp.prettier-vscode || failed=true
code --install-extension humao.rest-client || failed=true
code --install-extension ms-vscode.csharp || failed=true
code --install-extension robertohuertasm.vscode-icons || failed=true
code --install-extension ms-python.python || failed=true
code --install-extension ms-vscode.azure-account || failed=true
code --install-extension streetsidesoftware.code-spell-checker || failed=true
code --install-extension WallabyJs.quokka-vscode || failed=true
code --install-extension DavidAnson.vscode-markdownlint || failed=true
code --install-extension EditorConfig.EditorConfig || failed=true
code --install-extension eamodio.gitlens || failed=true
code --install-extension HookyQR.beautify || failed=true
code --install-extension ms-vscode.PowerShell || failed=true
code --install-extension PeterJausovec.vscode-docker || failed=true
code --install-extension donjayamanne.githistory || failed=true
code --install-extension alefragnani.Bookmarks || failed=true
code --install-extension waderyan.gitblame || failed=true
code --install-extension wayou.vscode-todo-highlight || failed=true
code --install-extension formulahendry.code-runner || failed=true
code --install-extension mohsen1.prettify-json || failed=true
code --install-extension kisstkondoros.vscode-codemetrics || failed=true

echo "installing git"
sudo apt-get install git || failed=true

echo "installing zsh"
sudo apt-get install zsh || failed=true
echo "tested with zsh 5.4.2"
zsh --version || failed=true

echo "checking if current shell is zsh"
echo $SHELL

echo "installing powerline fonts"
sudo apt-get install fonts-powerline || failed=true

echo "installing spaceship prompt"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
cat ZSH_THEME=spaceship >> ~/.zshrc
source ~/.zshrc

echo "installing npm 9.x"
wget --tries 10 -O /tmp/npm-install.sh https://deb.nodesource.com/setup_9.x || failed=true
sh /tmp/npm-install.sh
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

