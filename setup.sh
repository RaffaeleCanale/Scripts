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
    $1 CONFIG_FILE "./user/config.properties"
}

function loadOptions() {
    # unusedBehaviour="IGNORE"
    return 0
}

function sedeasy {
  sed "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

function exportBashrc() {
    # TODO Allow to keep user .bashrc and only add core scripts
    bashrcFile="./lib/.bashrc_template"

    test -f "$bashrcFile" || error "$bashrcFile file not found"

    mv "$HOME/.bashrc" "$HOME/.bashrc.original"

    sedeasy "__PATH__" "$PWD" $bashrcFile > "$HOME/.bashrc"

    source $HOME/.bashrc
}

function compileScripts() {
    local src="$1"
    local dst="$2"
    local applyProperties="./path/applyProperties" # Uncompiled version


    test -d "$dst" || mkdir "$dst" || error "Failed to create $dst"

    for script in "$src/"*; do
        if [[ "$script" != *.md ]]; then
            compiled="$dst/$(basename "$script")"

            cat "$script" | $applyProperties "$CONFIG_FILE" > "$compiled"
            chmod +x "$compiled"
        fi
    done
}

function installNpmModules() {
    # TODO Get rid of this eventually
    for module in "./lib/modules/"*; do
        pushd $module > /dev/null

        chmod +x *

        if [ -f "package.json" ]; then
            npm install
        fi

        popd > /dev/null
    done
}

function runSetupScripts() {
    local path="./lib/setup.c"

    if [ -d "$path" ]; then
        for script in "$path/"*; do
            if [[ "$script" != *.md ]]; then
                . "$script"
            fi
        done
    fi
}

function setupJsync() {
    if [ ! -d ".jsync" ]; then
        input gdrive_dir "Name of the Google Drive directory: " true

        # TODO Add multi command to jsync
        # TODO Add whitelist/blacklist to init
        java -jar "./lib/JSync.jar" init
        java -jar "./lib/JSync.jar" remote gdrive "$gdrive_dir"
        java -jar "./lib/JSync.jar" copy-filters
    fi
}

function run() {
    set +o nounset

    if [ ! -f "$CONFIG_FILE" ]; then
        echoYellow "Config file $CONFIG_FILE not found"
        if inputYesNo "Use JSync to import settings from Google Drive?"; then
            setupJsync || error
        else
            error "Config file $CONFIG_FILE not found"
        fi
    fi

    if [ -d ".jsync" ]; then
        java -jar "./lib/JSync.jar" sync
    fi

    test -f "$CONFIG_FILE" || error

    # TODO Add logging system
    exportBashrc
    compileScripts "./lib/setup" "./lib/setup.c"
    compileScripts "./path" "./path.c"
    if [ -d "./user/user_path" ]; then
        compileScripts "./user/user_path" "./path.c"
    fi
    installNpmModules
    runSetupScripts
}

cd "$( dirname "${BASH_SOURCE[0]}" )"

source "./lib/scriptStarter"
