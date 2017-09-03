#!/usr/bin/env bash

function printHelp() {
cat << EOF

    IMPORTANT: Be sure to setup the script config at `echoGreen $CONFIG_FILE`
    An example config file can be found at ${CONFIG_FILE}.example

    Usage: ${PROGNAME}

    Create a new .bashrc file with the template at `echoBlue "<dir>/Others/.bashrc_template"`
    and the appropriate PATH variable.
EOF
}

function declareConstants() {
    readonly COMPILED_PATH_DIR="./path.c"
    readonly CONFIG_FILE="./data/config.properties"
}

function loadOptions() {
    # unusedBehaviour="IGNORE"
    return 0
}

function sedeasy {
  sed "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

function exportBashrc() {
    bashrcFile="./lib/.bashrc_template"

    test -f "$bashrcFile" || error "$bashrcFile file not found"

    mv "$HOME/.bashrc" > "$HOME/.bashrc.original"

    sedeasy "__PATH__" "$PWD" $bashrcFile > "$HOME/.bashrc"

    source $HOME/.bashrc
}

function compileScripts() {
    applyProperties="./path/applyProperties" # Uncompiled version

    test -d "$COMPILED_PATH_DIR" || mkdir "$COMPILED_PATH_DIR" || error "Failed to create $COMPILED_PATH_DIR"
    test -f "$CONFIG_FILE" || error "Config file $CONFIG_FILE not found"


    for script in "./path/"*; do
        compiled="$COMPILED_PATH_DIR/$(basename "$script")"

        cat "$script" | $applyProperties "$CONFIG_FILE" > "$compiled"
        chmod +x "$compiled"
    done
}

function run() {
    set +o nounset

    exportBashrc
    compileScripts
}

cd "$( dirname "${BASH_SOURCE[0]}" )"

source "./lib/scriptStarter"
