#!/bin/sh -e

SCRIPT_ROOT=$(cd $(dirname $0); pwd)

init_brew() {
    if test ! $(which brew); then
        echo "Install homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Install brew file..."
    brew install rcmdnk/file/brew-file

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

link_vscode_setting() {
    echo "Link vscode setting.json"
    ln -snfv ${SCRIPT_ROOT}/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
}

make_workspace() {
    cp -r workspace/ ${HOME}/workspace
    cd ${HOME}/workspace
    direnv allow
}

# go_pkg for vscode.
install_go_pkg() {
    go get -u -v github.com/nsf/gocode
    go get -u -v github.com/rogpeppe/godef
    go get -u -v github.com/zmb3/gogetdoc
    go get -u -v github.com/golang/lint/golint
    go get -u -v github.com/lukehoban/go-outline
    go get -u -v sourcegraph.com/sqs/goreturns
    go get -u -v golang.org/x/tools/cmd/gorename
    go get -u -v github.com/tpng/gopkgs
    go get -u -v github.com/newhook/go-symbols
    go get -u -v golang.org/x/tools/cmd/guru
    go get -u -v github.com/cweill/gotests/...
}

init_brew
init_zsh
init_anyenv
link_dots
link_vscode_setting
make_workspace
install_go_pkg
