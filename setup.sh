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
    getOpt "-j|--jsync" useJsync
    return 0
}

function compile() {
    local src="$1"
    local dst="$2"

    test -d "$dst" || mkdir "$dst" || error

    for file in "$src/"*; do
        local fileC="$dst/$(basename "$file")"
        if [ -d "$file" ]; then
            if [ "$(basename $file)" != "node_modules" ]; then
                compile "$file" "$fileC"
            else
                cp -r "$file" "$fileC"
            fi
        else
            verboseR "$file"
            ./builtin/helpers/compiler "$file" "$fileC" "$CONFIG_FILE"
        fi
    done
}

function run() {
    verbose=true
    set +o nounset

    export SCRIPTS="$PWD/scripts.c"
    export SCRIPTS_HELPERS="$PWD/builtin/helpers"

    if $useJsync; then
        ./scripts/setup/setup_jsync

        if [ -d ".jsync" ]; then
            java -jar "./builtin/bin/JSync.jar" sync
        fi
    fi



    test -f "$CONFIG_FILE" || error "Config file $CONFIG_FILE not found"
    # ./scripts/setup/copy_bashrc

    SCRIPTS_HELPERS="$SCRIPTS_HELPERS" compile ./scripts ./scripts.c

    ./scripts.c/setup/copy_bashrc -v
    ./scripts.c/setup/atom_settings -v
    ./scripts.c/setup/install_projects -v
    # TODO Add logging system

}

cd "$( dirname "${BASH_SOURCE[0]}" )"
source "./builtin/helpers/scriptStarter"
