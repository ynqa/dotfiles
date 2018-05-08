#!/bin/sh -e

SCRIPT_ROOT=$(cd $(dirname $0); pwd)

init_brew() {
    if test ! $(which brew); then
        echo "Install homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Install brew file..."
    brew install rcmdnk/file/brew-file

    echo "Install java8..."
    brew cask install caskroom/versions/java8

    echo "Install brew packages from Brewfile..."
    brew file install -f Brewfile
}

init_zsh() {
    echo "Set zsh to \$SHELL..."
    if [ ${SHELL} != "/bin/zsh" ]; then
        chsh -s /bin/zsh
    fi
}

init_anyenv() {
    echo "Install anyenv (with update) and pyenv..."
    if [ ! -e ${HOME}/.anyenv ]; then
        git clone https://github.com/riywo/anyenv ${HOME}/.anyenv
        mkdir -p $(anyenv root)/plugins
        git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
    fi
}

link_dots() {
    echo "Link dotfiles under \$HOME"
    for dot in .??*; do
        [[ ${dot} = ".git" ]] && continue
        ln -snfv ${SCRIPT_ROOT}/${dot} ${HOME}/${dot}
    done
}

install_vscode_package() {
    echo "Install vscode packages"
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension robertohuertasm.vscode-icons
    code --install-extension ms-vscode.go
    code --install-extension PeterJausovec.vscode-docker
    code --install-extension mauve.terraform
    code --install-extension DevonDCarew.bazel-code
}

link_vscode_setting() {
    echo "Link vscode setting.json"
    mkdir -p ${HOME}/Library/Application\ Support/Code/User/
    ln -snfv ${SCRIPT_ROOT}/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
}

make_workspace() {
    cp -r workspace/ ${HOME}/workspace
    cd ${HOME}/workspace
    direnv allow
}

# go_pkg for vscode.
install_go_pkg() {
    GOPATH=${HOME}/workspace go get -u -v github.com/nsf/gocode
    GOPATH=${HOME}/workspace go get -u -v github.com/rogpeppe/godef
    GOPATH=${HOME}/workspace go get -u -v github.com/zmb3/gogetdoc
    GOPATH=${HOME}/workspace go get -u -v github.com/golang/lint/golint
    GOPATH=${HOME}/workspace go get -u -v github.com/lukehoban/go-outline
    GOPATH=${HOME}/workspace go get -u -v sourcegraph.com/sqs/goreturns
    GOPATH=${HOME}/workspace go get -u -v golang.org/x/tools/cmd/gorename
    GOPATH=${HOME}/workspace go get -u -v github.com/tpng/gopkgs
    GOPATH=${HOME}/workspace go get -u -v github.com/newhook/go-symbols
    GOPATH=${HOME}/workspace go get -u -v golang.org/x/tools/cmd/guru
    GOPATH=${HOME}/workspace go get -u -v github.com/cweill/gotests/...
}

init_brew
init_zsh
init_anyenv
link_dots
install_vscode_package
link_vscode_setting
make_workspace
install_go_pkg
