#!/usr/bin/env bash

function printHelp() {
cat << EOF

	Usage:
	${PROGNAME}

	Create a new .bashrc file with the template at `echoBlue "<dir>/Others/.bashrc_template"`
	and the appropriate PATH variable
EOF
}

function declareConstants() {
	return 0
}

function loadOptions() {
	# unusedBehaviour="IGNORE"
	return 0
}

function sedeasy {
  sed "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

function run () {
    bashrcFile="./Others/.bashrc_template"

    test -f "$bashrcFile" || error "$bashrcFile file not found"

	sedeasy "__PATH__" "$PWD" $bashrcFile > "$HOME/.bashrc"
}

cd "$( dirname "${BASH_SOURCE[0]}" )"

source "./Others/scriptStarter"
