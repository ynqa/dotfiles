#!/bin/sh -e

SCRIPT_ROOT=$(cd $(dirname $0); pwd)

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
    echo "Link dotfiles under \${HOME}"
    for dot in .??*; do
        if [ ${dot} = .git ]; then
            continue
        fi
        ln -snfv ${SCRIPT_ROOT}/${dot} ${HOME}/${dot}
    done
}

link_vscode_setting() {
    echo "Link vscode setting.json"
    # Mac
    # SETTINGS_DIR="${HOME}/Library/Application\ Support/Code/User/"
    # Ubuntu
    SETTINGS_DIR="${HOME}/.config/Code/User/"
    mkdir -p ${SETTINGS_DIR}
    ln -snfv ${SCRIPT_ROOT}/settings.json ${SETTINGS_DIR}/settings.json
}

add_gitignore() {
    git config --global core.excludesfile ${HOME}/.gitignore_global
}

init_zsh
init_anyenv
link_dots
link_vscode_setting
add_gitignore
