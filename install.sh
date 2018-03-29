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

init_brew
init_zsh
init_anyenv
link_dots

