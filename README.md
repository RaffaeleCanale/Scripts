# Scripts

Collection of miscellaneous bash scripts, including:

- Mount, sync and other actions for QNAP
- LaTex tools for building and creating documents from templates
- Open and place windows according to a workspace description (using `wmctrl`)
- etc...

# Installation

Rename `user/config.properties.example` to `user/config.properties` and fill the properties.

Then run:
```
./setup.sh
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

**leds**: Ensure that `leds blink` restores the initial status of the led

**workspace**: 

Bugs: 
- Applying a workspace twice will shuffle order of windows of the same type

Improvements:
- Add more default workspace layouts in config
- Add custom layout depending on the screen count

**other**: ability to add and sync computer-dependent scripts and aliases (eg: stack scripts, ssh-add on startup, ...)

**other**: add 'export' to normalize scripts
