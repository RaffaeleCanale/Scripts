# Scripts

Collection of miscellaneous bash scripts, including:

- Mount, sync and other actions for QNAP
- LaTex tools for building and creating documents from templates
- Open and place windows according to a workspace description (using `wmctrl`)
- etc...

# Installation

Rename `data/config.properties.example` to `data/config.properties` and fill the properties.

Then run:
```
./setUp.sh
```
**Warning**: This will replace your `.bashrc` file and move the original to `.bashrc.original`

This will setup the scripts and `PATH` variable.

# Usage

All the relevant scripts are added to `PATH` and are accessible anywhere.
All scripts support the `--help` option, eg:
```
qnap --help
```

### TODO
Add LaTex templates
