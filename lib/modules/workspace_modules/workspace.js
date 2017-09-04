'use strict'

const async = require('async')
const exec = require('child_process').exec;


const WindowModules = require('./window_modules')
const App = require('./app')

const configFile = process.argv[2]
const mode = process.argv[3]
const name = process.argv[4]

let globals = {
    currentDesktop: undefined,
    windowsIdentified: {},

    get desktop() {
        return globals.currentDesktop
    },

    retain: function (id) {
        globals.windowsIdentified[id] = true
    },

    hasAppWith: function (id) {
        return globals.windowsIdentified[id]
    }
}

function parseConfigFile() {
    return require(configFile)
}

function printArray(array) {
    console.log(array.join('\n'));
}


function applyWorkspace(apps) {
    async.series([
        async.each.bind(null, apps, (app, cb) => app.validate(cb)),
        WindowModules.init.bind(WindowModules),
        getCurrentDesktop,
        async.each.bind(null, apps, (app, cb) => app.tryIdentify(globals, cb)),
        async.each.bind(null, apps, (app, cb) => app.tryOpen(cb)),
        async.each.bind(null, apps, (app, cb) => app.identify(globals, cb)),
        async.each.bind(null, apps, (app, cb) => app.move(cb))
    ], (err, res) => {
        if (err) console.error(err)
    })
}

function getCurrentDesktop(callback) {
    return WindowModules.execute('currentDesktop', (err, res) => {
        if (err) return callback(err)

        globals.currentDesktop = res
        return callback()
    })
}


function findWorkspace(name) {
    const config = parseConfigFile()

    let index = Number(name)
    if (index) {
        for (let workspace in config) {
            if (config.hasOwnProperty(workspace) && workspace !== '_comments') {
                if (typeof config[workspace].index === 'number' && config[workspace].index === index)
                    return config[workspace]
            }
        }

        return null
    } else {
        return config[name]
    }
}

function workspaceToString(name, w) {
    let prefix = w.index
    if (prefix === undefined) prefix = '-'

    return prefix + ' ' + name
}

switch (mode) {
    case 'list':
        const config = parseConfigFile()
        return printArray(Object.keys(config)
                .filter((key) => key !== '_comments')
                .map(w => workspaceToString(w, config[w])))
    case 'apply':
        const workspace = findWorkspace(name)
        if (!workspace) return console.error('Workspace not found')
        if (!workspace.apps) return console.error('Apps not found in workspace')

        return applyWorkspace(
            workspace.apps.map((config) => new App(config, workspace.globals))
        )
    default:
        return console.error('Unkown mode: ' + mode)
}
